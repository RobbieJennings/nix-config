{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.shelfmark-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      shelfmarkImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/calibrain/shelfmark";
        imageDigest = "sha256:0b400a5d58951b35bfede3d9943b632551259c31e130316fe56c5cc0e2e4faea";
        hash = "sha256-NFqasgbQ9H+236j4mHv/rNtLLO0yxbFOI3PDEt5caes=";
        finalImageTag = "v1.6.2";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.shelfmark.enable) {
        services.k3s = {
          images = [ shelfmarkImage ];
        };
      };
    };
}
