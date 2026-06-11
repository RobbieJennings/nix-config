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
          service.main.enabled = false;
          server.controllers.main.containers.main = {
            image =
              let
                image = inputs.self.lib.findImageByName "ghcr.io/immich-app/immich-server" config.services.k3s.images;
              in
              {
                repository = image.imageName;
                tag = image.imageTag;
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
            resources = config.server.resources.profiles.appLarge;
          };
          immich.persistence.library.existingClaim = "immich-pvc";
        };
      };
    };
}
