{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.nextcloud-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      nextcloudChart = {
        name = "nextcloud";
        repo = "https://nextcloud.github.io/helm";
        version = "9.1.4";
        hash = "sha256-AndC4g8P1H2gusv0G6PoEBwmzLuQpgAO01XEfO/d+dE=";
      };
    in
    {
      config = lib.mkIf config.nextcloud.enable {
        services.k3s.autoDeployCharts = {
          nextcloud = nextcloudChart // {
            targetNamespace = "nextcloud";
            createNamespace = true;
          };
        };
      };
    };
}
