{
  inputs,
  ...
}:
{
  flake.overlays.unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = final.config.allowUnfree;
    };
  };

  flake.overlays.additional-packages = final: prev: {
    vuescan = final.callPackage ../../packages/vuescan.nix { src = inputs.vuescan-source; };
    cosmic-ext-applet-clipboard-manager =
      final.callPackage ../../packages/cosmic-ext-applet-clipboard-manager.nix
        { };
  };

  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      optionsDoc =
        modules:
        let
          eval = inputs.nixpkgs.lib.evalModules {
            modules = [
              {
                _module.check = false;
                _module.args.pkgs = pkgs;
              }
            ]
            ++ modules;
          };
        in
        pkgs.nixosOptionsDoc {
          options = builtins.removeAttrs eval.options [ "_module" ];
        };
    in
    {
      packages = {
        nixos-options-doc = pkgs.runCommand "OPTIONS.md" { } ''
          cp ${
            (optionsDoc [
              inputs.self.modules.nixos.core
              inputs.self.modules.nixos.desktop
              inputs.self.modules.nixos.server
            ]).optionsCommonMark
          } $out
        '';

        home-manager-options-doc = pkgs.runCommand "OPTIONS.md" { } ''
          cp ${
            (optionsDoc [
              inputs.self.modules.homeManager.secrets
              inputs.self.modules.homeManager.theme
              inputs.self.modules.homeManager.backup
              inputs.self.modules.homeManager.cosmic-manager
              inputs.self.modules.homeManager.development
              inputs.self.modules.homeManager.editing
              inputs.self.modules.homeManager.gaming
              inputs.self.modules.homeManager.plasma-manager
              inputs.self.modules.homeManager.utilities
              inputs.self.modules.homeManager.web
            ]).optionsCommonMark
          } $out
        '';
      };
    };
}
