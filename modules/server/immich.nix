{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.immich-valkey = self.factory.valkey {
    namespace = "immich";
    values = {
      resources = {
        requests.cpu = "20m";
        requests.memory = "64Mi";
        limits.cpu = "100m";
        limits.memory = "128Mi";
      };
      auth = {
        enabled = true;
        usersExistingSecret = "immich-secrets";
        aclUsers.default = {
          permissions = "~* &* +@all";
          passwordKey = "valkey-password";
        };
      };
    };
  };

  flake.modules.nixos.immich =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "immich";
        repo = "https://immich-app.github.io/immich-charts";
        version = "0.11.1";
        hash = "sha256-TiMy4nPuNnF2tb3Y+wwXofYEYqigWswuSo6po6LmnXY=";
      };
      image = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/immich-app/immich-server";
        imageDigest = "sha256:0cc1f82953d9598eb9e9dd11cbde1f50fe54f9c46c4506b089e8ad7bfc9d1f0c";
        sha256 = "sha256-gk2+L9TS/3/icxEOIcS/kj83aFzHO/4KZ0nT0PVG2oQ=";
        finalImageTag = "v2.6.3";
        arch = "amd64";
      };
    in
    {
      imports = [ inputs.self.modules.nixos.immich-valkey ];

      options = {
        immich.enable = lib.mkEnableOption "Immich helm chart on k3s";
        secrets.immich.enable = lib.mkEnableOption "Immich secrets";
      };

      config = lib.mkMerge [
        (lib.mkIf config.immich.enable {
          immich-valkey.enable = true;
          services.k3s = {
            images = [ image ];
            autoDeployCharts = {
              immich = chart // {
                targetNamespace = "immich";
                createNamespace = true;
                values = {
                  server = {
                    controllers.main.containers.main = {
                      image = {
                        repository = image.imageName;
                        tag = image.imageTag;
                      };
                      env = {
                        DB_HOSTNAME = "immich-postgres-rw";
                        DB_DATABASE_NAME = "immich";
                        DB_USERNAME = {
                          valueFrom = {
                            secretKeyRef = {
                              name = "immich-secrets";
                              key = "username";
                            };
                          };
                        };
                        DB_PASSWORD = {
                          valueFrom = {
                            secretKeyRef = {
                              name = "immich-secrets";
                              key = "password";
                            };
                          };
                        };
                        REDIS_HOSTNAME = "immich-valkey";
                        REDIS_PORT = "6379";
                        REDIS_PASSWORD = {
                          valueFrom = {
                            secretKeyRef = {
                              name = "immich-secrets";
                              key = "valkey-password";
                            };
                          };
                        };
                      };
                      resources = {
                        requests.cpu = "200m";
                        requests.memory = "256Mi";
                        limits.cpu = "1500m";
                        limits.memory = "1Gi";
                      };
                    };
                  };
                  service.main = {
                    type = "LoadBalancer";
                    annotations = {
                      "metallb.io/address-pool" = "default";
                      "metallb.io/allow-shared-ip" = "immich";
                      "metallb.io/loadBalancerIPs" = "192.168.1.205";
                    };
                  };
                  immich.persistence.library.existingClaim = "immich-pvc";
                  machine-learning.enabled = false;
                };
                extraDeploy = [
                  {
                    apiVersion = "v1";
                    kind = "PersistentVolumeClaim";
                    metadata = {
                      name = "immich-pvc";
                      namespace = "immich";
                    };
                    spec = {
                      accessModes = [ "ReadWriteOnce" ];
                      resources = {
                        requests = {
                          storage = "25Gi";
                        };
                      };
                    };
                  }
                  {
                    apiVersion = "postgresql.cnpg.io/v1";
                    kind = "Cluster";
                    metadata = {
                      namespace = "immich";
                      name = "immich-postgres";
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
                          name = "immich";
                          passwordSecret.name = "immich-secrets";
                          superuser = true;
                          login = true;
                        }
                      ];
                      bootstrap.initdb = {
                        database = "immich";
                        owner = "immich";
                        secret.name = "immich-secrets";
                      };
                      resources = {
                        requests.cpu = "200m";
                        requests.memory = "256Mi";
                        limits.cpu = "1000m";
                        limits.memory = "1Gi";
                      };
                    };
                  }
                  {
                    apiVersion = "v1";
                    kind = "Service";
                    metadata = {
                      name = "immich";
                      namespace = "immich";
                    };
                    spec = {
                      type = "ClusterIP";
                      selector = {
                        "app.kubernetes.io/controller" = "main";
                        "app.kubernetes.io/instance" = "immich";
                        "app.kubernetes.io/name" = "server";
                      };
                      ports = [
                        {
                          name = "http";
                          port = 80;
                          targetPort = 2283;
                          protocol = "TCP";
                        }
                      ];
                    };
                  }
                  {
                    apiVersion = "netbird.io/v1alpha1";
                    kind = "NetworkResource";
                    metadata = {
                      name = "immich";
                      namespace = "immich";
                    };
                    spec = {
                      networkRouterRef = {
                        name = "homelab";
                        namespace = "netbird";
                      };
                      serviceRef = {
                        name = "immich";
                        namespace = "immich";
                      };
                      groups = [ { name = "All"; } ];
                    };
                  }
                ];
              };
            };
          };
        })
        (lib.mkIf (config.immich.enable && config.secrets.enable && config.secrets.immich.enable) {
          sops = {
            secrets = {
              "immich/key" = { };
              "immich/postgres_password" = { };
              "immich/valkey_password" = { };
            };
            templates = {
              immich-secrets = {
                content = builtins.toJSON {
                  apiVersion = "v1";
                  kind = "Secret";
                  metadata = {
                    name = "immich-secrets";
                    namespace = "immich";
                  };
                  type = "Opaque";
                  stringData = {
                    username = "immich";
                    password = config.sops.placeholder."immich/postgres_password";
                    valkey-password = config.sops.placeholder."immich/valkey_password";
                  };
                };
                path = "/var/lib/rancher/k3s/server/manifests/immich-secrets.json";
              };
            };
          };
        })
      ];
    };
}
