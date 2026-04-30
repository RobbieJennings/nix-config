{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.alloy-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      alloyImage = pkgs.dockerTools.pullImage {
        imageName = "grafana/alloy";
        imageDigest = "sha256:f50931848bd8178774521767bb46b905e1a081301950ff28d7623c9db7c01076";
        sha256 = "sha256-8xbnqldN9qEe3tXmfsy43k5j2gqYROYOqHWivGNjFaw=";
        finalImageTag = "v1.14.0";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.monitoring.alloy.enable {
        services.k3s = {
          images = [ alloyImage ];
          autoDeployCharts.alloy.values = {
            image = {
              repository = alloyImage.imageName;
              tag = alloyImage.imageTag;
            };
          };
        };
      };
    };
}
