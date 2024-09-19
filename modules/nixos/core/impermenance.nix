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

        delete_subvolume_recursively() {
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/mnt/$i"
          done
          btrfs subvolume delete "$1"
        }

        if [[ -e /mnt/previous ]]; then
          for i in $(find /mnt/previous/* -maxdepth 0); do
            delete_subvolume_recursively "$i"
          done
        fi

        if [[ -e /mnt/root ]]; then
          mkdir -p /mnt/previous
          mv /mnt/root /mnt/previous/root
        fi

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
