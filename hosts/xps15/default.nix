{
  mkHost = hostname: { inputs, ... }: {
    imports = [
      inputs.disko.nixosModules.disko
      inputs.nixos-hardware.nixosModules.dell-xps-15-7590-nvidia
      ./hardware-configuration.nix
      ./disk-configuration.nix
    ];

    networking.hostName = hostname;
    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    networking.firewall = rec {
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };
}
