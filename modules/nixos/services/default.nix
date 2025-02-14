{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.nixarr.nixosModules.default
    ./media-server.nix
    ./calibre.nix
  ];
}
