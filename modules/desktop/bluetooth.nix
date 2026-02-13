{
  inputs,
  ...
}:
{
  flake.modules.nixos.bluetooth =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        bluetooth.enable = lib.mkEnableOption "bluetooth";
      };

      config = lib.mkIf config.bluetooth.enable {
        hardware.bluetooth.enable = true;
        hardware.bluetooth.powerOnBoot = lib.mkDefault true;
      };
    };
}
