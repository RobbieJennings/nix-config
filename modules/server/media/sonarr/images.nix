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
        imageDigest = "sha256:60f3b6b5c7647ba2bafd81163acfe34b11117b9b834ebd7fbcc3e5f1b309c7ef";
        hash = "sha256-ZK7gdBgMWez9O5Ky4Z5pWaoMSPfxBkdjDLb2vM5u5z4=";
        finalImageTag = "4.0.17";
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
