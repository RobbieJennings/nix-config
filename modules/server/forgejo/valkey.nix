{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules.nixos.forgejo-valkey = self.factory.valkey {
    namespace = "forgejo";
    values = {
      auth = {
        enabled = true;
        usersExistingSecret = "forgejo-secrets";
        aclUsers.default = {
          permissions = "~* &* +@all";
          passwordKey = "valkey-password";
        };
      };
    };
  };
}
