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
        imageDigest = "sha256:7962759d99d7e125e108e0f5e7f3cdbcd36161776d058d1d9b7153b92ef1af9e";
        sha256 = "sha256-ANmJg+ZQYLXIZrbOSufKR8khSiuJ9S+83DCFCBf2Yf4=";
        finalImageTag = "3.4.6";
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
