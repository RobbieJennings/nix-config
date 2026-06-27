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
        imageDigest = "sha256:3950b5e48cf4ba9dab78fe14038dd7f062e66b7b4ab368b02c94a13f6a3dae9f";
        hash = "sha256-9pXhGbBGKai6JXeG+bguDzQmV7T1CT7xw0zZQ6fBNog=";
        finalImageTag = "2.4.0";
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
