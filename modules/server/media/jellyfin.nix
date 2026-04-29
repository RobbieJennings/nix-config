{
  inputs,
  ...
}:
{
  flake.modules.nixos.jellyfin =
    {
      config,
      lib,
      pkgs,
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
        media-server.jellyfin.enable = lib.mkEnableOption "jellyfin helm chart on k3s";
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.jellyfin.enable) {
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
                          {
                            name = "PUID";
                            value = "1000";
                          }
                          {
                            name = "PGID";
                            value = "1000";
                          }
                        ];
                        resources = {
                          requests = {
                            cpu = "100m";
                            memory = "256Mi";
                            "gpu.intel.com/i915" = 1;
                          };
                          limits = {
                            cpu = "1500m";
                            memory = "512Mi";
                            "gpu.intel.com/i915" = 1;
                          };
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
                    dnsConfig.options = [
                      {
                        name = "ndots";
                        value = "0";
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
                loadBalancerIP = "192.168.1.202";
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
                ];
              };
            }
            {
              apiVersion = "v1";
              kind = "Service";
              metadata = {
                name = "jellyfin";
                namespace = "media";
              };
              spec = {
                type = "ClusterIP";
                selector = {
                  "app" = "jellyfin";
                };
                ports = [
                  {
                    name = "http";
                    port = 80;
                    targetPort = 8096;
                    protocol = "TCP";
                  }
                ];
              };
            }
            {
              apiVersion = "netbird.io/v1alpha1";
              kind = "NetworkResource";
              metadata = {
                name = "jellyfin";
                namespace = "media";
              };
              spec = {
                networkRouterRef = {
                  name = "homelab";
                  namespace = "netbird";
                };
                serviceRef = {
                  name = "jellyfin";
                  namespace = "media";
                };
                groups = [ { name = "All"; } ];
              };
            }
          ];
        };
      };
    };
}
