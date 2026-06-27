{
  inputs,
  ...
}:
{
  flake.modules.nixos.intel-gpu-plugin =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "intel-device-plugins-gpu";
        repo = "https://intel.github.io/helm-charts";
        version = "0.36.0";
        hash = "sha256-xh4QWuIeXWzq1gXG0zfw6uTpJFKmSnS5juj2s3M3YWE=";
      };
      image = pkgs.dockerTools.pullImage {
        imageName = "intel/intel-gpu-plugin";
        imageDigest = "sha256:2db679be62b52ac985169084ca711cab6e6c59fe543ab2ddee58163d6f8d29e0";
        hash = "sha256-GiHyT6bEf3wtsZ/BcR5M4WxnfYoGYCb9cnj+UWaNJkc=";
        finalImageTag = "0.36.0";
        arch = "amd64";
      };
    in
    {
      options = {
        intel-device-plugins.gpu.enable = lib.mkEnableOption "Intel GPU plugin for Kubernetes";
      };

      config = lib.mkIf config.intel-device-plugins.gpu.enable {
        services.k3s = {
          images = [ image ];
          autoDeployCharts.intel-gpu-plugin = chart // {
            targetNamespace = "intel-device-plugins-operator";
            createNamespace = true;
            values = {
              image = {
                hub = "intel";
                tag = image.imageTag;
              };
            };
          };
        };
      };
    };
}
