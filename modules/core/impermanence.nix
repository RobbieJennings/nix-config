{
  inputs,
  ...
}:
{
  flake.modules.nixos.impermanence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        impermanence.enable = lib.mkEnableOption "impermanence";
      };

      config = lib.mkIf config.impermanence.enable {
        fileSystems."/persist".neededForBoot = true;
        boot.initrd.systemd.services.rollback = {
          description = "Rollback BTRFS root subvolume to a pristine state";
          wantedBy = [ "initrd.target" ];
          after = [ "initrd-root-device.target" ];
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            set -e
            mkdir -p /mnt
            mount ${config.fileSystems."/".device} /mnt

            if [[ -e /mnt/root ]]; then
              btrfs subvolume delete -R /mnt/root
            fi

            btrfs subvolume create /mnt/root
            umount /mnt
          '';
        };
      };
    };
}
