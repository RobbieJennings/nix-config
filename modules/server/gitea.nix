{
  inputs,
  ...
}:
{
  flake.modules.nixos.gitea =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "gitea";
        repo = "https://dl.gitea.io/charts";
        version = "12.4.0";
        hash = "sha256-AAs1JMBWalE0PE4WJUHy6aNMcouETl+LV1IqW31tsn4=";
      };
      giteaImage = pkgs.dockerTools.pullImage {
        imageName = "gitea/gitea";
        imageDigest = "sha256:2edc102cbb636ae1ddac5fa0c715aa5b03079dee13ac6800b2cef6d4e912e718";
        sha256 = "sha256-ovGz6WbtnVntxRt/py4iKg4ZnCj90DK/hQwpgdk/D3I=";
        finalImageTag = "1.24.6";
        arch = "amd64";
      };
      postgresqlImage = pkgs.dockerTools.pullImage {
        imageName = "bitnamilegacy/postgresql";
        imageDigest = "sha256:926356130b77d5742d8ce605b258d35db9b62f2f8fd1601f9dbaef0c8a710a8d";
        sha256 = "sha256-cKcahA8r6524qghk9QMYUtG5oGQTKMVme29Lz9lQOGU=";
        finalImageTag = "17.6.0-debian-12-r4";
        arch = "amd64";
      };
      valkeyImage = pkgs.dockerTools.pullImage {
        imageName = "bitnamilegacy/valkey";
        imageDigest = "sha256:4f0191fba7d3ffc38362381fa0ecac3c570dac56621278bcda513b477c8308c4";
        sha256 = "sha256-8bOuxrEB2dU2Us+N5MnP9tIqLnIDOsw0UA3+wSWlz9M=";
        finalImageTag = "8.1.3-debian-12-r3";
        arch = "amd64";
      };
    in
    {
      options = {
        gitea.enable = lib.mkEnableOption "Gitea Helm chart on k3s";
        secrets.gitea.enable = lib.mkEnableOption "Gitea secrets";
      };

      config = lib.mkMerge [
        (lib.mkIf config.gitea.enable {
          services.k3s = {
            images = [
              giteaImage
              postgresqlImage
              valkeyImage
            ];
            autoDeployCharts.gitea = chart // {
              targetNamespace = "gitea";
              createNamespace = true;
              values = {
                global = {
                  imageRegistry = "docker.io";
                };
                image = {
                  repository = giteaImage.imageName;
                  tag = giteaImage.imageTag;
                  rootless = false;
                };
                gitea = {
                  admin =
                    if (config.secrets.enable && config.secrets.gitea.enable) then
                      {
                        existingSecret = "gitea-secrets";
                      }
                    else
                      {
                        username = "admin";
                        password = "changeme";
                        email = "admin@local";
                      };
                  config = {
                    server = {
                      DOMAIN = "192.168.1.204";
                      ROOT_URL = "http://192.168.1.204:3000";
                    };
                    indexer = {
                      ISSUE_INDEXER_TYPE = "bleve";
                      REPO_INDEXER_ENABLED = true;
                    };
                  };
                };
                service = {
                  http = {
                    type = "LoadBalancer";
                    loadBalancerIP = "192.168.1.204";
                    annotations = {
                      "metallb.io/address-pool" = "default";
                      "metallb.io/allow-shared-ip" = "gitea";
                    };
                  };
                  ssh = {
                    type = "LoadBalancer";
                    loadBalancerIP = "192.168.1.204";
                    annotations = {
                      "metallb.io/address-pool" = "default";
                      "metallb.io/allow-shared-ip" = "gitea";
                    };
                  };
                };
                persistence = {
                  enabled = true;
                  size = "25Gi";
                };
                resources = {
                  requests.cpu = "50m";
                  requests.memory = "128Mi";
                  limits.cpu = "300m";
                  limits.memory = "256Mi";
                };
                dnsConfig.options = [
                  # Needed for hardcoded valkey address to resolve in configure-gitea container
                  # Fixed in master branch, should be available in 12.6.0
                  # https://gitea.com/gitea/helm-gitea/commit/3cc94ca9a67060f86f606b420cc2adafb83f4d29
                  {
                    name = "ndots";
                    value = "0";
                  }
                ];
                postgresql-ha.enabled = false;
                postgresql = {
                  enabled = true;
                  image = {
                    repository = postgresqlImage.imageName;
                    tag = postgresqlImage.imageTag;
                  };
                  primary = {
                    persistence = {
                      enabled = true;
                      size = "8Gi";
                    };
                    resources = {
                      requests.cpu = "50m";
                      requests.memory = "128Mi";
                      limits.cpu = "300m";
                      limits.memory = "256Mi";
                    };
                    extraEnvVars = [
                      {
                        name = "POSTGRESQL_SHARED_BUFFERS";
                        value = "65MB";
                      }
                      {
                        name = "POSTGRESQL_EFFECTIVE_CACHE_SIZE";
                        value = "192MB";
                      }
                    ];
                  };
                };
                valkey-cluster.enabled = false;
                valkey = {
                  enabled = true;
                  image = {
                    repository = valkeyImage.imageName;
                    tag = valkeyImage.imageTag;
                  };
                  primary = {
                    persistence = {
                      enabled = true;
                      size = "8Gi";
                    };
                    resources = {
                      requests.cpu = "20m";
                      requests.memory = "64Mi";
                      limits.cpu = "100m";
                      limits.memory = "128Mi";
                    };
                    extraFlags = [
                      "--maxmemory 100mb"
                      "--maxmemory-policy allkeys-lru"
                    ];
                  };
                };
              };
              extraDeploy = [
                {
                  apiVersion = "v1";
                  kind = "Service";
                  metadata = {
                    name = "gitea-tailscale";
                    namespace = "gitea";
                    annotations = {
                      "tailscale.com/expose" = "true";
                      "tailscale.com/hostname" = "gitea";
                    };
                  };
                  spec = {
                    type = "ClusterIP";
                    selector = {
                      "app.kubernetes.io/name" = "gitea";
                      "app.kubernetes.io/instance" = "gitea";
                      "app" = "gitea";
                    };
                    ports = [
                      {
                        name = "http";
                        port = 80;
                        targetPort = 3000;
                        protocol = "TCP";
                      }
                      {
                        name = "ssh";
                        port = 22;
                        targetPort = 2222;
                        protocol = "TCP";
                      }
                    ];
                  };
                }
              ];
            };
          };
        })
        (lib.mkIf (config.gitea.enable && config.secrets.enable && config.secrets.gitea.enable) {
          sops = {
            secrets = {
              "gitea/username" = { };
              "gitea/password" = { };
              "gitea/email" = { };
              "gitea/key" = { };
            };
            templates.giteaSecrets = {
              content = builtins.toJSON {
                apiVersion = "v1";
                kind = "Secret";
                type = "Opaque";
                metadata = {
                  name = "gitea-secrets";
                  namespace = "gitea";
                };
                stringData = {
                  username = config.sops.placeholder."gitea/username";
                  password = config.sops.placeholder."gitea/password";
                  email = config.sops.placeholder."gitea/email";
                };
              };
              path = "/var/lib/rancher/k3s/server/manifests/gitea-secret.json";
            };
          };
        })
      ];
    };
}
