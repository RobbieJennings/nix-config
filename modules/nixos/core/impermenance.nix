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
        mkdir /mnt
        mount /dev/mapper/crypted /mnt

        if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /mnt/root
        umount /mnt
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
