{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./bootloader.nix
    ./impermenance.nix
    ./desktop-environment.nix
    ./networking.nix
    ./localization.nix
    ./audio.nix
  ];

  config = {
    bootloader.enable = lib.mkDefault true;
    impermenance.enable = lib.mkDefault true;
    desktop-environment.enable = lib.mkDefault true;
    networking.enable = lib.mkDefault true;
    localization.enable = lib.mkDefault true;
    audio.enable = lib.mkDefault true;
  };
}
