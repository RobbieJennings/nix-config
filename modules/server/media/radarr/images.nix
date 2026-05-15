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
        imageDigest = "sha256:15417a594ebda4c660a9fa9748e7199d33e2d17b31bbc5ad7ba2e86f0b414763";
        hash = "sha256-wMaIcEAlEDGMwUNc+UdVRu49M2T/+nqaIZ4DvWcF74k=";
        finalImageTag = "6.1.1";
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
