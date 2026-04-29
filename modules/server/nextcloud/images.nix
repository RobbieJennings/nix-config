{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.nextcloud-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      nextcloudImage = pkgs.dockerTools.pullImage {
        imageName = "nextcloud";
        imageDigest = "sha256:a9ef7ed15dbf3f9fcf6dc2a41a15af572fcc077f220640cabfe574a3ffbf5766";
        sha256 = "sha256-Z9/e4KP2gH6HP+pglHpWGK0cnmReJjR1InRh8kfjUmQ=";
        finalImageTag = "32.0.3";
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
      config = lib.mkIf config.nextcloud.enable {
        services.k3s = {
          images = [
            nextcloudImage
            collaboraImage
          ];
          autoDeployCharts.nextcloud.values = {
            image = {
              repository = nextcloudImage.imageName;
              tag = nextcloudImage.imageTag;
            };
          };
        };
      };
    };
}
