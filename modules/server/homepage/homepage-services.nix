{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.homepage-homepage-services =
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
            apiVersion = "v1";
            kind = "ConfigMap";
            metadata = {
              name = "homepage-services";
              namespace = "homepage";
            };
            data."services.yaml" = builtins.toJSON [
              {
                Infrastructure = [
                  {
                    Grafana = {
                      href = "http://grafana.monitoring/";
                      description = "Dashboards";
                      widgets = [
                        {
                          type = "grafana";
                          url = "http://192.168.1.210";
                          alerts = "alertmanager";
                          username = "{{HOMEPAGE_VAR_GRAFANA_USERNAME}}";
                          password = "{{HOMEPAGE_VAR_GRAFANA_PASSWORD}}";
                        }
                      ];
                    };
                  }
                  {
                    Prometheus = {
                      href = "http://prometheus.monitoring/";
                      description = "Metrics Server";
                      widgets = [
                        {
                          type = "prometheus";
                          url = "http://192.168.1.210:9090";
                        }
                      ];
                    };
                  }
                  {
                    Alloy = {
                      href = "http://alloy.monitoring/";
                      description = "Logging Agent";
                    };
                  }
                  {
                    Longhorn = {
                      href = "http://longhorn.longhorn-system/";
                      description = "Volume Management";
                    };
                  }
                ];
              }
              {
                Files = [
                  {
                    Forgejo = {
                      href = "http://forgejo.forgejo/";
                      description = "Git Server";
                      widgets = [
                        {
                          type = "gitea";
                          url = "http://192.168.1.204:3000";
                          key = "{{HOMEPAGE_VAR_FORGEJO_KEY}}";
                        }
                      ];
                    };
                  }
                  {
                    Nextcloud = {
                      href = "http://nextcloud.nextcloud/";
                      description = "Cloud Storage";
                      widgets = [
                        {
                          type = "nextcloud";
                          url = "http://192.168.1.203:8080";
                          username = "{{HOMEPAGE_VAR_NEXTCLOUD_USERNAME}}";
                          password = "{{HOMEPAGE_VAR_NEXTCLOUD_PASSWORD}}";
                        }
                      ];
                    };
                  }
                  {
                    Immich = {
                      href = "http://immich.immich/";
                      description = "Photo & Video Storage";
                      widgets = [
                        {
                          type = "immich";
                          url = "http://192.168.1.205:2283";
                          key = "{{HOMEPAGE_VAR_IMMICH_KEY}}";
                          version = 2;
                        }
                      ];
                    };
                  }
                ];
              }
              {
                Media = [
                  {
                    Jellyfin = {
                      href = "http://jellyfin.media.homelab/";
                      description = "Media Playback";
                      widgets = [
                        {
                          type = "jellyfin";
                          url = "http://192.168.1.202:8096";
                          key = "{{HOMEPAGE_VAR_JELLYFIN_KEY}}";
                          version = 1;
                          enableBlocks = true;
                          enableNowPlaying = true;
                          enableUser = true;
                          enableMediaControl = true;
                          showEpisodeNumber = true;
                          expandOneStreamToTwoRows = true;
                        }
                      ];
                    };
                  }
                  {
                    Transmission = {
                      href = "http://transmission.media.homelab/";
                      description = "Torrent Management";
                      widgets = [
                        {
                          type = "transmission";
                          url = "http://192.168.1.202:9091";
                        }
                      ];
                    };
                  }
                  {
                    Prowlarr = {
                      href = "http://prowlarr.media.homelab/";
                      description = "Indexer Management";
                      widgets = [
                        {
                          type = "prowlarr";
                          url = "http://192.168.1.202:9696";
                          key = "{{HOMEPAGE_VAR_PROWLARR_KEY}}";
                        }
                      ];
                    };
                  }
                  {
                    Radarr = {
                      href = "http://radarr.media.homelab/";
                      description = "Movie Management";
                      widgets = [
                        {
                          type = "radarr";
                          url = "http://192.168.1.202:7878";
                          key = "{{HOMEPAGE_VAR_RADARR_KEY}}";
                        }
                      ];
                    };
                  }
                  {
                    Sonarr = {
                      href = "http://sonarr.media.homelab/";
                      description = "TV Show Management";
                      widgets = [
                        {
                          type = "sonarr";
                          url = "http://192.168.1.202:8989";
                          key = "{{HOMEPAGE_VAR_SONARR_KEY}}";
                        }
                      ];
                    };
                  }
                  {
                    Lidarr = {
                      href = "http://lidarr.media.homelab/";
                      description = "Music Management";
                      widgets = [
                        {
                          type = "lidarr";
                          url = "http://192.168.1.202:8686";
                          key = "{{HOMEPAGE_VAR_LIDARR_KEY}}";
                        }
                      ];
                    };
                  }
                ];
              }
            ];
          }
        ];
      };
    };
}
