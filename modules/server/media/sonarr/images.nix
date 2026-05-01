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
        imageDigest = "sha256:4b8a853b76337cd5de5f69961e23b7d0792ce7bf0a8be083dd7202ef670bfc34";
        sha256 = "sha256-/wqQhgSMQ8fHwjNS+8n4VtWi/2bREJAPbCaIqeJKMDw=";
        finalImageTag = "4.0.16";
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
