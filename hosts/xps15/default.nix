{ config, lib, pkgs, ... }:

{
   imports =
    [
      ./configuration.nix
      ./hardware-configuration.nix
      ./disk-configuration.nix
    ];
}
