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
        if [[ -e /mnt/root ]]; then
          mkdir -p /mnt/old_roots
          timestamp=$(date --date="@$(stat -c %Y /mnt/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /mnt/root "/mnt/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/mnt/$i"
          done
          btrfs subvolume delete "$1"
        }

        for i in $(find /mnt/old_roots/ -maxdepth 1); do
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
