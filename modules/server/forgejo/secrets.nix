{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.forgejo-secrets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config =
        lib.mkIf (config.forgejo.enable && config.secrets.enable && config.secrets.forgejo.enable)
          {
            sops = {
              secrets = {
                "forgejo/username" = { };
                "forgejo/password" = { };
                "forgejo/email" = { };
                "forgejo/key" = { };
                "forgejo/postgres_password" = { };
                "forgejo/valkey_password" = { };
              };
              templates = {
                forgejoSecrets = {
                  content = builtins.toJSON {
                    apiVersion = "v1";
                    kind = "Secret";
                    type = "Opaque";
                    metadata = {
                      name = "forgejo-secrets";
                      namespace = "forgejo";
                    };
                    stringData = {
                      username = "forgejo";
                      password = config.sops.placeholder."forgejo/postgres_password";
                      valkey-password = config.sops.placeholder."forgejo/valkey_password";
                      valkey-url = "redis://default:${
                        config.sops.placeholder."forgejo/valkey_password"
                      }@forgejo-valkey:6379/0";
                    };
                  };
                  path = "/var/lib/rancher/k3s/server/manifests/forgejo-secret.json";
                };
                forgejoAdminSecrets = {
                  content = builtins.toJSON {
                    apiVersion = "v1";
                    kind = "Secret";
                    type = "Opaque";
                    metadata = {
                      name = "forgejo-admin-secrets";
                      namespace = "forgejo";
                    };
                    stringData = {
                      username = config.sops.placeholder."forgejo/username";
                      password = config.sops.placeholder."forgejo/password";
                      email = config.sops.placeholder."forgejo/email";
                    };
                  };
                  path = "/var/lib/rancher/k3s/server/manifests/forgejo-admin-secret.json";
                };
              };
            };
          };
    };
}
