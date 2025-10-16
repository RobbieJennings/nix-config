{ lib, pkgs, ... }:

{
  imports = [ ./secrets.nix ];
  programs.git.enable = true;
}
