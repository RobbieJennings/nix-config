{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.sonarr-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      sonarrImage = pkgs.dockerTools.pullImage {
        imageName = "linuxserver/sonarr";
        imageDigest = "sha256:fbb15bb4fb14d1ffe017f6be0e3fed8f1b300e4687e329767da0b61f36ba1eed";
        hash = "sha256-t67YMx0MHEjpmUsM/aXczCIhgInrRRGJqUcrXPYHlik=";
        finalImageTag = "4.0.19";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.sonarr.enable) {
        services.k3s = {
          images = [ sonarrImage ];
        };
      };
    };
}
