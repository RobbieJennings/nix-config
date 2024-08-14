{ config, lib, pkgs, pkgs-unstable, ... }:

{
   imports =
    [
      ./configuration.nix
      ./hardware-configuration.nix
      ./disk-configuration.nix
    ];
}
