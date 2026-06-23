{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.nextcloud-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.nextcloud.enable {
        services.k3s.autoDeployCharts.nextcloud.values = {
          image =
            let
              image = inputs.self.lib.findImageByName "nextcloud" config.services.k3s.images;
            in
            {
              repository = image.imageName;
              tag = image.imageTag;
            };
          nextcloud = {
            host = "nextcloud.nextcloud";
            trustedDomains = [
              "192.168.1.203"
              "nextcloud.nextcloud"
              "nextcloud.nextcloud.homelab"
            ];
            existingSecret = {
              enabled = true;
              secretName = "nextcloud-secrets";
              usernameKey = "nextcloud-username";
              passwordKey = "nextcloud-password";
            };
            extraEnv = [
              {
                name = "REDIS_HOST";
                value = "valkey-nextcloud-valkey";
              }
              {
                name = "REDIS_HOST_PORT";
                value = "6379";
              }
              {
                name = "REDIS_HOST_USER";
                value = "nextcloud";
              }
              {
                name = "REDIS_HOST_PASSWORD";
                valueFrom = {
                  secretKeyRef = {
                    name = "nextcloud-secrets";
                    key = "valkey-password";
                  };
                };
              }
            ];
          };
          service = {
            type = "ClusterIP";
            port = 80;
          };
          persistence = {
            enabled = true;
            existingClaim = "nextcloud-pvc";
            nextcloudData = {
              enabled = true;
              existingClaim = "nextcloud-data-pvc";
            };
          };
          resources = config.server.resources.profiles.appLarge;
          internalDatabase.enabled = false;
          externalDatabase = {
            enabled = true;
            type = "postgresql";
            host = "nextcloud-postgres-rw";
            existingSecret = {
              enabled = true;
              secretName = "nextcloud-secrets";
              usernameKey = "username";
              passwordKey = "password";
            };
          };
          collabora = {
            enabled = true;
            image =
              let
                image = inputs.self.lib.findImageByName "collabora/code" config.services.k3s.images;
              in
              {
                repository = image.imageName;
                tag = image.imageTag;
              };
            service = {
              type = "ClusterIP";
              port = 80;
            };
            aliasgroups = [
              { host = "http://nextcloud.nextcloud:80"; }
            ];
            resources = config.server.resources.profiles.appLarge;
          };
          cronjob = {
            enabled = true;
            type = "sidecar";
            resources = config.server.resources.profiles.appMini;
          };
          livenessProbe = {
            initialDelaySeconds = 300;
            periodSeconds = 30;
          };
          readinessProbe = {
            initialDelaySeconds = 300;
            periodSeconds = 30;
          };
        };
      };
    };
}
