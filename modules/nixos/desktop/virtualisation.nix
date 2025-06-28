{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    desktop.virtualisation.enable = lib.mkEnableOption "virtualisation using libvirt & qemu";
  };

  config = lib.mkIf config.desktop.virtualisation.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
}
