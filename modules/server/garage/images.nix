{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.garage-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      garageImage = pkgs.dockerTools.pullImage {
        imageName = "dxflrs/amd64_garage";
        imageDigest = "sha256:dac0c92add4f1a0b41035e94b41036a270ffbe88a37c7ac9c3f19e6dc5bdccf2";
        hash = "sha256-VGx6WQlScsKvnsnMQgQnAMp8ndhwnd0W99WBTbUhGEk=";
        finalImageTag = "v2.3.0";
        arch = "amd64";
      };
      webUiImage = pkgs.dockerTools.pullImage {
        imageName = "khairul169/garage-webui";
        imageDigest = "sha256:17c793551873155065bf9a022dabcde874de808a1f26e648d4b82e168806439c";
        hash = "sha256-ImQ7aSWdfGJd1JREA3SArihzzCQGVH3lZ3dY+mSTktc=";
        finalImageTag = "1.1.0";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.garage.enable {
        services.k3s.images = [
          garageImage
          webUiImage
        ];
      };
    };
}
