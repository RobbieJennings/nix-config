{ config, lib, pkgs, inputs, ... }:

{
  options = {
    impermenance.enable = lib.mkEnableOption "enables impermenance";
  };

  config = lib.mkIf config.impermenance.enable {
    boot.initrd.systemd.services.nuke-root = {
      requires = ["dev-mapper-crypted.device"];
      after = ["dev-mapper-crypted.device"];
      wantedBy = ["initrd.target"];
      script = ''
        mkdir /btrfs_tmp
        mount /dev/mapper/crypted /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
          btrfs subvolume delete /btrfs_tmp/root
        fi
        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';
    };

    fileSystems."/persist".neededForBoot = true;
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
      ];
    };
  };
}
