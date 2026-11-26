{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.nixosConfigurations.optiplex3070 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.optiplex3070
      inputs.self.modules.nixos.core
      inputs.self.modules.nixos.server
      {
        impermanence.enable = true;
        secrets = {
          enable = true;
          passwords.enable = true;
          authorizedKeys.enable = true;
          k3s.enable = true;
          homepage.enable = true;
          longhorn.enable = true;
          garage.enable = true;
          grafana.enable = true;
          prometheus.enable = true;
          loki.enable = true;
          forgejo.enable = true;
          nextcloud.enable = true;
          immich.enable = true;
          freshrss.enable = true;
          media-server.enable = true;
          netbird-operator.enable = true;
        };
      }
      {
        imports = [
          (self.factory.server-user {
            username = "robbie";
            isAdmin = true;
          })
        ];
        home-manager.users.robbie = {
          programs.git = {
            enable = true;
            settings.user = {
              name = "robbiejennings";
              email = "robbie.jennings97@gmail.com";
            };
          };
        };
      }
    ];
  };
}
