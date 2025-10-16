{ inputs, ... }:

{ config, pkgs, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.dell-xps-15-7590-nvidia
    ./hardware-configuration.nix
    ./disk-configuration.nix
  ];

  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages = [
      pkgs.intel-media-sdk
    ];
  };
  virtualisation.kvmgt = {
    enable = true;
    vgpus = {
      "i915-GVTg_V5_4" = {
        uuid = [ "d4640c7e-aaae-11f0-9ac1-af1cd8c1d661" ];
      };
    };
  };
}
