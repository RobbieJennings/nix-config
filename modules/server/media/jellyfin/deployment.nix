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
                  initContainers = [
                    {
                      name = "install-plugins";
                      image =
                        let
                          image = inputs.self.lib.findImageByName "linuxserver/jellyfin" config.services.k3s.images;
                        in
                        "${image.imageName}:${image.imageTag}";
                      command = [
                        "sh"
                        "-c"
                        ''
                          set -e

                          rm -rf /config/data/plugins/Moonfin
                          mkdir -p /config/data/plugins/Moonfin
                          cp -rf /moonbase/. /config/data/plugins/Moonfin/
                          chown -R 1000:1000 /config/data/plugins/Moonfin
                          chmod -R u+rwX /config/data/plugins/Moonfin

                          rm -rf /config/data/plugins/FileTransformation
                          mkdir -p /config/data/plugins/FileTransformation
                          cp -rf /file-transformation/. /config/data/plugins/FileTransformation/
                          chown -R 1000:1000 /config/data/plugins/FileTransformation
                          chmod -R u+rwX /config/data/plugins/FileTransformation

                          rm -rf /config/data/plugins/OpenSubtitles
                          mkdir -p /config/data/plugins/OpenSubtitles
                          cp -rf /open-subtitles/. /config/data/plugins/OpenSubtitles/
                          chown -R 1000:1000 /config/data/plugins/OpenSubtitles
                          chmod -R u+rwX /config/data/plugins/OpenSubtitles

                          rm -rf /config/data/plugins/IntroSkipper
                          mkdir -p /config/data/plugins/IntroSkipper
                          cp -rf /intro-skipper/. /config/data/plugins/IntroSkipper/
                          chown -R 1000:1000 /config/data/plugins/IntroSkipper
                          chmod -R u+rwX /config/data/plugins/IntroSkipper
                          echo "Plugins installed successfully."
                        ''
                      ];
                      volumeMounts = [
                        {
                          name = "config";
                          mountPath = "/config";
                        }
                        {
                          name = "moonbase";
                          mountPath = "/moonbase";
                          readOnly = true;
                        }
                        {
                          name = "file-transformation";
                          mountPath = "/file-transformation";
                          readOnly = true;
                        }
                        {
                          name = "open-subtitles";
                          mountPath = "/open-subtitles";
                          readOnly = true;
                        }
                        {
                          name = "intro-skipper";
                          mountPath = "/intro-skipper";
                          readOnly = true;
                        }
                      ];
                    }
                  ];
                  containers = [
                    {
                      name = "jellyfin";
                      image =
                        let
                          image = inputs.self.lib.findImageByName "linuxserver/jellyfin" config.services.k3s.images;
                        in
                        "${image.imageName}:${image.imageTag}";
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
                      resources = lib.recursiveUpdate config.server.resources.profiles.appMedium {
                        requests."gpu.intel.com/i915" = 1;
                        limits."gpu.intel.com/i915" = 1;
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
                        }
                      ];
                    }
                  ];
                  volumes = [
                    {
                      name = "config";
                      persistentVolumeClaim.claimName = "jellyfin-pvc";
                    }
                    {
                      name = "media";
                      persistentVolumeClaim.claimName = "media-pvc";
                    }
                    {
                      name = "moonbase";
                      hostPath = {
                        path = "${config._module.args.moonbasePlugin}";
                        type = "Directory";
                      };
                    }
                    {
                      name = "file-transformation";
                      hostPath = {
                        path = "${config._module.args.fileTransformationPlugin}";
                        type = "Directory";
                      };
                    }
                    {
                      name = "open-subtitles";
                      hostPath = {
                        path = "${config._module.args.openSubtitlesPlugin}";
                        type = "Directory";
                      };
                    }
                    {
                      name = "intro-skipper";
                      hostPath = {
                        path = "${config._module.args.introSkipperPlugin}";
                        type = "Directory";
                      };
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
