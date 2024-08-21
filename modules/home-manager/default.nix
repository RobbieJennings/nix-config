{ config, lib, pkgs, inputs, outputs, ... }:

{
  imports = [
    ./browsers.nix
  ];

  config = {
    browsers.enable = lib.mkDefault true;
  };
}
