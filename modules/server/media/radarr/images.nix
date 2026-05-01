{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.radarr-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      radarrImage = pkgs.dockerTools.pullImage {
        imageName = "linuxserver/radarr";
        imageDigest = "sha256:e26fbfd3782520c0bb820666f041ca056acfe187a8b95214ee1f47512cc05a29";
        sha256 = "sha256-64z/xPzOPu5ow5dgKLPGY7D2P9fikhhSkXu3GPqr7WM=";
        finalImageTag = "6.0.4";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.radarr.enable) {
        services.k3s = {
          images = [ radarrImage ];
        };
      };
    };
}
