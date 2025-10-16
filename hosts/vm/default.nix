{ inputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
    ./disk-configuration.nix
  ];
}
