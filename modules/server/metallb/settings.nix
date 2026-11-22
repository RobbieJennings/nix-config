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
                addresses = [ "192.168.1.200-192.168.1.210" ];
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
