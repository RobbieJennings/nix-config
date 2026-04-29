{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules.nixos.robbie-vm = lib.mkMerge [
    (self.factory.desktop-user {
      username = "robbie";
      isAdmin = true;
    })
    {
      home-manager.users.robbie = {
        programs.git.settings.user = {
          name = "robbiejennings";
          email = "robbie.jennings97@gmail.com";
        };
      };
    }
  ];

  flake.nixosConfigurations.nixos-vm = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.settings
      inputs.self.modules.nixos.vm
      inputs.self.modules.nixos.core
      inputs.self.modules.nixos.desktop
      inputs.self.modules.nixos.robbie-vm
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
    ];
  };
}
