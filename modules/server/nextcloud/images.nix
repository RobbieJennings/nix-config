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
        imageDigest = "sha256:b67959acacd54ed2d110e111c8b28c0a87a20129f9427bf5f721a1dc6121decb";
        hash = "sha256-0cKts3EiFIMYFlk5lK7AccHN6bsySc+BhIqA1Qtr1Kc=";
        finalImageTag = "33.0.3";
        arch = "amd64";
      };
      collaboraImage = pkgs.dockerTools.pullImage {
        imageName = "collabora/code";
        imageDigest = "sha256:fe49c08c27e102c1877ad4ef2ac1a7bd8ccd2dfaa6641d4533389c204a92bb88";
        hash = "sha256-mX5g7B3mbJVnUdt2WeDoHzK/FyYL7h+MOye0SB0fKZg=";
        finalImageTag = "25.04.9.4.1";
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
