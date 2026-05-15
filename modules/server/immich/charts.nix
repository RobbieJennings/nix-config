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
        version = "0.12.0";
        hash = "sha256-ci+4BJs5VBLy8hVaYD2Ear2hD5Y9WgYYUUFhoYDaEUg=";
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
