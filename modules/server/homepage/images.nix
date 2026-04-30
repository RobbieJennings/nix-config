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
        imageDigest = "sha256:0b596092c0b55fe4c65379a428a3fe90bd192f10d1b07d189a34fe5fabe7eedb";
        sha256 = "sha256-f2vJ6WPGf9Gk4XDjH5tMdvWvHhT2D2HZKWanUJQloRE=";
        finalImageTag = "v1.10.1";
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
