{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./core
    ./media-server
  ];
}
