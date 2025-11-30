{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  image = pkgs.dockerTools.pullImage {
    imageName = "linuxserver/lidarr";
    imageDigest = "sha256:f2a186ce04ec5adb133f92a08dd3efbc918fc71b33077426ef099d94350dfa1b";
    sha256 = "sha256-IhX2Fp7rQ77jrIqefGvjFgD3huwhU3UshVQl3bbPu4c=";
    finalImageTag = "3.1.0";
    arch = "amd64";
  };
in
{
  options = {
    server.media.lidarr.enable = lib.mkEnableOption "lidarr manifest on k3s";
  };

  config = lib.mkIf (config.server.media.enable && config.server.media.lidarr.enable) {
    services.k3s = {
      images = [ image ];
      manifests.lidarr.content = [
        {
          apiVersion = "v1";
          kind = "PersistentVolumeClaim";
          metadata = {
            name = "lidarr-config";
            namespace = "media";
          };
          spec = {
            accessModes = [ "ReadWriteOnce" ];
            storageClassName = "longhorn";
            resources.requests.storage = "5Gi";
          };
        }
        {
          apiVersion = "apps/v1";
          kind = "Deployment";
          metadata = {
            name = "lidarr";
            namespace = "media";
          };
          spec = {
            replicas = 1;
            selector.matchLabels.app = "lidarr";
            template = {
              metadata.labels.app = "lidarr";
              spec = {
                securityContext = {
                  runAsUser = 1000;
                  runAsGroup = 1000;
                  fsGroup = 1000;
                };
                containers = [
                  {
                    name = "lidarr";
                    image = "${image.imageName}:${image.imageTag}";
                    env = [
                      {
                        name = "PUID";
                        value = "1000";
                      }
                      {
                        name = "PGID";
                        value = "1000";
                      }
                    ];
                    ports = [ { containerPort = 8686; } ];
                    volumeMounts = [
                      {
                        name = "config";
                        mountPath = "/config";
                      }
                      {
                        name = "media";
                        mountPath = "/music";
                      }
                      {
                        name = "downloads";
                        mountPath = "/downloads";
                      }
                    ];
                  }
                ];
                volumes = [
                  {
                    name = "config";
                    persistentVolumeClaim.claimName = "lidarr-config";
                  }
                  {
                    name = "media";
                    persistentVolumeClaim.claimName = "media";
                  }
                  {
                    name = "downloads";
                    persistentVolumeClaim.claimName = "downloads";
                  }
                ];
              };
            };
          };
        }
        {
          apiVersion = "v1";
          kind = "Service";
          metadata = {
            name = "lidarr-lb";
            namespace = "media";
            annotations = {
              "metallb.io/address-pool" = "default";
              "metallb.universe.tf/allow-shared-ip" = "media";
            };
          };
          spec = {
            type = "LoadBalancer";
            loadBalancerIP = "192.168.0.202";
            selector = {
              "app" = "lidarr";
            };
            ports = [
              {
                name = "http";
                port = 8686;
                targetPort = 8686;
                protocol = "TCP";
              }
            ];
          };
        }
      ];
    };
  };
}
