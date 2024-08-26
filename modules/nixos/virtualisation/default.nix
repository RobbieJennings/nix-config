{ config, lib, pkgs, inputs, ... }:

{
  options = {
    virtualisation.enable = lib.mkEnableOption "enables virtualisation using libvirt & qemu";
  };

  config = lib.mkIf config.virtualisation.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
}
