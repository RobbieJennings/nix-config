{
  inputs,
  ...
}:
{
  flake.modules.nixos.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.audio
        inputs.self.modules.nixos.bluetooth
        inputs.self.modules.nixos.cosmic-desktop
        inputs.self.modules.nixos.kde-plasma
        inputs.self.modules.nixos.kde-connect
        inputs.self.modules.nixos.printing
        inputs.self.modules.nixos.scanning
        inputs.self.modules.nixos.steam
        inputs.self.modules.nixos.virtualisation
        inputs.self.modules.nixos.qmk
      ];

      options = {
        desktopEnvironment = lib.mkOption {
          type = lib.types.enum [
            "plasma"
            "cosmic"
          ];
          default = "plasma";
          description = "Select desktop environment: Plasma or COSMIC.";
        };
      };

      config = {
        services.flatpak.enable = true;
        bootloader.pretty = lib.mkDefault true;
        audio.enable = lib.mkDefault true;
        bluetooth.enable = lib.mkDefault true;
        cosmic-desktop.enable = if config.desktopEnvironment == "cosmic" then true else false;
        kde-plasma.enable = if config.desktopEnvironment == "plasma" then true else false;
        kde-connect.enable = lib.mkDefault true;
        printing.enable = lib.mkDefault true;
        scanning.enable = lib.mkDefault true;
        steam.enable = lib.mkDefault true;
        virtualisation.enable = lib.mkDefault true;
        qmk.enable = lib.mkDefault true;

        home-manager.sharedModules = [
          {
            imports = [
              inputs.nix-flatpak.homeManagerModules.nix-flatpak
              inputs.plasma-manager.homeModules.plasma-manager
              inputs.cosmic-manager.homeManagerModules.cosmic-manager
            ];
          }
        ];

        assertions = [
          {
            assertion = !(config.cosmic-desktop.enable && config.kde-plasma.enable);
            message = "Cannot enable both COSMIC and Plasma at the same time.";
          }
        ];
      };
    };
}
