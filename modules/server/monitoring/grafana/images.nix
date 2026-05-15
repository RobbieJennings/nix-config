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
        imageDigest = "sha256:2d1f9ae67c1778d33e291d4c3c759cd8b650e67491f02533499eb950e075eeb5";
        hash = "sha256-XgfGrtHg4HbftWoLXODRLJKyhyCWJUvO/O95kXW6oqk=";
        finalImageTag = "13.0.1-security-01";
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
