{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.calibre-web-automated-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      calibreWebAutomatedImage = pkgs.dockerTools.pullImage {
        imageName = "crocodilestick/calibre-web-automated";
        imageDigest = "sha256:5e00373854247750cc3e4479b492ae09293ff5e06ed10177f226634d97888679";
        hash = "sha256-BC8oAA0aZ49IWGNwRFBPo42nSfhF1xx/HD0Xz7TPO8Q=";
        finalImageTag = "v4.0.8";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.calibre-web-automated.enable) {
        services.k3s = {
          images = [ calibreWebAutomatedImage ];
        };
      };
    };
}
