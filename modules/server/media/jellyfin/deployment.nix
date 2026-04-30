{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.jellyfin-deployment =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.jellyfin.enable) {
        services.k3s.manifests.jellyfin.content = [
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
                      image = "${
                        (lib.lists.findSingle (
                          x: x ? imageName && x.imageName == "linuxserver/jellyfin"
                        ) null null config.services.k3s.images).imageName
                      }:${
                        (lib.lists.findSingle (
                          x: x ? imageName && x.imageName == "linuxserver/jellyfin"
                        ) null null config.services.k3s.images).imageTag
                      }";
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
        ];
      };
    };
}
