{ lib, pkgs, ... }:

{
  programs.git.enable = true;
  theme.enable = lib.mkDefault true;
  cosmic-manager.enable = lib.mkDefault true;
  plasma-manager.enable = lib.mkDefault true;
  utilities.enable = lib.mkDefault true;
  web.enable = lib.mkDefault true;
  gaming.enable = lib.mkDefault true;
  editing.enable = lib.mkDefault true;
  development.enable = lib.mkDefault true;
  backup.enable = lib.mkDefault true;
}
