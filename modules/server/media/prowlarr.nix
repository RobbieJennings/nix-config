{
  inputs,
  ...
}:
{
  flake.modules.nixos.prowlarr =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      image = pkgs.dockerTools.pullImage {
        imageName = "linuxserver/prowlarr";
        imageDigest = "sha256:3dd3a316f60ea4e6714863286549a6ccaf0b8cf4efe5578ce3fe0e85475cb1cf";
        sha256 = "sha256-eZpWwk0PGRwchS7jUldbdRCnRIbnRSR37c1ANewXLGk=";
        finalImageTag = "2.3.0";
        arch = "amd64";
      };
    in
    {
      options = {
        media-server.prowlarr.enable = lib.mkEnableOption "prowlarr manifest on k3s";
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.prowlarr.enable) {
        services.k3s = {
          images = [ image ];
          manifests.prowlarr.content = [
            {
              apiVersion = "v1";
              kind = "PersistentVolumeClaim";
              metadata = {
                name = "prowlarr-config";
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
                name = "prowlarr";
                namespace = "media";
              };
              spec = {
                replicas = 1;
                selector.matchLabels.app = "prowlarr";
                template = {
                  metadata.labels.app = "prowlarr";
                  spec = {
                    securityContext = {
                      runAsUser = 1000;
                      runAsGroup = 1000;
                      fsGroup = 1000;
                    };
                    containers = [
                      {
                        name = "prowlarr";
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
                          {
                            name = "DOTNET_SYSTEM_NET_DISABLEIPV6";
                            value = "1";
                          }
                          {
                            name = "DOTNET_SYSTEM_NET_FORCE_IPV4";
                            value = "1";
                          }
                        ];
                        ports = [ { containerPort = 9696; } ];
                        resources = {
                          requests.cpu = "500m";
                          requests.memory = "512Mi";
                          limits.cpu = "1000m";
                          limits.memory = "1Gi";
                        };
                        startupProbe = {
                          httpGet = {
                            path = "/";
                            port = 9696;
                          };
                          failureThreshold = 30;
                          periodSeconds = 5;
                        };
                        readinessProbe = {
                          httpGet = {
                            path = "/";
                            port = 9696;
                          };
                          initialDelaySeconds = 15;
                          periodSeconds = 10;
                          timeoutSeconds = 2;
                          failureThreshold = 3;
                        };
                        livenessProbe = {
                          httpGet = {
                            path = "/";
                            port = 9696;
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
                        ];
                      }
                    ];
                    volumes = [
                      {
                        name = "config";
                        persistentVolumeClaim.claimName = "prowlarr-config";
                      }
                    ];
                    dnsConfig.options = [
                      {
                        name = "ndots";
                        value = "1";
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
                name = "prowlarr-lb";
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
                  "app" = "prowlarr";
                };
                ports = [
                  {
                    name = "http";
                    port = 9696;
                    targetPort = 9696;
                    protocol = "TCP";
                  }
                ];
              };
            }
          ];
        };
      };
    };
}
