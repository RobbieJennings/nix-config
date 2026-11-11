{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.audiobookshelf-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      calibreWebAutomatedImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/advplyr/audiobookshelf";
        imageDigest = "sha256:b897c33f05972fb1bf484f7487bc878fa91ec8691335c1db6e2929c3a7658efa";
        hash = "sha256-yNWGvI0+W91r8wl63zK/ebdWFrwmR/3+KsUABmluksI=";
        finalImageTag = "2.37.2";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.audiobookshelf.enable) {
        services.k3s = {
          images = [ calibreWebAutomatedImage ];
        };
      };
    };
}
