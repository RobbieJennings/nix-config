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
      resources = {
        requests.cpu = "20m";
        requests.memory = "64Mi";
        limits.cpu = "100m";
        limits.memory = "128Mi";
      };
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
