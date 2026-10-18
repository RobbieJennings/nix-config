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
        imageDigest = "sha256:ea6822c956d26db648b237919f41340318f32e5b7dcc4ba702cf256a0f5f3c12";
        hash = "sha256-gB0EwhkcwYzSGtJGLN4+ZctXcHPC8uh8DgyaFba2T5E=";
        finalImageTag = "6.4.4.10685-ls321";
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
