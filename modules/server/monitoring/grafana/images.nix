{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.grafana-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      grafanaImage = pkgs.dockerTools.pullImage {
        imageName = "grafana/grafana";
        imageDigest = "sha256:62a54c76afbeea0b8523b7afcd9e7ee1f0e39806035fd90ffc333a19e9358f2f";
        sha256 = "sha256-OhTmnRsqpgJbNxOD4zNUehEaX2l28HNxKJ9Nec2XLfs=";
        finalImageTag = "12.3.3";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.monitoring.grafana.enable {
        services.k3s = {
          images = [ grafanaImage ];
          autoDeployCharts.grafana.values = {
            image = {
              repository = grafanaImage.imageName;
              tag = grafanaImage.imageTag;
            };
          };
        };
      };
    };
}
