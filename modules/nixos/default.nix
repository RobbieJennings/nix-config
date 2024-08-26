{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./core
    ./virtualisation
    ./media-server
  ];
}
