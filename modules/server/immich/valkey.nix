{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules.nixos.immich-valkey = self.factory.valkey {
    namespace = "immich";
    values = {
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
  };
}
