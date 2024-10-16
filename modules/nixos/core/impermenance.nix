{ config, lib, pkgs, inputs, ... }:

{
  options = {
    impermenance.enable = lib.mkEnableOption "enables impermenance";
  };

  config = lib.mkIf config.impermenance.enable {
    boot.initrd.systemd.services.rollback = {
      description = "Rollback BTRFS root subvolume to a pristine state";
      wantedBy = ["initrd.target"];
      after = ["systemd-cryptsetup@crypted.service"];
      before = ["sysroot.mount"];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir /mnt
        mount /dev/mapper/crypted /mnt

        delete_subvolume_recursively() {
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/mnt/$i"
          done
          btrfs subvolume delete "$1"
        }

        if [[ -e /mnt/root ]]; then
          delete_subvolume_recursively "/mnt/root"
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
        "/etc/nixos"
      ];
    };
  };
}
