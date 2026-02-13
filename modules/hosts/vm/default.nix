{
  inputs,
  ...
}:
{
  flake.modules.nixos.vm = {
    imports = [
      inputs.self.modules.nixos.vm-hardware
      inputs.self.modules.nixos.vm-disk
    ];
  };
}
