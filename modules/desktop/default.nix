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
      ];

      config = {
        services.flatpak.enable = true;
        hardware.keyboard.qmk.enable = true;

        home-manager.sharedModules = [
          {
            imports = [
              inputs.nix-flatpak.homeManagerModules.nix-flatpak
              inputs.plasma-manager.homeModules.plasma-manager
              inputs.cosmic-manager.homeManagerModules.cosmic-manager
            ];
          }
        ];

        bootloader.pretty = true;
        audio.enable = lib.mkDefault true;
        bluetooth.enable = lib.mkDefault true;
        cosmic-desktop.enable = lib.mkDefault true;
        kde-connect.enable = lib.mkDefault true;
        printing.enable = lib.mkDefault true;
        scanning.enable = lib.mkDefault true;
        steam.enable = lib.mkDefault true;
        virtualisation.enable = lib.mkDefault true;
      };
    };
}
