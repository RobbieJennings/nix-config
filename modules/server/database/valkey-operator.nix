{
  inputs,
  ...
}:
{
  flake.modules.nixos.valkey-operator =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "valkey-operator";
        repo = "https://valkey.io/valkey-helm";
        version = "0.2.7";
        hash = "sha256-j0TMgTJuZIJIuKRR51rc/4sN+U25LnTUMjs7qpYA0Jw=";
      };
      operatorImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/valkey-io/valkey-operator";
        imageDigest = "sha256:af108f6e9a5647271796c4d2f41ec9336c60b8da74cd2f106daf1157e7a521a2";
        hash = "sha256-cLuf0OzIteu/oN4rxvUmHJOXphBZOal7VfQtWr7gqik=";
        finalImageTag = "v0.2.0";
        arch = "amd64";
      };
      valkeyImage = pkgs.dockerTools.pullImage {
        imageName = "valkey/valkey";
        imageDigest = "sha256:4963247afc4cd33c7d3b2d2816b9f7f8eeebab148d29056c2ca4d7cbc966f2d9";
        hash = "sha256-Cgdk10ekicmOSPcAR9Xuraqo81+qqe/w8m37XExHZ5g=";
        finalImageTag = "9.1.0";
        arch = "amd64";
      };
      exporterImage = pkgs.dockerTools.pullImage {
        imageName = "oliver006/redis_exporter";
        imageDigest = "sha256:2e9795be900db073e9475fdb9c5124db309b07a3e4e75a1770705cb03be1a1c8";
        hash = "sha256-haL7PXhx12d5QdzkHhuQbffRdB97g2ktZI1KJkqvxtM=";
        finalImageTag = "v1.86.0";
        arch = "amd64";
      };
    in
    {
      options = {
        valkey-operator.enable = lib.mkEnableOption "valkey-operator helm chart on k3s";
      };

      config = lib.mkIf config.valkey-operator.enable {
        services.k3s = {
          images = [
            operatorImage
            valkeyImage
            exporterImage
          ];
          autoDeployCharts = {
            valkey-operator = chart // {
              targetNamespace = "valkey-operator-system";
              createNamespace = true;
              values = {
                image = {
                  repository = operatorImage.imageName;
                  tag = operatorImage.imageTag;
                };
                resources = config.server.resources.profiles.infraLarge;
              };
            };
          };
        };
      };
    };
}
