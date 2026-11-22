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
      flaresolverrImages = {
        flaresolverrImage = pkgs.dockerTools.pullImage {
          imageName = "flaresolverr/flaresolverr";
          imageDigest = "sha256:c80ae007ce2ccdcd217a12426e4f039ef763ff90738c808d38810c3e59323767";
          hash = "sha256-KyQfgFTLmeJ+pp1qnaq3FQ6nbm8M2SBNg9SCDReMfzQ=";
          finalImageTag = "v3.5.2";
          arch = "amd64";
        };
      };
    in
    {
      config = {
        _module.args.flaresolverrImages = flaresolverrImages;
        services.k3s = lib.mkIf (config.media-server.enable && config.media-server.flaresolverr.enable) {
          images = builtins.attrValues flaresolverrImages;
        };
      };
    };
}
