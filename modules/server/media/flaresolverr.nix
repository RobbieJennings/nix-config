{
  inputs,
  ...
}:
{
  flake.modules.nixos.flaresolverr =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      image = pkgs.dockerTools.pullImage {
        imageName = "flaresolverr/flaresolverr";
        imageDigest = "sha256:7962759d99d7e125e108e0f5e7f3cdbcd36161776d058d1d9b7153b92ef1af9e";
        sha256 = "sha256-ANmJg+ZQYLXIZrbOSufKR8khSiuJ9S+83DCFCBf2Yf4=";
        finalImageTag = "3.4.6";
        arch = "amd64";
      };
    in
    {
      options = {
        media-server.flaresolverr.enable = lib.mkEnableOption "FlareSolverr for Prowlarr";
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.flaresolverr.enable) {
        services.k3s = {
          images = [ image ];
          manifests.flaresolverr.content = [
            {
              apiVersion = "apps/v1";
              kind = "Deployment";
              metadata = {
                name = "flaresolverr";
                namespace = "media";
              };
              spec = {
                replicas = 1;
                selector.matchLabels.app = "flaresolverr";
                template = {
                  metadata.labels.app = "flaresolverr";
                  spec = {
                    securityContext = {
                      runAsUser = 1000;
                      runAsGroup = 1000;
                      fsGroup = 1000;
                    };
                    containers = [
                      {
                        name = "flaresolverr";
                        image = "${image.imageName}:${image.imageTag}";
                        env = [
                          {
                            name = "LOG_LEVEL";
                            value = "info";
                          }
                          {
                            name = "TZ";
                            value = "UTC";
                          }
                        ];
                        ports = [ { containerPort = 8191; } ];
                        startupProbe = {
                          httpGet = {
                            path = "/";
                            port = 8191;
                          };
                          failureThreshold = 30;
                          periodSeconds = 5;
                        };
                        readinessProbe = {
                          httpGet = {
                            path = "/";
                            port = 8191;
                          };
                          initialDelaySeconds = 15;
                          periodSeconds = 10;
                          timeoutSeconds = 2;
                          failureThreshold = 3;
                        };
                        livenessProbe = {
                          httpGet = {
                            path = "/";
                            port = 8191;
                          };
                          initialDelaySeconds = 30;
                          periodSeconds = 20;
                          timeoutSeconds = 2;
                          failureThreshold = 3;
                        };
                        resources = {
                          requests.cpu = "500m";
                          requests.memory = "512Mi";
                          limits.cpu = "1000m";
                          limits.memory = "1Gi";
                        };
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
                name = "flaresolverr-lb";
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
                  "app" = "flaresolverr";
                };
                ports = [
                  {
                    name = "http";
                    port = 8191;
                    targetPort = 8191;
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
