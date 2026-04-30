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
                value = "nextcloud-valkey";
              }
              {
                name = "REDIS_HOST_PORT";
                value = "6379";
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
          resources = {
            requests.cpu = "200m";
            requests.memory = "1Gi";
            limits.cpu = "800m";
            limits.memory = "2Gi";
          };
          collabora = {
            enabled = true;
            image = {
              repository =
                (lib.lists.findSingle (
                  x: x ? imageName && x.imageName == "collabora/code"
                ) null null config.services.k3s.images).imageName;
              tag =
                (lib.lists.findSingle (
                  x: x ? imageName && x.imageName == "collabora/code"
                ) null null config.services.k3s.images).imageTag;
            };
            service = {
              type = "ClusterIP";
              port = 80;
            };
            resources = {
              requests.cpu = "200m";
              requests.memory = "1Gi";
              limits.cpu = "800m";
              limits.memory = "2Gi";
            };
          };
          cronjob = {
            enabled = true;
            type = "sidecar";
            resources = {
              requests.cpu = "50m";
              requests.memory = "128Mi";
              limits.cpu = "300m";
              limits.memory = "256Mi";
            };
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
