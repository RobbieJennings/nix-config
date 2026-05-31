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
        programs.virt-manager.enable = true;
        virtualisation.libvirtd.enable = true;
        fileSystems."/var/lib/libvirt/secrets" = {
          device = "tmpfs";
          fsType = "tmpfs";
          options = [ "mode=0700" ];
        };
      };
    };
}
