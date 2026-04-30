{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.cert-manager-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.cert-manager.enable {
        services.k3s.autoDeployCharts.cert-manager.values = {
          installCRDs = true;
          resources = {
            requests.cpu = "20m";
            requests.memory = "64Mi";
            limits.cpu = "200m";
            limits.memory = "128Mi";
          };
          webhook = {
            image = {
              repository =
                (lib.lists.findFirst (x: x.imageName == "quay.io/jetstack/cert-manager-webhook") null config.services.k3s.images)
                .imageName;
              tag =
                (lib.lists.findFirst (x: x.imageName == "quay.io/jetstack/cert-manager-webhook") null config.services.k3s.images).imageTag;
            };
            resources = {
              requests.cpu = "20m";
              requests.memory = "64Mi";
              limits.cpu = "200m";
              limits.memory = "128Mi";
            };
          };
          cainjector = {
            image = {
              repository =
                (lib.lists.findFirst (x: x.imageName == "quay.io/jetstack/cert-manager-cainjector") null config.services.k3s.images)
                .imageName;
              tag =
                (lib.lists.findFirst (x: x.imageName == "quay.io/jetstack/cert-manager-cainjector") null config.services.k3s.images).imageTag;
            };
            resources = {
              requests.cpu = "10m";
              requests.memory = "32Mi";
              limits.cpu = "100m";
              limits.memory = "64Mi";
            };
          };
        };
      };
    };
}
