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
        imageDigest = "sha256:1e95b5c13fe015361a9ae1c4d99fc2336816790aaea60fa74b2ffebe076a69e0";
        hash = "sha256-2A0+rQoKkJn0Vt/NffOa2UX9Z8rr4kXjbKEHZdpd72s=";
        finalImageTag = "6.2.1";
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
