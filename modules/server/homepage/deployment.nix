{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.homepage-deployment =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.homepage.enable {
        services.k3s.manifests.homepage.content = [
          {
            apiVersion = "apps/v1";
            kind = "Deployment";
            metadata = {
              name = "homepage";
              namespace = "homepage";
            };
            spec = {
              replicas = 1;
              selector.matchLabels.app = "homepage";
              template = {
                metadata.labels.app = "homepage";
                spec = {
                  containers = [
                    {
                      name = "homepage";
                      image = "${
                        (lib.lists.findSingle (
                          x: x ? imageName && x.imageName == "ghcr.io/gethomepage/homepage"
                        ) null null config.services.k3s.images).imageName
                      }:${
                        (lib.lists.findSingle (
                          x: x ? imageName && x.imageName == "ghcr.io/gethomepage/homepage"
                        ) null null config.services.k3s.images).imageTag
                      }";
                      ports = [
                        { containerPort = 3000; }
                      ];
                      env = [
                        {
                          name = "HOMEPAGE_ALLOWED_HOSTS";
                          value = "192.168.1.200,homepage.homepage,homepage.homepage.homelab";
                        }
                        {
                          name = "HOMEPAGE_VAR_GRAFANA_USERNAME";
                          valueFrom.secretKeyRef = {
                            name = "homepage-secrets";
                            key = "GRAFANA_USERNAME";
                          };
                        }
                        {
                          name = "HOMEPAGE_VAR_GRAFANA_PASSWORD";
                          valueFrom.secretKeyRef = {
                            name = "homepage-secrets";
                            key = "GRAFANA_PASSWORD";
                          };
                        }
                        {
                          name = "HOMEPAGE_VAR_NEXTCLOUD_USERNAME";
                          valueFrom.secretKeyRef = {
                            name = "homepage-secrets";
                            key = "NEXTCLOUD_USERNAME";
                          };
                        }
                        {
                          name = "HOMEPAGE_VAR_NEXTCLOUD_PASSWORD";
                          valueFrom.secretKeyRef = {
                            name = "homepage-secrets";
                            key = "NEXTCLOUD_PASSWORD";
                          };
                        }
                        {
                          name = "HOMEPAGE_VAR_FORGEJO_KEY";
                          valueFrom.secretKeyRef = {
                            name = "homepage-secrets";
                            key = "FORGEJO_KEY";
                          };
                        }
                        {
                          name = "HOMEPAGE_VAR_IMMICH_KEY";
                          valueFrom.secretKeyRef = {
                            name = "homepage-secrets";
                            key = "IMMICH_KEY";
                          };
                        }
                        {
                          name = "HOMEPAGE_VAR_JELLYFIN_KEY";
                          valueFrom.secretKeyRef = {
                            name = "homepage-secrets";
                            key = "JELLYFIN_KEY";
                          };
                        }
                        {
                          name = "HOMEPAGE_VAR_PROWLARR_KEY";
                          valueFrom.secretKeyRef = {
                            name = "homepage-secrets";
                            key = "PROWLARR_KEY";
                          };
                        }
                        {
                          name = "HOMEPAGE_VAR_RADARR_KEY";
                          valueFrom.secretKeyRef = {
                            name = "homepage-secrets";
                            key = "RADARR_KEY";
                          };
                        }
                        {
                          name = "HOMEPAGE_VAR_SONARR_KEY";
                          valueFrom.secretKeyRef = {
                            name = "homepage-secrets";
                            key = "SONARR_KEY";
                          };
                        }
                        {
                          name = "HOMEPAGE_VAR_LIDARR_KEY";
                          valueFrom.secretKeyRef = {
                            name = "homepage-secrets";
                            key = "LIDARR_KEY";
                          };
                        }
                      ];
                      volumeMounts = [
                        {
                          name = "settings";
                          mountPath = "/app/config/settings.yaml";
                          subPath = "settings.yaml";
                        }
                        {
                          name = "widgets";
                          mountPath = "/app/config/widgets.yaml";
                          subPath = "widgets.yaml";
                        }
                        {
                          name = "services";
                          mountPath = "/app/config/services.yaml";
                          subPath = "services.yaml";
                        }
                        {
                          name = "bookmarks";
                          mountPath = "/app/config/bookmarks.yaml";
                          subPath = "bookmarks.yaml";
                        }
                      ];
                      startupProbe = {
                        httpGet = {
                          path = "/";
                          port = 3000;
                        };
                        failureThreshold = 30;
                        periodSeconds = 5;
                      };
                      readinessProbe = {
                        httpGet = {
                          path = "/";
                          port = 3000;
                        };
                        initialDelaySeconds = 15;
                        periodSeconds = 10;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      livenessProbe = {
                        httpGet = {
                          path = "/";
                          port = 3000;
                        };
                        initialDelaySeconds = 30;
                        periodSeconds = 20;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      resources = {
                        requests.cpu = "100m";
                        requests.memory = "128Mi";
                        limits.cpu = "300m";
                        limits.memory = "256Mi";
                      };
                    }
                  ];
                  volumes = [
                    {
                      name = "settings";
                      configMap.name = "homepage-settings";
                    }
                    {
                      name = "widgets";
                      configMap.name = "homepage-widgets";
                    }
                    {
                      name = "services";
                      configMap.name = "homepage-services";
                    }
                    {
                      name = "bookmarks";
                      configMap.name = "homepage-bookmarks";
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
