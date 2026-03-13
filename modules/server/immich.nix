{
  inputs,
  ...
}:
{
  flake.modules.nixos.immich =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      immichChart = {
        name = "immich";
        repo = "https://immich-app.github.io/immich-charts";
        version = "0.10.3";
        hash = "sha256-E9lqIjUe1WVEV8IDrMAbBTJMKj8AzpigJ7fNDCYYo8Y=";
      };
      postgresqlChart = {
        name = "postgresql";
        repo = "https://charts.bitnami.com/bitnami";
        version = "16.7.27";
        hash = "sha256-19D30DQtVlBPO7L3eGfgtxc/YyLxEma3Ti0O2lM2WQE=";
      };
      immichImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/immich-app/immich-server";
        imageDigest = "sha256:aa163d2e1cc2b16a9515dd1fef901e6f5231befad7024f093d7be1f2da14341a";
        sha256 = "sha256-VRqUD6mVub5qoIL6zt5iy4jk7rBm6Y4ddU/+o724q2g=";
        finalImageTag = "v2.5.6";
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
        immich.enable = lib.mkEnableOption "Immich helm chart on k3s";
        secrets.immich.enable = lib.mkEnableOption "Immich secrets";
      };

      config = lib.mkMerge [
        (lib.mkIf config.immich.enable {
          services.k3s = {
            images = [
              immichImage
              postgresqlImage
              valkeyImage
            ];
            autoDeployCharts = {
              immich-postgresql = postgresqlChart // {
                targetNamespace = "immich";
                createNamespace = true;
                values = {
                  image = {
                    repository = postgresqlImage.imageName;
                    tag = postgresqlImage.imageTag;
                  };
                  auth = {
                    postgresPassword = "password";
                    database = "immich";
                  };
                  primary = {
                    persistence = {
                      enabled = true;
                      size = "8Gi";
                    };
                    resources = {
                      requests.cpu = "200m";
                      requests.memory = "256Mi";
                      limits.cpu = "1000m";
                      limits.memory = "1Gi";
                    };
                  };
                };
              };
              immich = immichChart // {
                targetNamespace = "immich";
                createNamespace = true;
                values = {
                  server = {
                    controllers.main.containers.main = {
                      image = {
                        repository = immichImage.imageName;
                        tag = immichImage.imageTag;
                      };
                      env = {
                        DB_HOSTNAME = "immich-postgresql";
                        DB_USERNAME = "postgres";
                        DB_PASSWORD = "password";
                        DB_DATABASE_NAME = "immich";
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
                  valkey = {
                    enabled = true;
                    controllers.main.containers.main = {
                      image = {
                        repository = valkeyImage.imageName;
                        tag = valkeyImage.imageTag;
                      };
                      env = {
                        ALLOW_EMPTY_PASSWORD = "yes";
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
                    persistence.data = {
                      enabled = true;
                      size = "8Gi";
                      type = "persistentVolumeClaim";
                    };
                  };
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
                    apiVersion = "v1";
                    kind = "Service";
                    metadata = {
                      name = "immich-tailscale";
                      namespace = "immich";
                      annotations = {
                        "tailscale.com/expose" = "true";
                        "tailscale.com/hostname" = "immich";
                      };
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
                ];
              };
            };
          };
        })
        (lib.mkIf (config.immich.enable && config.secrets.enable && config.secrets.immich.enable) {
          sops.secrets = {
            "immich/key" = { };
          };
        })
      ];
    };
}
