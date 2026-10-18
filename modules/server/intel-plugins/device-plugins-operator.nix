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
        version = "0.37.1";
        hash = "sha256-q87Ax/Nd2IdZ2BvLdk1AyKMDlmdLPT7nVAoCY+VTAXw=";
      };
      image = pkgs.dockerTools.pullImage {
        imageName = "intel/intel-deviceplugin-operator";
        imageDigest = "sha256:1e60686c2170c8316cc0fdc3f0f2058384d4a94064d2f8508eac605a013e05d9";
        hash = "sha256-On+4jvcvYoepFwLxTk8bSDN+HG4OO9hm4LWhiG8Qv6Q=";
        finalImageTag = "0.37.1";
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
