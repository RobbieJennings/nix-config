{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.lidarr-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      lidarrImage = pkgs.dockerTools.pullImage {
        imageName = "linuxserver/lidarr";
        imageDigest = "sha256:67887807b13ae025c0fe979da298347c8609969087ab064c81d8e9acc1e06bbf";
        hash = "sha256-suHEsdVgtGiOzV40xLfIR/JldkVs+U8gSSRYt9VkOaU=";
        finalImageTag = "3.1.0.4875-ls43";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.lidarr.enable) {
        services.k3s = {
          images = [ lidarrImage ];
        };
      };
    };
}
