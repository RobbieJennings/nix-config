{
  inputs,
  ...
}:
{
  flake.modules.nixos.xps15 = {
    imports = [
      inputs.nixos-hardware.nixosModules.dell-xps-15-7590-nvidia
      inputs.self.modules.nixos.xps15-hardware
      inputs.self.modules.nixos.xps15-disk
    ];

    networking.hostName = "xps15";
    services.power-profiles-daemon.enable = false;
    services.tlp.enable = true;
  };
}
