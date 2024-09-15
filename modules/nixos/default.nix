{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./core
    ./virtualisation
    ./media-server
  ];
}
