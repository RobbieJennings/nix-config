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
      resources = {
        requests.cpu = "20m";
        requests.memory = "64Mi";
        limits.cpu = "100m";
        limits.memory = "128Mi";
      };
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
