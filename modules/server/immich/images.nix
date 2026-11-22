{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.immich-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      immichImages = {
        immichImage = pkgs.dockerTools.pullImage {
          imageName = "ghcr.io/immich-app/immich-server";
          imageDigest = "sha256:bae7664ff3aa4c2c1fcbdcdd86b40b105643c5f861f3e6a770fc760089f25862";
          hash = "sha256-tFFSRi5Z1lEtVBCJyd5zuRPLU4dFK2r7I0EpfD8aPgQ=";
          finalImageTag = "v3.3.3";
          arch = "amd64";
        };
      };
    in
    {
      config = {
        _module.args.immichImages = immichImages;
        services.k3s = lib.mkIf config.immich.enable {
          images = builtins.attrValues immichImages;
        };
      };
    };
}
