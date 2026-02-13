{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules = lib.mkMerge [
    (self.factory.desktop-user {
      moduleName = "robbie-vm";
      username = "robbie";
      isAdmin = true;
    })
    {
      nixos.robbie-vm = {
        home-manager.users.robbie = {
          programs.git.settings.user = {
            name = "robbiejennings";
            email = "robbie.jennings97@gmail.com";
          };
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
      }
    ];
  };
}
