{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./garbage-collection.nix
    ./auto-upgrade.nix
    ./zsh.nix
    ./bootloader.nix
    ./networking.nix
    ./localisation.nix
    ./desktop-environment.nix
    ./audio.nix
    ./virtualisation.nix
    ./impermanence.nix
    ./secrets.nix
    ./steam.nix
  ];

  config = {
    garbage-collection.enable = lib.mkDefault true;
    auto-upgrade.enable = lib.mkDefault true;
    zsh.enable = true;
    bootloader.enable = lib.mkDefault true;
    networking.enable = lib.mkDefault true;
    localisation.enable = lib.mkDefault true;
    desktop-environment.enable = lib.mkDefault true;
    audio.enable = lib.mkDefault true;
    virtualisation.enable = lib.mkDefault true;
    impermanence.enable = lib.mkDefault true;
  };
}
