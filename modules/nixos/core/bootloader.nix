{ config, lib, pkgs, inputs, ... }:

{
  options = {
    bootloader.enable = lib.mkEnableOption "enables grub bootloader";
    bootloader.pretty =
      lib.mkEnableOption "enables silent boot with breeze theme";
  };

  config = lib.mkIf config.bootloader.enable {
    boot = if config.bootloader.pretty then {
      # Enable grub bootloader
      loader.grub.enable = lib.mkDefault true;
      loader.grub.efiSupport = lib.mkDefault true;
      loader.grub.efiInstallAsRemovable = lib.mkDefault true;

      # Enable breeze grub theme
      loader.grub.theme = "${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze";
      loader.grub.splashImage = null;

      # Enable plymouth boot animation
      initrd.systemd.enable = true;
      plymouth.enable = true;
      plymouth.theme = "breeze";

      # Enable "Silent Boot"
      initrd.verbose = false;
      kernelParams = [ "quiet" ];

      # Hide the OS choice for bootloaders.
      # It's still possible to open the bootloader list by pressing any key
      # It will just not appear on screen unless a key is pressed
      loader.grub.timeoutStyle = "hidden";
      loader.timeout = 5;
    } else {
      # Enable grub bootloader
      loader.grub.enable = lib.mkDefault true;
      loader.grub.efiSupport = lib.mkDefault true;
      loader.grub.efiInstallAsRemovable = lib.mkDefault true;
    };
  };
}
