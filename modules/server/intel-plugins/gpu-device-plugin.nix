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
        version = "0.35.0";
        hash = "sha256-qcBxtTyDjjGpkCfxHY5UslEw+vAzTQg8kO0Xyo5MAy4=";
      };
      image = pkgs.dockerTools.pullImage {
        imageName = "intel/intel-gpu-plugin";
        imageDigest = "sha256:34697f9c286857da986381595ac2a693524a83c831955247dae47dfda4d2f526";
        sha256 = "sha256-MuhK5OySez4wMCBOG10JxIk/bZuD0vM7K1kWDoIVmDg=";
        finalImageTag = "0.35.0";
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
