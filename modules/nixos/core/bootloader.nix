{ config, lib, pkgs, inputs, ... }:

{
  options = {
    bootloader.enable = lib.mkEnableOption "enables firefox";
  };

  config = lib.mkIf config.bootloader.enable {
    boot.loader.grub.enable = lib.mkDefault true;
    boot.loader.grub.efiSupport = lib.mkDefault true;
    boot.loader.grub.efiInstallAsRemovable = lib.mkDefault true;

    # Enable plymouth boot animation
    boot.initrd.systemd.enable = true;
    boot.plymouth.enable = true;
    boot.plymouth.theme = "breeze";

    # Enable "Silent Boot"
    boot.consoleLogLevel = 0;
    boot.initrd.verbose = false;
    boot.kernelParams = [ "quiet" ];

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    boot.loader.grub.timeoutStyle = "hidden";
    boot.loader.timeout = 0;
  };
}