{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.nixosConfigurations.nixos-vm = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.vm
      inputs.self.modules.nixos.core
      inputs.self.modules.nixos.desktop
      {
        networking.hostName = "nixos-vm";
        impermanence.enable = true;
        environment.persistence."/persist" = {
          hideMounts = true;
          directories = [
            "/var/log"
            "/var/lib/bluetooth"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/var/lib/libvirt"
            "/var/lib/netbird"
            "/etc/NetworkManager/system-connections"
            "/etc/nixos"
            "/root/.ssh"
          ];
        };
      }
      {
        imports = [
          (self.factory.desktop-user {
            username = "robbie";
            isAdmin = true;
          })
        ];

        home-manager.users.robbie = {
          programs.git.settings.user = {
            name = "robbiejennings";
            email = "robbie.jennings97@gmail.com";
          };
        };
      }
    ];
  };
}
