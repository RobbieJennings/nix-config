{ config, lib, ... }:

{
  config = lib.mkIf config.impermanence.enable {
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
        "/var/lib/libvirt"
        "/etc/nixos"
        "/root/.ssh"
      ];
    };
  };
}
