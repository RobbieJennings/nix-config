{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      nixpkgs = {
        config.allowUnfree = true;
        overlays = [ self.overlays.unstable-packages ];
      };

      nix.settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      home-manager.sharedModules = [ self.modules.homeManager.settings ];
      users.mutableUsers = false;
      system.stateVersion = "26.05";
    };

  flake.modules.homeManager.settings = {
    nixpkgs = {
      config.allowUnfree = true;
      overlays = [ self.overlays.unstable-packages ];
    };

    home.stateVersion = "26.05";
  };
}
