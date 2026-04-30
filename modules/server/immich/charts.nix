{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.immich-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      immichChart = {
        name = "immich";
        repo = "https://immich-app.github.io/immich-charts";
        version = "0.11.1";
        hash = "sha256-TiMy4nPuNnF2tb3Y+wwXofYEYqigWswuSo6po6LmnXY=";
      };
    in
    {
      config = lib.mkIf config.immich.enable {
        services.k3s.autoDeployCharts = {
          immich = immichChart // {
            targetNamespace = "immich";
            createNamespace = true;
          };
        };
      };
    };
}
