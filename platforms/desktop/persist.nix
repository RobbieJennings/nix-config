{ config, lib, pkgs, inputs, nixosModules, ... }:

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
        "/etc/NetworkManager/system-connections"
        "/etc/nixos"
        "/root/.ssh"
      ];
    };
  };
}
