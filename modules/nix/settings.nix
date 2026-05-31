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
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.impermanence.nixosModules.impermanence
        inputs.sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
        inputs.stylix.nixosModules.stylix
      ];

      nix.settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      nixpkgs = {
        config.allowUnfree = true;
        overlays = [
          self.overlays.unstable-packages
          self.overlays.additional-packages
        ];
      };

      home-manager = {
        sharedModules = [
          {
            imports = [
              inputs.sops-nix.homeManagerModules.sops
              inputs.stylix.homeModules.stylix
            ];
            home.stateVersion = "26.05";
            nixpkgs = {
              config.allowUnfree = true;
              overlays = [
                self.overlays.unstable-packages
                self.overlays.additional-packages
              ];
            };
          }
        ];
      };

      stylix.homeManagerIntegration.autoImport = false;
      users.mutableUsers = false;
      system.stateVersion = "26.05";
    };
}
