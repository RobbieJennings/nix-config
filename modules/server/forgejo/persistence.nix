{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.forgejo-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.forgejo.enable {
        services.k3s.autoDeployCharts.forgejo.values.persistence = {
          enabled = true;
          size = "25Gi";
        };
      };
    };
}
