{
  inputs,
  ...
}:
{
  flake.modules.nixos.intel-device-plugins-operator =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "intel-device-plugins-operator";
        repo = "https://intel.github.io/helm-charts";
        version = "0.35.0";
        hash = "sha256-8tq57lrdlLFYw5y6SwiGtcsbIhG72UGJ1i/S4X5imeU=";
      };
      image = pkgs.dockerTools.pullImage {
        imageName = "intel/intel-deviceplugin-operator";
        imageDigest = "sha256:d7eeac081bd17e58d8d4d542f3cb33d67cc1bdab314b09ad591e8eacb51dd5ec";
        sha256 = "sha256-EB6MNtzNF2KAX5Ub6do2bz1/8Vv+lddclXPmZy85TCA=";
        finalImageTag = "0.35.0";
        arch = "amd64";
      };
    in
    {
      options = {
        intel-device-plugins.operator.enable = lib.mkEnableOption "Intel Device Plugins Operator";
      };

      config = lib.mkIf config.intel-device-plugins.operator.enable {
        services.k3s = {
          images = [ image ];
          autoDeployCharts.intel-device-plugins-operator = chart // {
            targetNamespace = "intel-device-plugins-operator";
            createNamespace = true;
            values = {
              manager = {
                image = {
                  hub = "intel";
                  tag = image.imageTag;
                };
              };
              resources = {
                requests = {
                  cpu = "20m";
                  memory = "64Mi";
                };
                limits = {
                  cpu = "200m";
                  memory = "128Mi";
                };
              };
            };
          };
        };
      };
    };
}

