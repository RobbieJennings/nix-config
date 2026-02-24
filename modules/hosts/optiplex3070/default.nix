{
  inputs,
  ...
}:
{
  flake.modules.nixos.optiplex3070 = {
    imports = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.self.modules.nixos.optiplex3070-hardware
      inputs.self.modules.nixos.optiplex3070-disk
    ];
  };
}
