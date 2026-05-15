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
        imageDigest = "sha256:0f89a7385eadfde8a47adbfa0ee7913e8d0b938293e08615ca0aa1deab91fcb4";
        hash = "sha256-DYq4Gb7aGoH0L915fCf9f+gP17CZHfjbq8kR21/kuc4=";
        finalImageTag = "v0.4.1";
        arch = "amd64";
      };
      routerImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/netbirdio/netbird";
        imageDigest = "sha256:4c37fb63f33531fc0c5eec272839b0e4d290c595a0b15bf5fd9a288df1890392";
        hash = "sha256-TDBO4bjEhbcj01z1ZdoSjfPS226LmC3bxOyyusFwh2M=";
        finalImageTag = "0.71.0-rootless";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.netbird-operator.enable {
        services.k3s = {
          images = [
            operatorImage
            routerImage
          ];
          autoDeployCharts.netbird-operator.values = {
            operator.image = {
              repository = operatorImage.imageName;
              tag = operatorImage.imageTag;
            };
            routingClientImage = "${routerImage.imageName}:${routerImage.imageTag}";
          };
        };
      };
    };
}
