{ config, lib, ... }:

{
  config = lib.mkIf config.impermanence.enable {
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/libvirt"
        "/var/lib/rancher/k3s"
        "/var/lib/longhorn"
        "/etc/NetworkManager/system-connections"
        "/etc/nixos"
        "/root/.ssh"
      ];
    };
  };
}
