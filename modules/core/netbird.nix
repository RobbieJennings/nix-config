{
  inputs,
  ...
}:
{
  flake.modules.nixos.netbird =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        netbird.enable = lib.mkEnableOption "netbird client daemon";
      };

      config = lib.mkIf config.netbird.enable {
        services.resolved.enable = true;
        services.netbird.enable = true;
      };
    };
}
