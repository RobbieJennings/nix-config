{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules = lib.mkMerge [
    (self.factory.server-user {
      moduleName = "robbie-server";
      username = "robbie";
      isAdmin = true;
    })
    {
      nixos.robbie-server = {
        home-manager.users.robbie = {
          programs.git = {
            enable = true;
            settings.user = {
              name = "robbiejennings";
              email = "robbie.jennings97@gmail.com";
            };
          };
        };
      };
    }
  ];

  flake.nixosConfigurations.optiplex3070 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.settings
      inputs.self.modules.nixos.optiplex3070
      inputs.self.modules.nixos.core
      inputs.self.modules.nixos.server
      inputs.self.modules.nixos.robbie-server
      {
        networking.hostName = "optiplex3070";
        secrets = {
          enable = true;
          passwords.enable = true;
          k3s.enable = true;
          grafana.enable = true;
          gitea.enable = true;
          nextcloud.enable = true;
          media-server.enable = true;
          tailscale-operator.enable = true;
        };
        impermanence.enable = true;
        environment.persistence."/persist" = {
          hideMounts = true;
          directories = [
            "/var/log"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
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
