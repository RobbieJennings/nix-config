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

      config = lib.mkIf config.homepage.enable {
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
              data."settings.yaml" = ''
                title: Homelab
                theme: dark
                layout:
                  Media:
                    style: row
                    columns: 3
              '';
            }
            {
              apiVersion = "v1";
              kind = "ConfigMap";
              metadata = {
                name = "homepage-services";
                namespace = "homepage";
              };
              data."services.yaml" = ''
                - Infrastructure:
                    - Longhorn:
                        href: http://192.168.0.201
                    - Gitea:
                        href: http://192.168.0.204:3000
                    - Nextcloud:
                        href: http://192.168.0.203:8080

                - Media:
                    - Jellyfin:
                        href: http://192.168.0.202:8096
                    - Sonarr:
                        href: http://192.168.0.202:8989
                    - Radarr:
                        href: http://192.168.0.202:7878
                    - Lidarr:
                        href: http://192.168.0.202:8686
                    - Prowlarr:
                        href: http://192.168.0.202:9696
                    - Transmission:
                        href: http://192.168.0.202:9091
              '';
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
                            value = "*";
                          }
                        ];
                        volumeMounts = [
                          {
                            name = "settings";
                            mountPath = "/app/config/settings.yaml";
                            subPath = "settings.yaml";
                          }
                          {
                            name = "services";
                            mountPath = "/app/config/services.yaml";
                            subPath = "services.yaml";
                          }
                        ];
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
                        name = "services";
                        configMap.name = "homepage-services";
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
                name = "homepage-lb";
                namespace = "homepage";
                annotations = {
                  "metallb.io/address-pool" = "default";
                };
              };
              spec = {
                type = "LoadBalancer";
                loadBalancerIP = "192.168.0.200";
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
          ];
        };
      };
    };
}
