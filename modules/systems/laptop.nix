{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules = lib.mkMerge [
    (self.factory.desktop-user {
      moduleName = "robbie-laptop";
      username = "robbie";
      isAdmin = true;
    })
    {
      nixos.robbie-laptop = {
        home-manager.users.robbie = {
          programs.git = {
            enable = true;
            settings.user = {
              name = "robbiejennings";
              email = "robbie.jennings97@gmail.com";
            };
          };
          theme = {
            image = {
              url = "https://raw.githubusercontent.com/AngelJumbo/gruvbox-wallpapers/refs/heads/main/wallpapers/photography/forest-2.jpg";
              hash = "sha256-RqzCCnn4b5kU7EYgaPF19Gr9I5cZrkEdsTu+wGaaMFI=";
            };
            base16Scheme = "gruvbox-material-dark-hard";
          };
          secrets = {
            enable = true;
            vuescan.enable = true;
            rclone.enable = true;
            restic.enable = true;
          };
        };
      };
    }
  ];

  flake.nixosConfigurations.xps15 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.settings
      inputs.self.modules.nixos.xps15
      inputs.self.modules.nixos.core
      inputs.self.modules.nixos.desktop
      inputs.self.modules.nixos.server
      inputs.self.modules.nixos.robbie-laptop
      {
        networking.hostName = "xps15";
        secrets = {
          enable = true;
          passwords.enable = true;
          k3s.enable = true;
          gitea.enable = true;
          nextcloud.enable = true;
          media-server.enable = true;
        };
        impermanence.enable = true;
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
            "/media-server"
          ];
        };
      }
    ];
  };
}
