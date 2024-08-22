{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./browsers.nix
  ];

  config = {
    firefox.enable = lib.mkDefault true;
    chrome.enable = lib.mkDefault true;
    brave.enable = lib.mkDefault true;
  };
}
