{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    bootloader.enable = lib.mkEnableOption "grub bootloader";
    bootloader.pretty = lib.mkEnableOption "silent boot with breeze theme";
  };

  config = lib.mkMerge [
    (lib.mkIf config.bootloader.enable {
      boot.loader.grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    })

    (lib.mkIf (config.bootloader.enable && config.bootloader.pretty) {
      boot = {
        loader = {
          grub = {
            theme = lib.mkDefault "${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze";
            splashImage = null;
            timeoutStyle = "hidden";
          };
          timeout = lib.mkDefault 5;
        };

        initrd = {
          systemd.enable = true;
          verbose = false;
        };

        plymouth = {
          enable = true;
          theme = lib.mkDefault "breeze";
        };

        kernelParams = [ "quiet" ];
      };
    })
  ];
}
