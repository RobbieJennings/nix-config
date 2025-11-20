{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  image = pkgs.dockerTools.pullImage {
    imageName = "linuxserver/prowlarr";
    imageDigest = "sha256:3dd3a316f60ea4e6714863286549a6ccaf0b8cf4efe5578ce3fe0e85475cb1cf";
    sha256 = "sha256-eZpWwk0PGRwchS7jUldbdRCnRIbnRSR37c1ANewXLGk=";
    finalImageTag = "2.3.0";
    arch = "amd64";
  };
in
{
  options = {
    server.media.prowlarr.enable = lib.mkEnableOption "prowlarr manifest on k3s";
  };

  config = lib.mkIf (config.server.media.enable && config.server.media.prowlarr.enable) {
    services.k3s = {
      images = [ image ];
      manifests.prowlarr.content = [
        {
          apiVersion = "v1";
          kind = "PersistentVolumeClaim";
          metadata = {
            name = "prowlarr-config";
            namespace = "media";
          };
          spec = {
            accessModes = [ "ReadWriteOnce" ];
            storageClassName = "longhorn";
            resources.requests.storage = "5Gi";
          };
        }
        {
          apiVersion = "apps/v1";
          kind = "Deployment";
          metadata = {
            name = "prowlarr";
            namespace = "media";
          };
          spec = {
            replicas = 1;
            selector.matchLabels.app = "prowlarr";
            template = {
              metadata.labels.app = "prowlarr";
              spec = {
                containers = [
                  {
                    name = "prowlarr";
                    image = "${image.imageName}:${image.imageTag}";
                    ports = [ { containerPort = 8989; } ];
                    volumeMounts = [
                      {
                        name = "config";
                        mountPath = "/config";
                      }
                    ];
                  }
                ];
                volumes = [
                  {
                    name = "config";
                    persistentVolumeClaim.claimName = "prowlarr-config";
                  }
                ];
              };
            };
          };
        }
        {
          apiVersion = "v1";
          kind = "Service";
          metadata = {
            name = "prowlarr-lb";
            namespace = "media";
            annotations = {
              "metallb.io/address-pool" = "default";
              "metallb.universe.tf/allow-shared-ip" = "media";
            };
          };
          spec = {
            type = "LoadBalancer";
            loadBalancerIP = "192.168.0.202";
            selector = {
              "app" = "prowlarr";
            };
            ports = [
              {
                name = "http";
                port = 9696;
                targetPort = 9696;
                protocol = "TCP";
              }
            ];
          };
        }
      ];
    };
  };
}
