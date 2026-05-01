{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.radarr-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.radarr.enable) {
        services.k3s.manifests.radarr.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "radarr-config";
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
