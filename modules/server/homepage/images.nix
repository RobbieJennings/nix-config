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
        imageDigest = "sha256:d8d784e5090111b6e4c56dfd90e272d2953a2094e87349f647165df0fa6c4401";
        hash = "sha256-rrtvMdO2AzrzadkjigFqlPrcrtMaByCa5gjGz6Hg3SU=";
        finalImageTag = "v1.13.1";
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
