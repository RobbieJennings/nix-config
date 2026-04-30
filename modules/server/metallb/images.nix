{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.metallb-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
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
      config = lib.mkIf config.metallb.enable {
        services.k3s = {
          images = [
            controllerImage
            speakerImage
          ];
          autoDeployCharts.metallb.values = {
            controller.image = {
              repository = controllerImage.imageName;
              tag = controllerImage.imageTag;
            };
            speaker.image = {
              repository = speakerImage.imageName;
              tag = speakerImage.imageTag;
            };
          };
        };
      };
    };
}
