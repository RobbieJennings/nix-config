{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./disk-configuration.nix
  ];
}
