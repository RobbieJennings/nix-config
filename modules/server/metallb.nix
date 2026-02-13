{
  inputs,
  ...
}:
{
  flake.modules.nixos.metallb =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "metallb";
        repo = "https://metallb.github.io/metallb";
        version = "0.15.2";
        hash = "sha256-Tw/DE82XgZoceP/wo4nf4cn5i8SQ8z9SExdHXfHXuHM=";
      };
      controllerImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/metallb/controller";
        imageDigest = "sha256:417cdb6d6f9f2c410cceb84047d3a4da3bfb78b5ddfa30f4cf35ea5c667e8c2e";
        sha256 = "sha256-AzOCFyOAeLsFw7ESAg8iYygzH4ygxgNQcJ5rpajbnio=";
        finalImageTag = "v0.15.2";
        arch = "amd64";
      };
      speakerImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/metallb/speaker";
        imageDigest = "sha256:260c9406f957c0830d4e6cd2e9ac8c05e51ac959dd2462c4c2269ac43076665a";
        sha256 = "sha256-gdy9zFJjY9wTYKuF7j5NW16V6oPWdFwEji+Nvt5Qr7Y=";
        finalImageTag = "v0.15.2";
        arch = "amd64";
      };
    in
    {
      options = {
        metallb.enable = lib.mkEnableOption "metalLB helm chart on k3s";
      };

      config = lib.mkIf config.metallb.enable {
        services.k3s = {
          images = [
            controllerImage
            speakerImage
          ];
          autoDeployCharts.metallb = chart // {
            targetNamespace = "metallb-system";
            createNamespace = true;
            values = {
              controller.image = {
                repository = controllerImage.imageName;
                tag = controllerImage.imageTag;
              };
              speaker.image = {
                repository = speakerImage.imageName;
                tag = speakerImage.imageTag;
              };
            };
            extraDeploy = [
              {
                apiVersion = "metallb.io/v1beta1";
                kind = "IPAddressPool";
                metadata = {
                  name = "default";
                  namespace = "metallb-system";
                };
                spec = {
                  addresses = [ "192.168.0.200-192.168.0.210" ];
                  autoAssign = true;
                };
              }
              {
                apiVersion = "metallb.io/v1beta1";
                kind = "L2Advertisement";
                metadata = {
                  name = "default";
                  namespace = "metallb-system";
                };
                spec = {
                  ipAddressPools = [ "default" ];
                };
              }
            ];
          };
        };
      };
    };
}
