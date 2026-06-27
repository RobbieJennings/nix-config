{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.flaresolverr-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      flaresolverrImage = pkgs.dockerTools.pullImage {
        imageName = "flaresolverr/flaresolverr";
        imageDigest = "sha256:139dfee1c6f89249c8d665d1333a42e8ec74ec0a86bc6bb1c8461e10d3a66a47";
        hash = "sha256-dQQF1r6H1QbrBADtlr9E3R06zLZWQfEq60JuT6aYNKM=";
        finalImageTag = "v3.5.0";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.flaresolverr.enable) {
        services.k3s = {
          images = [ flaresolverrImage ];
        };
      };
    };
}
