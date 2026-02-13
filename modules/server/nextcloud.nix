{
  inputs,
  ...
}:
{
  flake.modules.nixos.nextcloud =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "nextcloud";
        repo = "https://nextcloud.github.io/helm";
        version = "8.7.0";
        hash = "sha256-LoEz0+iETV9kBxiRB7aML4Jzk4LhmrUQMHBQipYnWzE=";
      };
      nextcloudImage = pkgs.dockerTools.pullImage {
        imageName = "nextcloud";
        imageDigest = "sha256:a9ef7ed15dbf3f9fcf6dc2a41a15af572fcc077f220640cabfe574a3ffbf5766";
        sha256 = "sha256-Z9/e4KP2gH6HP+pglHpWGK0cnmReJjR1InRh8kfjUmQ=";
        finalImageTag = "32.0.3";
        arch = "amd64";
      };
      postgresqlImage = pkgs.dockerTools.pullImage {
        imageName = "bitnamilegacy/postgresql";
        imageDigest = "sha256:5cf757a084469da93ca39a294c9ec7c1aaf2d2a5f728001676ece1a9607fa57f";
        sha256 = "sha256-iNx2E4xnEterjgXd7NUlscLHEmDNVt2y3Mq7Ki98x+Q=";
        finalImageTag = "17.5.0-debian-12-r3";
        arch = "amd64";
      };
      redisImage = pkgs.dockerTools.pullImage {
        imageName = "bitnamilegacy/redis";
        imageDigest = "sha256:25bf63f3caf75af4628c0dfcf39859ad1ac8abe135be85e99699f9637b16dc28";
        sha256 = "sha256-6jt1aa3gnfFd9CP2XKAhT3WgOTTibv+29BUvkwiE3CQ=";
        finalImageTag = "8.0.1-debian-12-r1";
        arch = "amd64";
      };
      collaboraImage = pkgs.dockerTools.pullImage {
        imageName = "collabora/code";
        imageDigest = "sha256:4585c88c15d681a04495e9881e99974040373089b941d6909f9c9e817553457c";
        sha256 = "sha256-di7mSLOlmF0utm37w0FWySFKHiKJ2/EuMeHQMT7Py8s=";
        finalImageTag = "25.04.7.2.1";
        arch = "amd64";
      };
    in
    {
      options = {
        nextcloud.enable = lib.mkEnableOption "nextcloud helm chart on k3s";
      };

      config = lib.mkIf config.nextcloud.enable {
        services.k3s = {
          images = [
            nextcloudImage
            postgresqlImage
            redisImage
            collaboraImage
          ];
          autoDeployCharts.nextcloud = chart // {
            targetNamespace = "nextcloud";
            createNamespace = true;
            values = {
              image = {
                repository = nextcloudImage.imageName;
                tag = nextcloudImage.imageTag;
              };
              nextcloud = {
                host = "192.168.0.203";
                trustedDomains = [ "192.168.0.203" ];
              };
              service = {
                type = "LoadBalancer";
                loadBalancerIP = "192.168.0.203";
                annotations = {
                  "metallb.io/address-pool" = "default";
                  "metallb.io/allow-shared-ip" = "nextcloud";
                };
              };
              persistence = {
                enabled = true;
                size = "8Gi";
                nextcloudData = {
                  enabled = true;
                  size = "10Gi";
                };
              };
              resources = {
                requests.cpu = "500m";
                requests.memory = "2Gi";
                limits.cpu = "1000m";
                limits.memory = "4Gi";
              };
              internalDatabase.enabled = false;
              externalDatabase = {
                enabled = true;
                type = "postgresql";
                host = "nextcloud-postgresql.nextcloud.svc.cluster.local";
              };
              postgresql = {
                enabled = true;
                image = {
                  repository = postgresqlImage.imageName;
                  tag = postgresqlImage.imageTag;
                };
                primary = {
                  persistence = {
                    enabled = true;
                    size = "8Gi";
                  };
                  resources = {
                    requests.cpu = "500m";
                    requests.memory = "512Mi";
                    limits.cpu = "1000m";
                    limits.memory = "1Gi";
                  };
                  extraEnvVars = [
                    {
                      name = "POSTGRESQL_SHARED_BUFFERS";
                      value = "256MB";
                    }
                    {
                      name = "POSTGRESQL_EFFECTIVE_CACHE_SIZE";
                      value = "768MB";
                    }
                  ];
                };
              };
              redis = {
                enabled = true;
                image = {
                  repository = redisImage.imageName;
                  tag = redisImage.imageTag;
                };
                architecture = "standalone";
                master = {
                  persistence = {
                    enabled = true;
                    size = "8Gi";
                  };
                  resources = {
                    requests.cpu = "100m";
                    requests.memory = "128Mi";
                    limits.cpu = "200m";
                    limits.memory = "256Mi";
                  };
                  extraFlags = [
                    "--maxmemory 200mb"
                    "--maxmemory-policy allkeys-lru"
                  ];
                };
              };
              collabora = {
                enabled = true;
                image = {
                  repository = collaboraImage.imageName;
                  tag = collaboraImage.imageTag;
                };
                service = {
                  type = "LoadBalancer";
                  annotations = {
                    "metallb.io/address-pool" = "default";
                    "metallb.io/loadBalancerIPs" = "192.168.0.203";
                    "metallb.io/allow-shared-ip" = "nextcloud";
                  };
                };
                resources = {
                  requests.cpu = "500m";
                  requests.memory = "1Gi";
                  limits.cpu = "1000m";
                  limits.memory = "2Gi";
                };
              };
              cronjob = {
                enabled = true;
                type = "sidecar";
                resources = {
                  requests.cpu = "200m";
                  requests.memory = "256Mi";
                  limits.cpu = "500m";
                  limits.memory = "512Mi";
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
      };
    };
}
