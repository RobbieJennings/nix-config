{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.seerr-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      seerrImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/seerr-team/seerr";
        imageDigest = "sha256:27602401178d54f1964442287b9f23f67a3fa2252645ee8065839ea1c3f69e45";
        hash = "sha256-nqGf7CP5pJpIZm4/W4jklAQj4NojBrXL0ckNwYtFXBE=";
        finalImageTag = "v3.5.0";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.seerr.enable) {
        services.k3s = {
          images = [ seerrImage ];
        };
      };
    };
}
