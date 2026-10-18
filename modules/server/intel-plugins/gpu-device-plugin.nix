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
        version = "0.37.1";
        hash = "sha256-BfKZmPNpfh/PYR4OANx/CVB+xs6tt7oIhG6GjpRuuJw=";
      };
      image = pkgs.dockerTools.pullImage {
        imageName = "intel/intel-gpu-plugin";
        imageDigest = "sha256:004641b2547d58f1eadce58473fa160ad71377de1eb588cf1f82832387bf3e33";
        hash = "sha256-RLeD1oQI3TrolR+j3XeesjrjGmu6m7MdrTGFcti8qw4=";
        finalImageTag = "0.37.1";
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
