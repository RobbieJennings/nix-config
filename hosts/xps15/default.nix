{
  hostname,
  inputs,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.dell-xps-15-7590-nvidia
    ./hardware-configuration.nix
    ./disk-configuration.nix
  ];

  networking.hostName = hostname;
}
