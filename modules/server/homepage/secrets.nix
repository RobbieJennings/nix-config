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
      config = lib.mkIf (config.homepage.enable && config.secrets.enable) {
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
              NEXTCLOUD_USERNAME =
                if config.secrets.nextcloud.enable then config.sops.placeholder."nextcloud/username" else "";
              NEXTCLOUD_PASSWORD =
                if config.secrets.nextcloud.enable then config.sops.placeholder."nextcloud/password" else "";
              FORGEJO_KEY = if config.secrets.forgejo.enable then config.sops.placeholder."forgejo/key" else "";
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
      };
    };
}
