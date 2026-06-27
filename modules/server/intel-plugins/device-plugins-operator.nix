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
        version = "0.36.0";
        hash = "sha256-guPqpOlyIGUOvXvS/1bd5JB4ZGiU6Cmzj9Y7iqfigx8=";
      };
      image = pkgs.dockerTools.pullImage {
        imageName = "intel/intel-deviceplugin-operator";
        imageDigest = "sha256:9879685d0b5be18c9063c42d72b7bf3ae42a295467db90e7658b28b953ff382f";
        hash = "sha256-Y7X82hvrpYMd1RkIwsSgmRWf/wqIY9hGSRsZIwXjJs8=";
        finalImageTag = "0.36.0";
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
              resources = config.server.resources.profiles.infraMedium;
            };
          };
        };
      };
    };
}
