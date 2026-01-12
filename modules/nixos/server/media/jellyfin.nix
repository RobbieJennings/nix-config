{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  image = pkgs.dockerTools.pullImage {
    imageName = "linuxserver/jellyfin";
    imageDigest = "sha256:367630b4e4e643c3c1d00bb76f13f3dbe318ad817c01256c358316c7acc3919b";
    sha256 = "sha256-5Vx7FccwINl85GSwXXc2CX/O+VgIaxsNVuMMDT18itI=";
    finalImageTag = "10.11.3";
    arch = "amd64";
  };
in
{
  options = {
    server.media.jellyfin.enable = lib.mkEnableOption "jellyfin helm chart on k3s";
  };

  config = lib.mkIf (config.server.media.enable && config.server.media.jellyfin.enable) {
    services.k3s = {
      images = [ image ];
      manifests.jellyfin.content = [
        {
          apiVersion = "v1";
          kind = "PersistentVolumeClaim";
          metadata = {
            name = "jellyfin-config";
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
            name = "jellyfin";
            namespace = "media";
          };
          spec = {
            replicas = 1;
            selector.matchLabels.app = "jellyfin";
            template = {
              metadata.labels.app = "jellyfin";
              spec = {
                containers = [
                  {
                    name = "jellyfin";
                    image = "${image.imageName}:${image.imageTag}";
                    ports = [
                      { containerPort = 8096; }
                      { containerPort = 1900; }
                      { containerPort = 7359; }
                    ];
                    env = [
                      {
                        name = "TZ";
                        value = "Europe/Dublin";
                      }
                    ];
                    resources = {
                      requests.cpu = "1000m";
                      requests.memory = "1Gi";
                      limits.cpu = "2000m";
                      limits.memory = "2Gi";
                    };
                    startupProbe = {
                      httpGet = {
                        path = "/System/Info/Public";
                        port = 8096;
                      };
                      failureThreshold = 30;
                      periodSeconds = 5;
                    };
                    readinessProbe = {
                      httpGet = {
                        path = "/System/Info/Public";
                        port = 8096;
                      };
                      initialDelaySeconds = 15;
                      periodSeconds = 10;
                      timeoutSeconds = 2;
                      failureThreshold = 3;
                    };
                    livenessProbe = {
                      httpGet = {
                        path = "/System/Info/Public";
                        port = 8096;
                      };
                      initialDelaySeconds = 30;
                      periodSeconds = 20;
                      timeoutSeconds = 2;
                      failureThreshold = 3;
                    };
                    volumeMounts = [
                      {
                        name = "config";
                        mountPath = "/config";
                      }
                      {
                        name = "media";
                        mountPath = "/media";
                        readOnly = true;
                      }
                    ];
                  }
                ];
                volumes = [
                  {
                    name = "config";
                    persistentVolumeClaim.claimName = "jellyfin-config";
                  }
                  {
                    name = "media";
                    persistentVolumeClaim.claimName = "media";
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
            name = "jellyfin-lb";
            namespace = "media";
            annotations = {
              "metallb.io/address-pool" = "default";
              "metallb.io/allow-shared-ip" = "media";
            };
          };
          spec = {
            type = "LoadBalancer";
            loadBalancerIP = "192.168.0.202";
            selector = {
              "app" = "jellyfin";
            };
            ports = [
              {
                name = "http";
                port = 8096;
                targetPort = 8096;
                protocol = "TCP";
              }
              {
                name = "service-discovery";
                port = 1900;
                targetPort = 1900;
                protocol = "UDP";
              }
              {
                name = "client-discovery";
                port = 7359;
                targetPort = 7359;
                protocol = "UDP";
              }
            ];
          };
        }
      ];
    };
  };
}
