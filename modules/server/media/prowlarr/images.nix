{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.prowlarr-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      prowlarrImage = pkgs.dockerTools.pullImage {
        imageName = "linuxserver/prowlarr";
        imageDigest = "sha256:f9151e5bc1025c6d0a630d503210cdcb6bb55a7cc098562609d96a408d838902";
        hash = "sha256-XM8R2hmuA+OXKA+zLyYqFd6KWj3rEpMI7tVoR/Mt0jQ=";
        finalImageTag = "2.6.5.5623-ls163";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.prowlarr.enable) {
        services.k3s = {
          images = [ prowlarrImage ];
        };
      };
    };
}
