{ config, lib, pkgs, inputs, outputs, ... }:

{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./disk-configuration.nix
  ];
}
