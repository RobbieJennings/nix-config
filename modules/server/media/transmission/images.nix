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
        imageDigest = "sha256:9b229b05a4027a5548285f66b2ba4cbf12bdef83ddac97f726afa94fbae308c0";
        hash = "sha256-HHxPR+7xJ7QkBxvqBwNMMol4j9EBbGUXW7cn742l7kU=";
        finalImageTag = "4.1.2";
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
