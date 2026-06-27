{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.metallb-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      controllerImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/metallb/controller";
        imageDigest = "sha256:f51ab515de9ccd20dc3dccb093e48df8adddac019326c456f449e55ba91b6420";
        hash = "sha256-xMUYC0LdL0WR3lJHAfRcd70v4AXr3xW3IJaaYm1P9fo=";
        finalImageTag = "v0.16.1";
        arch = "amd64";
      };
      speakerImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/metallb/speaker";
        imageDigest = "sha256:16561e96531e1852d5c229ad7fae6e994dcfa983ff7f4de6b6208b34a4e2ddbc";
        hash = "sha256-8Zt86xIoSeF3TkftWQjKioIDQOB7KTArbzDTU40gxG0=";
        finalImageTag = "v0.16.1";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.metallb.enable {
        services.k3s.images = [
          controllerImage
          speakerImage
        ];
      };
    };
}
