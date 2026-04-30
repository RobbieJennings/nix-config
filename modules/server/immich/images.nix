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
        imageDigest = "sha256:0cc1f82953d9598eb9e9dd11cbde1f50fe54f9c46c4506b089e8ad7bfc9d1f0c";
        sha256 = "sha256-gk2+L9TS/3/icxEOIcS/kj83aFzHO/4KZ0nT0PVG2oQ=";
        finalImageTag = "v2.6.3";
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
