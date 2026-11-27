{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules.nixos.immich-valkey =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.immich = {
        valkeyResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.cache;
          description = "Resource profile for Immich's cache";
        };
      };

      imports = [
        (self.factory.valkey {
          moduleName = "immich";
          namespace = "immich";
          values = {
            resources = config.immich.valkeyResources;
            auth = {
              enabled = true;
              usersExistingSecret = "immich-secrets";
              aclUsers = {
                default = {
                  permissions = "~* &* +@all";
                  passwordKey = "valkey-password";
                };
                immich = {
                  permissions = "~* &* +@all";
                  passwordKey = "valkey-password";
                };
              };
            };
          };
        })
      ];
    };
}
