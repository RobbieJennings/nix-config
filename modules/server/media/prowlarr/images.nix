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
        imageDigest = "sha256:3dd3a316f60ea4e6714863286549a6ccaf0b8cf4efe5578ce3fe0e85475cb1cf";
        sha256 = "sha256-eZpWwk0PGRwchS7jUldbdRCnRIbnRSR37c1ANewXLGk=";
        finalImageTag = "2.3.0";
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
