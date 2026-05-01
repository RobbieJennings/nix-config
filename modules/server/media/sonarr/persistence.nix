{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.sonarr-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.sonarr.enable) {
        services.k3s.manifests.sonarr.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "sonarr-config";
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
