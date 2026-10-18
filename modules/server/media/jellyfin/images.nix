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
        imageDigest = "sha256:799509f8ef3be7037478699cc6fd14d19dd75faac5e474ed219e98ae78a5b3e4";
        hash = "sha256-BA31Wg5T6ps7vKF+OXWQ0qxn7stM5j32FWsXdS5RtsA=";
        finalImageTag = "12.2ubu2604-ls54";
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
