{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.xps15 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.xps15
      inputs.self.modules.nixos.core
      inputs.self.modules.nixos.desktop
      {
        desktopEnvironment = "cosmic";
        impermanence.enable = true;
        secrets = {
          enable = true;
          passwords.enable = true;
          authorizedKeys.enable = true;
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
            restic.enable = true;
            vuescan.enable = true;
          };
        };
      }
    ];
  };
}
