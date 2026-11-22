{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.homepage-secrets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config =
        lib.mkIf (config.homepage.enable && config.secrets.enable && config.secrets.homepage.enable)
          {
            sops.templates.homepageSecrets = {
              content = builtins.toJSON {
                apiVersion = "v1";
                kind = "Secret";
                type = "Opaque";
                metadata = {
                  name = "homepage-secrets";
                  namespace = "homepage";
                };
                stringData =
                  lib.optionalAttrs (config.media-server.jellyfin.enable && config.secrets.media-server.enable) {
                    JELLYFIN_KEY = config.sops.placeholder."jellyfin/key";
                  }
                  //
                    lib.optionalAttrs
                      (config.media-server.calibre-web-automated.enable && config.secrets.media-server.enable)
                      {
                        CALIBRE_USERNAME = config.sops.placeholder."calibre/username";
                        CALIBRE_PASSWORD = config.sops.placeholder."calibre/password";
                      }
                  //
                    lib.optionalAttrs (config.media-server.audiobookshelf.enable && config.secrets.media-server.enable)
                      {
                        AUDIOBOOKSHELF_KEY = config.sops.placeholder."audiobookshelf/key";
                      }
                  // lib.optionalAttrs (config.nextcloud.enable && config.secrets.nextcloud.enable) {
                    NEXTCLOUD_USERNAME = config.sops.placeholder."nextcloud/username";
                    NEXTCLOUD_PASSWORD = config.sops.placeholder."nextcloud/password";
                  }
                  // lib.optionalAttrs (config.immich.enable && config.secrets.immich.enable) {
                    IMMICH_KEY = config.sops.placeholder."immich/key";
                  }
                  // lib.optionalAttrs (config.forgejo.enable && config.secrets.forgejo.enable) {
                    FORGEJO_KEY = config.sops.placeholder."forgejo/key";
                  }
                  // lib.optionalAttrs (config.freshrss.enable && config.secrets.freshrss.enable) {
                    FRESHRSS_USERNAME = config.sops.placeholder."freshrss/username";
                    FRESHRSS_PASSWORD = config.sops.placeholder."freshrss/password";
                  }
                  // lib.optionalAttrs (config.media-server.seerr.enable && config.secrets.media-server.enable) {
                    SEERR_KEY = config.sops.placeholder."seerr/key";
                  }
                  // lib.optionalAttrs (config.media-server.prowlarr.enable && config.secrets.media-server.enable) {
                    PROWLARR_KEY = config.sops.placeholder."prowlarr/key";
                  }
                  // lib.optionalAttrs (config.media-server.radarr.enable && config.secrets.media-server.enable) {
                    RADARR_KEY = config.sops.placeholder."radarr/key";
                  }
                  // lib.optionalAttrs (config.media-server.sonarr.enable && config.secrets.media-server.enable) {
                    SONARR_KEY = config.sops.placeholder."sonarr/key";
                  }
                  // lib.optionalAttrs (config.media-server.lidarr.enable && config.secrets.media-server.enable) {
                    LIDARR_KEY = config.sops.placeholder."lidarr/key";
                  }
                  // lib.optionalAttrs (config.monitoring.grafana.enable && config.secrets.grafana.enable) {
                    GRAFANA_USERNAME = config.sops.placeholder."grafana/username";
                    GRAFANA_PASSWORD = config.sops.placeholder."grafana/password";
                  };
              };
              path = "/var/lib/rancher/k3s/server/manifests/homepage-secret.json";
            };
          };
    };
}
