{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.metallb-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.metallb = {
        addresses = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "192.168.1.200-192.168.1.210" ];
          description = "List of IP addresses for MetalLB's IP address pool.";
        };
      };

      config = lib.mkIf config.metallb.enable {
        services.k3s.autoDeployCharts.metallb = {
          values = {
            controller.image = {
              repository = config._module.args.metallbImages.controllerImage.imageName;
              tag = config._module.args.metallbImages.controllerImage.imageTag;
            };
            speaker.image = {
              repository = config._module.args.metallbImages.speakerImage.imageName;
              tag = config._module.args.metallbImages.speakerImage.imageTag;
            };
          };
          extraDeploy = [
            {
              apiVersion = "metallb.io/v1beta1";
              kind = "IPAddressPool";
              metadata = {
                name = "default";
                namespace = "metallb-system";
              };
              spec = {
                addresses = config.metallb.addresses;
                autoAssign = true;
              };
            }
            {
              apiVersion = "metallb.io/v1beta1";
              kind = "L2Advertisement";
              metadata = {
                name = "default";
                namespace = "metallb-system";
              };
              spec = {
                ipAddressPools = [ "default" ];
              };
            }
          ];
        };
      };
    };
}
