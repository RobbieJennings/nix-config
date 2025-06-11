{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./garbage-collection.nix
    ./auto-upgrade.nix
    ./zsh.nix
    ./bootloader.nix
    ./networking.nix
    ./printing.nix
    ./scanning.nix
    ./localisation.nix
    ./impermanence.nix
    ./secrets.nix
  ];

  config = {
    garbage-collection.enable = lib.mkDefault true;
    auto-upgrade.enable = lib.mkDefault true;
    zsh.enable = lib.mkDefault true;
    bootloader.enable = lib.mkDefault true;
    networking.enable = lib.mkDefault true;
    printing.enable = lib.mkDefault true;
    scanning.enable = lib.mkDefault true;
    localisation.enable = lib.mkDefault true;
    impermanence.enable = lib.mkDefault true;
  };
}
