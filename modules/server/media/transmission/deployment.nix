{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.transmission-deployment =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.transmission.enable) {
        services.k3s.manifests.transmission.content = [
          {
            apiVersion = "apps/v1";
            kind = "Deployment";
            metadata = {
              name = "transmission";
              namespace = "media";
            };
            spec = {
              replicas = 1;
              selector.matchLabels.app = "transmission";
              template = {
                metadata.labels.app = "transmission";
                spec = {
                  containers = [
                    {
                      name = "transmission";
                      image = "${
                        (lib.lists.findSingle (
                          x: x ? imageName && x.imageName == "linuxserver/transmission"
                        ) null null config.services.k3s.images).imageName
                      }:${
                        (lib.lists.findSingle (
                          x: x ? imageName && x.imageName == "linuxserver/transmission"
                        ) null null config.services.k3s.images).imageTag
                      }";
                      ports = [
                        { containerPort = 9091; }
                        {
                          containerPort = 51413;
                          protocol = "TCP";
                        }
                        {
                          containerPort = 51413;
                          protocol = "UDP";
                        }
                      ];
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
                      resources = {
                        requests.cpu = "50m";
                        requests.memory = "128Mi";
                        limits.cpu = "300m";
                        limits.memory = "256Mi";
                      };
                      startupProbe = {
                        httpGet = {
                          path = "/transmission/web/";
                          port = 9091;
                        };
                        failureThreshold = 30;
                        periodSeconds = 5;
                      };
                      readinessProbe = {
                        httpGet = {
                          path = "/transmission/web/";
                          port = 9091;
                        };
                        initialDelaySeconds = 15;
                        periodSeconds = 10;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      livenessProbe = {
                        httpGet = {
                          path = "/transmission/web/";
                          port = 9091;
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
                          name = "watch";
                          mountPath = "/watch";
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
                      persistentVolumeClaim.claimName = "transmission-config";
                    }
                    {
                      name = "watch";
                      persistentVolumeClaim.claimName = "transmission-watch";
                    }
                    {
                      name = "downloads";
                      persistentVolumeClaim.claimName = "downloads";
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
