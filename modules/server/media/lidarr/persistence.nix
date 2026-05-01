{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.lidarr-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.lidarr.enable) {
        services.k3s.manifests.lidarr.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "lidarr-config";
              namespace = "media";
            };
            spec = {
              accessModes = [ "ReadWriteOnce" ];
              storageClassName = "longhorn";
              resources.requests.storage = "5Gi";
            };
          }
        ];
      };
    };
}
