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
        imageDigest = "sha256:a0b71c8e757298d02560186bab9fbe3fc2d375c523a62cc1019177b37e48aa28";
        hash = "sha256-hMoNS9Lwcg4irFkIfD1MhFo2iAjrCJNk9W2P0/FW6jU=";
        finalImageTag = "v1.13.2";
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
