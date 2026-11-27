{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.cert-manager-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      certManagerChart = {
        name = "cert-manager";
        repo = "oci://quay.io/jetstack/charts/cert-manager";
        version = "v1.21.2";
        hash = "sha256-c6VuFyjt1smfHzEIJhjDJZ0nmna369PUvcVHXCRC00o=";
      };
    in
    {
      config = lib.mkIf config.cert-manager.enable {
        services.k3s.autoDeployCharts = {
          cert-manager = certManagerChart // {
            targetNamespace = "cert-manager";
            createNamespace = true;
          };
        };
      };
    };
}
