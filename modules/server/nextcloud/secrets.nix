{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.nextcloud-secrets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config =
        lib.mkIf (config.nextcloud.enable && config.secrets.enable && config.secrets.nextcloud.enable)
          {
            sops = {
              secrets = {
                "nextcloud/username" = { };
                "nextcloud/password" = { };
                "nextcloud/postgres_password" = { };
                "nextcloud/valkey_password" = { };
              };
              templates.nextcloudSecrets = {
                content = builtins.toJSON {
                  apiVersion = "v1";
                  kind = "Secret";
                  type = "Opaque";
                  metadata = {
                    name = "nextcloud-secrets";
                    namespace = "nextcloud";
                  };
                  stringData = {
                    nextcloud-username = config.sops.placeholder."nextcloud/username";
                    nextcloud-password = config.sops.placeholder."nextcloud/password";
                    username = "nextcloud";
                    password = config.sops.placeholder."nextcloud/postgres_password";
                    valkey-password = config.sops.placeholder."nextcloud/valkey_password";
                  };
                };
                path = "/var/lib/rancher/k3s/server/manifests/nextcloud-secret.json";
              };
            };
          };
    };
}
