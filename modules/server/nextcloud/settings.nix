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
      options.nextcloud = {
        nextcloudResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.appLarge;
          description = "Resource profile for Nextcloud";
        };
        collaboraResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.appLarge;
          description = "Resource profile for Nextcloud's Collabora instance";
        };
        cronJobResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.appMini;
          description = "Resource profile for Nextcloud's cron jobs";
        };
      };

      config = lib.mkIf config.nextcloud.enable {
        services.k3s.autoDeployCharts.nextcloud.values = {
          image = {
            repository = config._module.args.nextcloudImages.nextcloudImage.imageName;
            tag = config._module.args.nextcloudImages.nextcloudImage.imageTag;
          };
          nextcloud = {
            host = "nextcloud.nextcloud";
            trustedDomains = [
              config.nextcloud.loadBalancerIP
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
          resources = config.nextcloud.nextcloudResources;
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
            image = {
              repository = config._module.args.nextcloudImages.collaboraImage.imageName;
              tag = config._module.args.nextcloudImages.collaboraImage.imageTag;
            };
            service = {
              type = "ClusterIP";
              port = 80;
            };
            aliasgroups = [
              { host = "http://nextcloud.nextcloud:80"; }
            ];
            resources = config.nextcloud.collaboraResources;
          };
          cronjob = {
            enabled = true;
            type = "sidecar";
            resources = config.nextcloud.cronJobResources;
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
