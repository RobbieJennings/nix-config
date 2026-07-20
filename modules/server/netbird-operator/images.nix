{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.netbird-operator-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      operatorImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/netbirdio/netbird-operator";
        imageDigest = "sha256:ae2c26cfc54762723c50cb7df1178452807fa265c1acddec1debf83503fabe59";
        hash = "sha256-pRu6DbZs2cjeRREjQDQTn0xyIskQkES+j0LBs16nELI=";
        finalImageTag = "v0.8.0";
        arch = "amd64";
      };
      routerImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/netbirdio/netbird";
        imageDigest = "sha256:b63f4c1584118aeebacfdfd841f0351122a53fccac182b4c43be428c2c9a6b73";
        hash = "sha256-66McFH3+9wBLDEwQ7J91VmI7lGPBHEgVKsH81qKKYAY=";
        finalImageTag = "0.74.7";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.netbird-operator.enable {
        services.k3s.images = [
          operatorImage
          routerImage
        ];
      };
    };
}
