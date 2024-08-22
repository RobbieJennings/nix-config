{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./browsers.nix
  ];

  config = {
    browsers.enable = lib.mkDefault true;
  };
}
