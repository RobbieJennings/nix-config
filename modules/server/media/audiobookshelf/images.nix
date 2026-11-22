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
      audiobookshelfImages = {
        audiobookshelfImage = pkgs.dockerTools.pullImage {
          imageName = "ghcr.io/advplyr/audiobookshelf";
          imageDigest = "sha256:b897c33f05972fb1bf484f7487bc878fa91ec8691335c1db6e2929c3a7658efa";
          hash = "sha256-yNWGvI0+W91r8wl63zK/ebdWFrwmR/3+KsUABmluksI=";
          finalImageTag = "2.37.2";
          arch = "amd64";
        };
      };
    in
    {
      config = {
        _module.args.audiobookshelfImages = audiobookshelfImages;
        services.k3s = lib.mkIf (config.media-server.enable && config.media-server.audiobookshelf.enable) {
          images = builtins.attrValues audiobookshelfImages;
        };
      };
    };
}
