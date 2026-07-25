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
        imageDigest = "sha256:6c6c20baffae4a3ec50f29ec9361608a420625185505e8cd6f0c44d71c5d4798";
        hash = "sha256-RT1cQtdTmMx+1GiVBZg4npy19OyrXsgUNJe43uGX+Lw=";
        finalImageTag = "0.72.4";
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
