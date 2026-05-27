{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.longhorn-secrets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config =
        lib.mkIf (config.longhorn.enable && config.secrets.enable && config.secrets.longhorn.enable)
          {
            sops = {
              secrets = {
                "longhorn/backup_url" = { };
                "longhorn/backup_access_key" = { };
                "longhorn/backup_secret_key" = { };
              };
              templates = {
                longhorn-secrets = {
                  content = builtins.toJSON {
                    apiVersion = "v1";
                    kind = "Secret";
                    metadata = {
                      name = "longhorn-backup-secret";
                      namespace = "longhorn-system";
                    };
                    type = "Opaque";
                    stringData = {
                      AWS_ENDPOINTS = config.sops.placeholder."longhorn/backup_url";
                      AWS_ACCESS_KEY_ID = config.sops.placeholder."longhorn/backup_access_key";
                      AWS_SECRET_ACCESS_KEY = config.sops.placeholder."longhorn/backup_secret_key";
                    };
                  };
                  path = "/var/lib/rancher/k3s/server/manifests/longhorn-backup-secret.json";
                };
              };
            };
          };
    };
}
