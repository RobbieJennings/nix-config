{ config, pkgs, ... }:

{
  config = {
    environment.systemPackages = [
      pkgs.git
      pkgs.vim
      pkgs.wget
      pkgs.just
    ];

    desktop.enable = true;
    bootloader.pretty = true;
    theme.enable = true;
    hardware.keyboard.qmk.enable = true;
  };
}
