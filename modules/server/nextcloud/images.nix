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
        imageDigest = "sha256:a588aa5353703b44106a6129adaaf7bf22521b7a4754f9f529b3228d6aa390c5";
        hash = "sha256-ju9KdwboD2+UMhjn5rvCBXSM8a2CzTKpRYuDTH4TlHM=";
        finalImageTag = "35.0.2";
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
        services.k3s.images = [
          nextcloudImage
          collaboraImage
        ];
      };
    };
}
