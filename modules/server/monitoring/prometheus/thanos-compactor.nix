{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.prometheus-thanos-compactor =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.monitoring.prometheus.enable {
        services.k3s.manifests.thanos-compactor.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "prometheus-thanos-compactor-pv";
            };
            spec = {
              capacity.storage = "10Gi";
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "prometheus-thanos-compactor";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "monitoring";
                name = "prometheus-thanos-compactor-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "prometheus-thanos-compactor-pvc";
              namespace = "monitoring";
            };
            spec = {
              resources.requests.storage = "10Gi";
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "prometheus-thanos-compactor-pv";
            };
          }
          {
            apiVersion = "apps/v1";
            kind = "Deployment";
            metadata = {
              name = "prometheus-thanos-compactor";
              namespace = "monitoring";
              labels.app = "thanos-compactor";
            };
            spec = {
              replicas = 1;
              selector.matchLabels.app = "prometheus-thanos-compactor";
              template = {
                metadata.labels.app = "prometheus-thanos-compactor";
                spec = {
                  securityContext = {
                    fsGroup = 1000;
                    runAsUser = 1000;
                    runAsGroup = 1000;
                  };
                  containers = [
                    {
                      name = "prometheus-thanos-compactor";
                      image = "${config._module.args.prometheusImages.thanosImage.imageName}:${config._module.args.prometheusImages.thanosImage.imageTag}";
                      ports = [ { containerPort = 10902; } ];
                      args = [
                        "compact"
                        "--wait"
                        "--wait-interval=5m"
                        "--data-dir=/var/thanos/compact"
                        "--objstore.config-file=/etc/thanos/thanos-config.yaml"
                        "--compact.concurrency=1"
                        "--retention.resolution-raw=3d"
                        "--retention.resolution-5m=14d"
                        "--retention.resolution-1h=14d"
                      ];
                      resources = config.server.resources.profiles.infraLarge;
                      startupProbe = {
                        httpGet = {
                          path = "/";
                          port = 10902;
                        };
                        failureThreshold = 30;
                        periodSeconds = 5;
                      };
                      readinessProbe = {
                        httpGet = {
                          path = "/";
                          port = 10902;
                        };
                        initialDelaySeconds = 15;
                        periodSeconds = 10;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      livenessProbe = {
                        httpGet = {
                          path = "/";
                          port = 10902;
                        };
                        initialDelaySeconds = 30;
                        periodSeconds = 20;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      volumeMounts = [
                        {
                          name = "thanos-config";
                          mountPath = "/etc/thanos";
                          readOnly = true;
                        }
                        {
                          name = "thanos-compactor";
                          mountPath = "/var/thanos/compact";
                        }
                      ];
                    }
                  ];
                  volumes = [
                    {
                      name = "thanos-config";
                      secret = {
                        secretName = "prometheus-thanos-secrets";
                        items = [
                          {
                            key = "thanos-config";
                            path = "thanos-config.yaml";
                          }
                        ];
                      };
                    }
                    {
                      name = "thanos-compactor";
                      persistentVolumeClaim.claimName = "prometheus-thanos-compactor-pvc";
                    }
                  ];
                };
              };
            };
          }
        ];
      };
    };
}
