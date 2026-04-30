{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.transmission-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      transmissionImage = pkgs.dockerTools.pullImage {
        imageName = "linuxserver/transmission";
        imageDigest = "sha256:978b9e0b06eda2cfed79c861fc8ca440b8b29e45dc9dc2522daa67c3818a0d88";
        sha256 = "sha256-uQWuUyhumbEmxTgYzhWtLjg6z+67qQqlRZ2W134ZHbA=";
        finalImageTag = "4.0.6";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.transmission.enable) {
        services.k3s = {
          images = [ transmissionImage ];
        };
      };
    };
}
