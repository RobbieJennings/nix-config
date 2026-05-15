{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.jellyfin-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      jellyfinImage = pkgs.dockerTools.pullImage {
        imageName = "linuxserver/jellyfin";
        imageDigest = "sha256:e622a48adf7193c7d626c2325a40f9b01c932c8e7bf3f50ffa40e7e9b6ce1d39";
        hash = "sha256-6ywpJewD2TEBbCx9ol9QLzJci2tyKFGO/z9LC0JDJcE=";
        finalImageTag = "10.11.8";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.jellyfin.enable) {
        services.k3s = {
          images = [ jellyfinImage ];
        };
      };
    };
}
