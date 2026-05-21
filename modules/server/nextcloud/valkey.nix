{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules.nixos.nextcloud-valkey = self.factory.valkey {
    namespace = "nextcloud";
    values = {
      auth = {
        enabled = true;
        usersExistingSecret = "nextcloud-secrets";
        aclUsers.default = {
          permissions = "~* &* +@all";
          passwordKey = "valkey-password";
        };
      };
    };
  };
}
