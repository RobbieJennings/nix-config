{
  inputs,
  ...
}:
{
  flake.modules.nixos.homepage =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      image = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/gethomepage/homepage";
        imageDigest = "sha256:0b596092c0b55fe4c65379a428a3fe90bd192f10d1b07d189a34fe5fabe7eedb";
        sha256 = "sha256-f2vJ6WPGf9Gk4XDjH5tMdvWvHhT2D2HZKWanUJQloRE=";
        finalImageTag = "v1.10.1";
        arch = "amd64";
      };
    in
    {
      options = {
        homepage.enable = lib.mkEnableOption "Homepage dashboard on k3s";
      };

      config = lib.mkMerge [
        (lib.mkIf config.homepage.enable {
          services.k3s = {
            images = [ image ];
            manifests.homepage.content = [
              {
                apiVersion = "v1";
                kind = "Namespace";
                metadata = {
                  name = "homepage";
                };
              }
              {
                apiVersion = "v1";
                kind = "ConfigMap";
                metadata = {
                  name = "homepage-settings";
                  namespace = "homepage";
                };
                data."settings.yaml" = builtins.toJSON {
                  title = "Homelab";
                  theme = "dark";
                  providers = {
                    longhorn.url = "http://192.168.1.201";
                  };
                };
              }
              {
                apiVersion = "v1";
                kind = "ConfigMap";
                metadata = {
                  name = "homepage-widgets";
                  namespace = "homepage";
                };
                data."widgets.yaml" = builtins.toJSON [
                  {
                    resources = {
                      label = "System";
                      uptime = true;
                      cputemp = true;
                      cpu = true;
                      memory = true;
                      tempmin = 0;
                      tempmax = 100;
                    };
                  }
                  {
                    longhorn = {
                      url = "http://192.168.1.201";
                      expanded = true;
                      total = true;
                      labels = true;
                      nodes = true;
                    };
                  }
                  {
                    search = {
                      provider = "google";
                      focus = true;
                      showSearchSuggestions = true;
                      target = "_blank";
                    };
                  }
                ];
              }
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
                        Tailscale = {
                          href = "https://login.tailscale.com/admin/machines";
                          description = "WireGuard Connections";
                          widgets = [
                            {
                              type = "tailscale";
                              deviceid = "{{HOMEPAGE_VAR_TAILSCALE_DEVICE_ID}}";
                              key = "{{HOMEPAGE_VAR_TAILSCALE_KEY}}";
                            }
                          ];
                        };
                      }
                      {
                        Grafana = {
                          href = "http://monitoring-grafana-tailscale:3000";
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
                          href = "http://monitoring-prometheus-tailscale:9090";
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
                          href = "http://monitoring-prometheus-tailscale:9090";
                          description = "Logging Agent";
                        };
                      }
                      {
                        Longhorn = {
                          href = "http://longhorn-system-longhorn-tailscale:8000";
                          description = "Volume Management";
                        };
                      }
                    ];
                  }
                  {
                    Files = [
                      {
                        Gitea = {
                          href = "http://gitea-gitea-tailscale:3000";
                          description = "Git Server";
                          widgets = [
                            {
                              type = "gitea";
                              url = "http://192.168.1.204:3000";
                              key = "{{HOMEPAGE_VAR_GITEA_KEY}}";
                            }
                          ];
                        };
                      }
                      {
                        Nextcloud = {
                          href = "http://nextcloud-nextcloud-tailscale";
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
                          href = "http://immich-immich-tailscale:2283";
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
                          href = "http://media-jellyfin-tailscale:8096";
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
                          href = "http://media-transmission-tailscale:9091";
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
                          href = "http://media-prowlarr-tailscale:9696";
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
                          href = "http://media-radarr-tailscale:7878";
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
                          href = "http://media-sonarr-tailscale:8989";
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
                          href = "http://media-lidarr-tailscale:8686";
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
              {
                apiVersion = "v1";
                kind = "ConfigMap";
                metadata = {
                  name = "homepage-bookmarks";
                  namespace = "homepage";
                };
                data."bookmarks.yaml" = builtins.toJSON [
                  {
                    Developer = [
                      {
                        Github = [
                          {
                            abbr = "GH";
                            href = "https://github.com/";
                            description = "Code hosting";
                          }
                        ];
                      }
                    ];
                  }
                  {
                    Entertainment = [
                      {
                        YouTube = [
                          {
                            abbr = "YT";
                            href = "https://youtube.com/";
                            description = "Video sharing";
                          }
                        ];
                      }
                    ];
                  }
                  {
                    Social = [
                      {
                        Reddit = [
                          {
                            abbr = "RE";
                            href = "https://reddit.com/";
                            description = "The front page of the internet";
                          }
                        ];
                      }
                    ];
                  }
                ];
              }
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
                          image = "${image.imageName}:${image.imageTag}";
                          ports = [
                            { containerPort = 3000; }
                          ];
                          env = [
                            {
                              name = "HOMEPAGE_ALLOWED_HOSTS";
                              value = "192.168.1.200,localhost,homepage-homepage-tailscale:3000";
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
                              name = "HOMEPAGE_VAR_TAILSCALE_DEVICE_ID";
                              valueFrom.secretKeyRef = {
                                name = "homepage-secrets";
                                key = "TAILSCALE_DEVICE_ID";
                              };
                            }
                            {
                              name = "HOMEPAGE_VAR_TAILSCALE_KEY";
                              valueFrom.secretKeyRef = {
                                name = "homepage-secrets";
                                key = "TAILSCALE_KEY";
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
                              name = "HOMEPAGE_VAR_GITEA_KEY";
                              valueFrom.secretKeyRef = {
                                name = "homepage-secrets";
                                key = "GITEA_KEY";
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
                      dnsConfig = {
                        nameservers = [
                          "1.1.1.1"
                          "8.8.8.8"
                        ];
                        options = [
                          {
                            name = "ndots";
                            value = "0";
                          }
                        ];
                      };
                    };
                  };
                };
              }
              {
                apiVersion = "v1";
                kind = "Service";
                metadata = {
                  name = "homepage-lb";
                  namespace = "homepage";
                  annotations = {
                    "metallb.io/address-pool" = "default";
                  };
                };
                spec = {
                  type = "LoadBalancer";
                  loadBalancerIP = "192.168.1.200";
                  selector = {
                    "app" = "homepage";
                  };
                  ports = [
                    {
                      name = "http";
                      port = 80;
                      targetPort = 3000;
                    }
                  ];
                };
              }
              {
                apiVersion = "v1";
                kind = "Service";
                metadata = {
                  name = "homepage-tailscale";
                  namespace = "homepage";
                  annotations = {
                    "tailscale.com/expose" = "true";
                  };
                };
                spec = {
                  type = "ClusterIP";
                  selector = {
                    "app" = "homepage";
                  };
                  ports = [
                    {
                      name = "http";
                      port = 3000;
                      targetPort = 3000;
                      protocol = "TCP";
                    }
                  ];
                };
              }
            ];
          };
        })
        (lib.mkIf (config.homepage.enable && config.secrets.enable) {
          sops.templates.homepageSecrets = {
            content = builtins.toJSON {
              apiVersion = "v1";
              kind = "Secret";
              type = "Opaque";
              metadata = {
                name = "homepage-secrets";
                namespace = "homepage";
              };
              stringData = {
                GRAFANA_USERNAME =
                  if config.secrets.grafana.enable then config.sops.placeholder."grafana/username" else "";
                GRAFANA_PASSWORD =
                  if config.secrets.grafana.enable then config.sops.placeholder."grafana/password" else "";
                TAILSCALE_DEVICE_ID =
                  if config.secrets.tailscale-operator.enable then
                    config.sops.placeholder."tailscale/device_id"
                  else
                    "";
                TAILSCALE_KEY =
                  if config.secrets.tailscale-operator.enable then config.sops.placeholder."tailscale/key" else "";
                NEXTCLOUD_USERNAME =
                  if config.secrets.nextcloud.enable then config.sops.placeholder."nextcloud/username" else "";
                NEXTCLOUD_PASSWORD =
                  if config.secrets.nextcloud.enable then config.sops.placeholder."nextcloud/password" else "";
                GITEA_KEY = if config.secrets.gitea.enable then config.sops.placeholder."gitea/key" else "";
                IMMICH_KEY = if config.secrets.immich.enable then config.sops.placeholder."immich/key" else "";
                JELLYFIN_KEY =
                  if config.secrets.media-server.enable then config.sops.placeholder."jellyfin/key" else "";
                RADARR_KEY =
                  if config.secrets.media-server.enable then config.sops.placeholder."radarr/key" else "";
                SONARR_KEY =
                  if config.secrets.media-server.enable then config.sops.placeholder."sonarr/key" else "";
                LIDARR_KEY =
                  if config.secrets.media-server.enable then config.sops.placeholder."lidarr/key" else "";
                PROWLARR_KEY =
                  if config.secrets.media-server.enable then config.sops.placeholder."prowlarr/key" else "";
              };
            };
            path = "/var/lib/rancher/k3s/server/manifests/homepage-secret.json";
          };
        })
      ];
    };
}
