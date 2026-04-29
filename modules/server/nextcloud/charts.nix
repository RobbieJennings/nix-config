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
        version = "8.7.0";
        hash = "sha256-LoEz0+iETV9kBxiRB7aML4Jzk4LhmrUQMHBQipYnWzE=";
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
