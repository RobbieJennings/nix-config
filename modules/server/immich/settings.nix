{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.immich-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.immich.enable {
        services.k3s.autoDeployCharts.immich.values = {
          machine-learning.enabled = false;
          server.controllers.main.containers.main = {
            image = {
              repository =
                (lib.lists.findFirst (
                  x: x.imageName == "ghcr.io/immich-app/immich-server"
                ) null config.services.k3s.images).imageName;
              tag =
                (lib.lists.findFirst (
                  x: x.imageName == "ghcr.io/immich-app/immich-server"
                ) null config.services.k3s.images).imageTag;
            };
            env = {
              DB_HOSTNAME = "immich-postgres-rw";
              DB_DATABASE_NAME = "immich";
              DB_USERNAME = {
                valueFrom = {
                  secretKeyRef = {
                    name = "immich-secrets";
                    key = "username";
                  };
                };
              };
              DB_PASSWORD = {
                valueFrom = {
                  secretKeyRef = {
                    name = "immich-secrets";
                    key = "password";
                  };
                };
              };
              REDIS_HOSTNAME = "immich-valkey";
              REDIS_PORT = "6379";
              REDIS_PASSWORD = {
                valueFrom = {
                  secretKeyRef = {
                    name = "immich-secrets";
                    key = "valkey-password";
                  };
                };
              };
            };
            resources = {
              requests.cpu = "200m";
              requests.memory = "256Mi";
              limits.cpu = "1500m";
              limits.memory = "1Gi";
            };
          };
        };
      };
    };
}
