{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.nextcloud-valkey = self.factory.valkey {
    namespace = "nextcloud";
    values = {
      resources = {
        requests.cpu = "20m";
        requests.memory = "64Mi";
        limits.cpu = "100m";
        limits.memory = "128Mi";
      };
      auth = {
        enabled = true;
        usersExistingSecret = "nextcloud-secrets";
        aclUsers.default = {
          permissions = "~* &* +@all";
          passwordKey = "valkey-password";
        };
      };
    };
  };

  flake.modules.nixos.nextcloud =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "nextcloud";
        repo = "https://nextcloud.github.io/helm";
        version = "8.7.0";
        hash = "sha256-LoEz0+iETV9kBxiRB7aML4Jzk4LhmrUQMHBQipYnWzE=";
      };
      nextcloudImage = pkgs.dockerTools.pullImage {
        imageName = "nextcloud";
        imageDigest = "sha256:a9ef7ed15dbf3f9fcf6dc2a41a15af572fcc077f220640cabfe574a3ffbf5766";
        sha256 = "sha256-Z9/e4KP2gH6HP+pglHpWGK0cnmReJjR1InRh8kfjUmQ=";
        finalImageTag = "32.0.3";
        arch = "amd64";
      };
      collaboraImage = pkgs.dockerTools.pullImage {
        imageName = "collabora/code";
        imageDigest = "sha256:4585c88c15d681a04495e9881e99974040373089b941d6909f9c9e817553457c";
        sha256 = "sha256-di7mSLOlmF0utm37w0FWySFKHiKJ2/EuMeHQMT7Py8s=";
        finalImageTag = "25.04.7.2.1";
        arch = "amd64";
      };
    in
    {
      imports = [ inputs.self.modules.nixos.nextcloud-valkey ];

      options = {
        nextcloud.enable = lib.mkEnableOption "nextcloud helm chart on k3s";
        secrets.nextcloud.enable = lib.mkEnableOption "Nextcloud secrets";
      };

      config = lib.mkMerge [
        (lib.mkIf config.nextcloud.enable {
          nextcloud-valkey.enable = true;
          services.k3s = {
            images = [
              nextcloudImage
              collaboraImage
            ];
            autoDeployCharts.nextcloud = chart // {
              targetNamespace = "nextcloud";
              createNamespace = true;
              values = {
                image = {
                  repository = nextcloudImage.imageName;
                  tag = nextcloudImage.imageTag;
                };
                nextcloud = {
                  host = "192.168.1.203";
                  trustedDomains = [
                    "192.168.1.203"
                    "nextcloud"
                  ];
                  existingSecret = {
                    enabled = true;
                    secretName = "nextcloud-secrets";
                    usernameKey = "nextcloud-username";
                    passwordKey = "nextcloud-password";
                  };
                  extraEnv = [
                    {
                      name = "REDIS_HOST";
                      value = "nextcloud-valkey";
                    }
                    {
                      name = "REDIS_HOST_PORT";
                      value = "6379";
                    }
                    {
                      name = "REDIS_HOST_PASSWORD";
                      valueFrom = {
                        secretKeyRef = {
                          name = "nextcloud-secrets";
                          key = "valkey-password";
                        };
                      };
                    }
                  ];
                };
                service = {
                  type = "ClusterIP";
                  port = 80;
                  annotations = {
                    "tailscale.com/expose" = "true";
                    "tailscale.com/hostname" = "nextcloud";
                  };
                };
                persistence = {
                  enabled = true;
                  size = "8Gi";
                  nextcloudData = {
                    enabled = true;
                    size = "25Gi";
                  };
                };
                resources = {
                  requests.cpu = "200m";
                  requests.memory = "1Gi";
                  limits.cpu = "800m";
                  limits.memory = "2Gi";
                };
                internalDatabase.enabled = false;
                externalDatabase = {
                  enabled = true;
                  type = "postgresql";
                  host = "nextcloud-postgres-rw";
                  existingSecret = {
                    enabled = true;
                    secretName = "nextcloud-secrets";
                    usernameKey = "username";
                    passwordKey = "password";
                  };
                };
                collabora = {
                  enabled = true;
                  image = {
                    repository = collaboraImage.imageName;
                    tag = collaboraImage.imageTag;
                  };
                  service = {
                    type = "ClusterIP";
                    port = 80;
                    annotations = {
                      "tailscale.com/expose" = "true";
                      "tailscale.com/hostname" = "nextcloud-collabora";
                    };
                  };
                  resources = {
                    requests.cpu = "200m";
                    requests.memory = "1Gi";
                    limits.cpu = "800m";
                    limits.memory = "2Gi";
                  };
                };
                cronjob = {
                  enabled = true;
                  type = "sidecar";
                  resources = {
                    requests.cpu = "50m";
                    requests.memory = "128Mi";
                    limits.cpu = "300m";
                    limits.memory = "256Mi";
                  };
                };
                livenessProbe = {
                  initialDelaySeconds = 300;
                  periodSeconds = 30;
                };
                readinessProbe = {
                  initialDelaySeconds = 300;
                  periodSeconds = 30;
                };
              };
              extraDeploy = [
                {
                  apiVersion = "postgresql.cnpg.io/v1";
                  kind = "Cluster";
                  metadata = {
                    namespace = "nextcloud";
                    name = "nextcloud-postgres";
                  };
                  spec = {
                    instances = 1;
                    imageCatalogRef = {
                      apiGroup = "postgresql.cnpg.io";
                      kind = "ClusterImageCatalog";
                      name = "postgresql-global";
                      major = 18;
                    };
                    storage.size = "8Gi";
                    managed.roles = [
                      {
                        name = "nextcloud";
                        passwordSecret.name = "nextcloud-secrets";
                        login = true;
                      }
                    ];
                    bootstrap.initdb = {
                      database = "nextcloud";
                      owner = "nextcloud";
                      secret.name = "nextcloud-secrets";
                    };
                    resources = {
                      requests.cpu = "100m";
                      requests.memory = "256Mi";
                      limits.cpu = "500m";
                      limits.memory = "512Mi";
                    };
                  };
                }
                {
                  apiVersion = "v1";
                  kind = "Service";
                  metadata = {
                    name = "nextcloud-lb";
                    namespace = "nextcloud";
                    annotations = {
                      "metallb.io/address-pool" = "default";
                      "metallb.io/allow-shared-ip" = "nextcloud";
                    };
                  };
                  spec = {
                    type = "LoadBalancer";
                    loadBalancerIP = "192.168.1.203";
                    selector = {
                      "app.kubernetes.io/component" = "app";
                      "app.kubernetes.io/instance" = "nextcloud";
                      "app.kubernetes.io/name" = "nextcloud";
                    };
                    ports = [
                      {
                        name = "http";
                        port = 8080;
                        targetPort = 80;
                        protocol = "TCP";
                      }
                    ];
                  };
                }
              ];
            };
          };
        })
        (lib.mkIf (config.nextcloud.enable && config.secrets.enable && config.secrets.nextcloud.enable) {
          sops = {
            secrets = {
              "nextcloud/username" = { };
              "nextcloud/password" = { };
              "nextcloud/postgres_password" = { };
              "nextcloud/valkey_password" = { };
            };
            templates.nextcloudSecrets = {
              content = builtins.toJSON {
                apiVersion = "v1";
                kind = "Secret";
                type = "Opaque";
                metadata = {
                  name = "nextcloud-secrets";
                  namespace = "nextcloud";
                };
                stringData = {
                  nextcloud-username = config.sops.placeholder."nextcloud/username";
                  nextcloud-password = config.sops.placeholder."nextcloud/password";
                  username = "nextcloud";
                  password = config.sops.placeholder."nextcloud/postgres_password";
                  valkey-password = config.sops.placeholder."nextcloud/valkey_password";
                };
              };
              path = "/var/lib/rancher/k3s/server/manifests/nextcloud-secret.json";
            };
          };
        })
      ];
    };
}
