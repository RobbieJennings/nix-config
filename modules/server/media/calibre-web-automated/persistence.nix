{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.calibre-web-automated-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.calibre-web-automated = {
        calibreWebAutomatedVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "5Gi";
          description = "Volume size for Calibre-Web-Automated";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.calibre-web-automated.enable) {
        services.k3s.manifests.calibre-web-automated.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "calibre-web-automated-pv";
            };
            spec = {
              capacity.storage = config.media-server.calibre-web-automated.calibreWebAutomatedVolumeSize;
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "calibre-web-automated";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "media";
                name = "calibre-web-automated-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "calibre-web-automated-pvc";
              namespace = "media";
            };
            spec = {
              resources.requests.storage =
                config.media-server.calibre-web-automated.calibreWebAutomatedVolumeSize;
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "calibre-web-automated-pv";
            };
          }
        ];
      };
    };
}
