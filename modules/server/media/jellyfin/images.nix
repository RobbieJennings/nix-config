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
        imageDigest = "sha256:c9bb091532bec4fa12b3ce3c08d163cab2b369f5f30f1f30ca49a46d97f5eec8";
        hash = "sha256-Chjq1Fp7nUuiUxJy02AZVVg3Ps/S+jpZJhfP8D+d7e4=";
        finalImageTag = "10.11.11";
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
