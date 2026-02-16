{
  inputs,
  ...
}:
{
  flake.modules.nixos.fwupd =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        fwupd.enable = lib.mkEnableOption "firmware update manager";
      };

      config = lib.mkIf config.fwupd.enable {
        services.fwupd.enable = true;
      };
    };
}
