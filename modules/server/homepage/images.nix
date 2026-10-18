{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.homepage-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      homepageImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/gethomepage/homepage";
        imageDigest = "sha256:3e38fe788223cb46a3ce1f046ef11667b40f7707fdca0dcbfa3f86c5c42bf1e8";
        hash = "sha256-yJ38+OoptYzlXo8zKpGoySn8QfCH9Duof+ZmDQgEGwQ=";
        finalImageTag = "v2.6.0";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.homepage.enable {
        services.k3s = {
          images = [ homepageImage ];
        };
      };
    };
}
