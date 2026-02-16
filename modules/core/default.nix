{
  inputs,
  ...
}:
{
  flake.modules.nixos.core =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.auto-upgrade
        inputs.self.modules.nixos.garbage-collection
        inputs.self.modules.nixos.fwupd
        inputs.self.modules.nixos.bootloader
        inputs.self.modules.nixos.networking
        inputs.self.modules.nixos.docker
        inputs.self.modules.nixos.localisation
        inputs.self.modules.nixos.zsh
        inputs.self.modules.nixos.theme
        inputs.self.modules.nixos.impermanence
        inputs.self.modules.nixos.secrets
      ];

      config = {
        auto-upgrade.enable = lib.mkDefault true;
        garbage-collection.enable = lib.mkDefault true;
        fwupd.enable = lib.mkDefault true;
        bootloader.enable = lib.mkDefault true;
        networking.enable = lib.mkDefault true;
        docker.enable = lib.mkDefault true;
        localisation.enable = lib.mkDefault true;
        zsh.enable = lib.mkDefault true;
        theme.enable = lib.mkDefault true;

        environment.systemPackages = [
          config.theme.fonts.interface.package
          config.theme.fonts.monospace.package
          config.theme.fonts.emoji.package
          pkgs.git
          pkgs.vim
          pkgs.wget
          pkgs.just
        ];

        home-manager.sharedModules = [
          {
            imports = [
              inputs.self.modules.homeManager.theme
              inputs.self.modules.homeManager.secrets
            ];

            home.packages = [
              config.theme.fonts.interface.package
              config.theme.fonts.monospace.package
              config.theme.fonts.emoji.package
            ];

            theme.enable = lib.mkDefault true;
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
