{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./jellyfin.nix
    ./transmission.nix
    ./flaresolverr.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./lidarr.nix
  ];

  options = {
    server.media.enable = lib.mkEnableOption "jellyfin, transmission and servarr services on k3s";
  };

  config = lib.mkIf config.server.media.enable {
    services.k3s = {
      manifests.media.content = [
        {
          apiVersion = "v1";
          kind = "Namespace";
          metadata = {
            name = "media";
          };
        }
        {
          apiVersion = "v1";
          kind = "PersistentVolumeClaim";
          metadata = {
            name = "media";
            namespace = "media";
          };
          spec = {
            accessModes = [ "ReadWriteMany" ];
            storageClassName = "longhorn";
            resources.requests.storage = "25Gi";
          };
        }
        {
          apiVersion = "v1";
          kind = "PersistentVolumeClaim";
          metadata = {
            name = "downloads";
            namespace = "media";
          };
          spec = {
            accessModes = [ "ReadWriteMany" ];
            storageClassName = "longhorn";
            resources.requests.storage = "25Gi";
          };
        }
      ];
    };
    server.media = {
      jellyfin.enable = lib.mkDefault true;
      transmission.enable = lib.mkDefault true;
      flaresolverr.enable = lib.mkDefault true;
      prowlarr.enable = lib.mkDefault true;
      radarr.enable = lib.mkDefault true;
      sonarr.enable = lib.mkDefault true;
      lidarr.enable = lib.mkDefault true;
    };
  };
}
