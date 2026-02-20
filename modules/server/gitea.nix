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
                image = {
                  registry = "docker.io";
                  repository = giteaImage.imageName;
                  tag = giteaImage.imageTag;
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
                      DOMAIN = "192.168.0.204";
                      ROOT_URL = "http://192.168.0.204:3000";
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
                    loadBalancerIP = "192.168.0.204";
                    annotations = {
                      "metallb.io/address-pool" = "default";
                      "metallb.io/allow-shared-ip" = "gitea";
                    };
                  };
                  ssh = {
                    type = "LoadBalancer";
                    loadBalancerIP = "192.168.0.204";
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
                  requests.cpu = "500m";
                  requests.memory = "512Mi";
                  limits.cpu = "1000m";
                  limits.memory = "1Gi";
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
                      requests.cpu = "500m";
                      requests.memory = "512Mi";
                      limits.cpu = "1000m";
                      limits.memory = "1Gi";
                    };
                    extraEnvVars = [
                      {
                        name = "POSTGRESQL_SHARED_BUFFERS";
                        value = "256MB";
                      }
                      {
                        name = "POSTGRESQL_EFFECTIVE_CACHE_SIZE";
                        value = "768MB";
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
                      requests.cpu = "100m";
                      requests.memory = "128Mi";
                      limits.cpu = "200m";
                      limits.memory = "256Mi";
                    };
                    extraFlags = [
                      "--maxmemory 200mb"
                      "--maxmemory-policy allkeys-lru"
                    ];
                  };
                };
              };
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
