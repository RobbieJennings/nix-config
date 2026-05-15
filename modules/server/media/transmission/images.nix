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
        imageDigest = "sha256:62a88fbc210fc62d867eab9c67a0f5474db7257013ce598173a9efc1043e97b8";
        hash = "sha256-GxWK3rrGfhAE7TSrYZucMMkm8fpkyyLOp6eBFoJ+5JA=";
        finalImageTag = "4.1.1";
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
