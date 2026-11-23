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
            "/etc/ssh"
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
