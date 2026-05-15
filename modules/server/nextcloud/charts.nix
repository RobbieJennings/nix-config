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
        version = "9.1.0";
        hash = "sha256-1clI8iPlFwtFjXCofQUpOq6kbe4+5n/P33I16Sf2/rk=";
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
