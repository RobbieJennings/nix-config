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
        imageDigest = "sha256:6698ccc54c380913816ed1fd0758637ec87dd79da419c4ab170a2c26c158ab89";
        hash = "sha256-j71loxJPSdOfqSGX3b5/4X7OtwhQlslAsSGnhpDlcZ8=";
        finalImageTag = "v0.15.3";
        arch = "amd64";
      };
      speakerImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/metallb/speaker";
        imageDigest = "sha256:c6a5b25b2e1fba610a57b2db4bb8141d7c133569d561a8cc29e38ca5113efbc4";
        hash = "sha256-t2epMeOG1rfWG3juOMfEhb9bfzksvQ0SuwOLJKB1ob4=";
        finalImageTag = "v0.15.3";
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
