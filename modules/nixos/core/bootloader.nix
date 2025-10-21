{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    bootloader.enable = lib.mkEnableOption "systemd-boot bootloader";
    bootloader.pretty = lib.mkEnableOption "silent boot with plymouth";
  };

  config = lib.mkMerge [
    (lib.mkIf config.bootloader.enable {
      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    })

    (lib.mkIf (config.bootloader.enable && config.bootloader.pretty) {
      boot = {
        loader.timeout = lib.mkDefault 0;
        initrd = {
          systemd.enable = true;
          verbose = false;
        };
        plymouth.enable = true;
        kernelParams = [ "quiet" ];
      };
    })
  ];
}
