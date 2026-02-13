{
  inputs,
  ...
}:
{
  flake.modules.nixos.virtualisation =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        virtualisation.enable = lib.mkEnableOption "virtualisation using libvirt & qemu";
      };

      config = lib.mkIf config.virtualisation.enable {
        virtualisation.libvirtd.enable = true;
        programs.virt-manager.enable = true;
      };
    };
}
