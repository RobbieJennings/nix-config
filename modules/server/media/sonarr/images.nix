{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.sonarr-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      sonarrImage = pkgs.dockerTools.pullImage {
        imageName = "linuxserver/sonarr";
        imageDigest = "sha256:44b06045a98bc1f237b9ffefc4b28dab64cb29305e4a2a94875ae93b5224e4cc";
        hash = "sha256-ESaiPX+5oAUr8N5YJLCJqCwkwRInyo05Fh7T+F7lcFk=";
        finalImageTag = "4.0.20.3014-ls329";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.sonarr.enable) {
        services.k3s = {
          images = [ sonarrImage ];
        };
      };
    };
}
