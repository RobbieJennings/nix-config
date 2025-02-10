{ config, lib, pkgs, inputs, ... }:

{
  options = {
    bootloader.enable = lib.mkEnableOption "enables grub bootloader";
    bootloader.pretty = lib.mkEnableOption "enables silent boot with breeze theme";
  };

  config = (lib.mkMerge [
    (lib.mkIf config.bootloader.enable {
      # Enable grub bootloader
      boot.loader.grub.enable = lib.mkDefault true;
      boot.loader.grub.efiSupport = lib.mkDefault true;
      boot.loader.grub.efiInstallAsRemovable = lib.mkDefault true;
    })

    (lib.mkIf config.bootloader.pretty {
      # Enable breeze grub theme
      boot.loader.grub.theme = "${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze";
      boot.loader.grub.splashImage = null;

      # Enable plymouth boot animation
      boot.initrd.systemd.enable = true;
      boot.plymouth.enable = true;
      boot.plymouth.theme = "breeze";

      # Enable "Silent Boot"
      boot.initrd.verbose = false;
      boot.kernelParams = [ "quiet" ];

      # Hide the OS choice for bootloaders.
      # It's still possible to open the bootloader list by pressing any key
      # It will just not appear on screen unless a key is pressed
      boot.loader.grub.timeoutStyle = "hidden";
      boot.loader.timeout = 5;
    })
  ]);
}
