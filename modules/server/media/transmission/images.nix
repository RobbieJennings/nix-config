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
        imageDigest = "sha256:d6caecad406774a18511be7bfa99ba5070c17a3bdd7a5d73091651841603273c";
        hash = "sha256-/f007hhdkFTQvUUTOk/L0aAi9BSZOCl+r9dkmU31+xU=";
        finalImageTag = "4.1.3-r0-ls364";
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
