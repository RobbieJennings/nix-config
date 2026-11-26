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
      { impermanence.enable = true; }
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
