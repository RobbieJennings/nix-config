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
        imageDigest = "sha256:a89f252d6a22bd25af14a5380aec0adcc3c3af2e3282164f981680e6844070f3";
        hash = "sha256-saVxi8NtX4TIr52ZPcHiH25SrhNaIMCZ34z4aiFrcv4=";
        finalImageTag = "2.3.5";
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
