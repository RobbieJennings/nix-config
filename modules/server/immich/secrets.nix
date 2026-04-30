{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.immich-secrets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config =
        lib.mkIf (config.immich.enable && config.secrets.enable && config.secrets.immich.enable)
          {
            sops = {
              secrets = {
                "immich/key" = { };
                "immich/postgres_password" = { };
                "immich/valkey_password" = { };
              };
              templates = {
                immich-secrets = {
                  content = builtins.toJSON {
                    apiVersion = "v1";
                    kind = "Secret";
                    metadata = {
                      name = "immich-secrets";
                      namespace = "immich";
                    };
                    type = "Opaque";
                    stringData = {
                      username = "immich";
                      password = config.sops.placeholder."immich/postgres_password";
                      valkey-password = config.sops.placeholder."immich/valkey_password";
                    };
                  };
                  path = "/var/lib/rancher/k3s/server/manifests/immich-secrets.json";
                };
              };
            };
          };
    };
}
