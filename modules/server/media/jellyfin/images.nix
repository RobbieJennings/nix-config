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
        imageDigest = "sha256:367630b4e4e643c3c1d00bb76f13f3dbe318ad817c01256c358316c7acc3919b";
        sha256 = "sha256-5Vx7FccwINl85GSwXXc2CX/O+VgIaxsNVuMMDT18itI=";
        finalImageTag = "10.11.3";
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
