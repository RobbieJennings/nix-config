{
  inputs,
  ...
}:
{
  flake.modules.nixos.qmk =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        qmk.enable = lib.mkEnableOption "QMK keyboard configuration";
      };

      config = lib.mkIf config.qmk.enable {
        hardware.keyboard.qmk.enable = true;
      };
    };
}
