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
      immichImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/immich-app/immich-server";
        imageDigest = "sha256:c15bff75068effb03f4355997d03dc7e0fc58720c2b54ad6f7f10d1bc57efaa5";
        hash = "sha256-NYgLfm8rX8o3GYLoavG8i3gqwyKKLIeJLXGGYLZUazY=";
        finalImageTag = "v2.7.5";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.immich.enable {
        services.k3s = {
          images = [ immichImage ];
        };
      };
    };
}
