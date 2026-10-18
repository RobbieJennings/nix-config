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
        imageDigest = "sha256:0d7c74fc8ca6fef68a5a941c0e7558c8b1e92ba3588fa7505400e1350456c796";
        hash = "sha256-1cQjXEasoB2VLuFfZyxNty4gqZL1qlt1Lsod6nb1BgI=";
        finalImageTag = "v2.4.1";
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
