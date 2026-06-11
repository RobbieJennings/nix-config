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
            controller.image =
              let
                image = inputs.self.lib.findImageByName "quay.io/metallb/controller" config.services.k3s.images;
              in
              {
                repository = image.imageName;
                tag = image.imageTag;
              };
            speaker.image =
              let
                image = inputs.self.lib.findImageByName "quay.io/metallb/speaker" config.services.k3s.images;
              in
              {
                repository = image.imageName;
                tag = image.imageTag;
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
