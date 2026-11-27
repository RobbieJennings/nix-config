{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.jellyfin-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.jellyfin = {
        jellyfinVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "5Gi";
          description = "Volume size for Jellyfin";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.jellyfin.enable) {
        services.k3s.manifests.jellyfin.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "jellyfin-pv";
            };
            spec = {
              capacity.storage = config.media-server.jellyfin.jellyfinVolumeSize;
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "jellyfin";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "media";
                name = "jellyfin-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "jellyfin-pvc";
              namespace = "media";
            };
            spec = {
              resources.requests.storage = config.media-server.jellyfin.jellyfinVolumeSize;
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "jellyfin-pv";
            };
          }
        ];
      };
    };
}
