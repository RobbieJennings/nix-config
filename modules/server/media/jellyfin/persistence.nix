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
      config = lib.mkIf (config.media-server.enable && config.media-server.jellyfin.enable) {
        services.k3s.manifests.jellyfin.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "jellyfin-config";
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
