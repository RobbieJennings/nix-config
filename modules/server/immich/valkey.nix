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
      resources = {
        requests.cpu = "20m";
        requests.memory = "64Mi";
        limits.cpu = "100m";
        limits.memory = "128Mi";
      };
      auth = {
        enabled = true;
        usersExistingSecret = "immich-secrets";
        aclUsers.default = {
          permissions = "~* &* +@all";
          passwordKey = "valkey-password";
        };
      };
    };
  };
}
