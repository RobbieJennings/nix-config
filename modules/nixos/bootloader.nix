{ config, lib, pkgs, inputs, ... }:

{
  options = {
    bootloader.enable = lib.mkEnableOption "enables firefox";
  };

  config = lib.mkIf config.bootloader.enable {
    boot.loader.grub.enable = lib.mkDefault true;
    boot.loader.grub.efiSupport = lib.mkDefault true;
    boot.loader.grub.efiInstallAsRemovable = lib.mkDefault true;
  };
}
