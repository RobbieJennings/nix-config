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
        imageDigest = "sha256:51aeb9d829239345070619dad3edd6873186f913c84f45b365b74574fcb38ec0";
        hash = "sha256-DaADXmvO8zNm/nnP2bpbm+F/e5M0o+xcw+p4mCs+ctY=";
        finalImageTag = "v1.16.1";
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
