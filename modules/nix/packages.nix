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
    vuescan = final.callPackage ../../packages/vuescan.nix { };
    epson-v550-plugin = final.callPackage ../../packages/epson-v550-plugin.nix { };
    cosmic-ext-applet-clipboard-manager =
      final.callPackage ../../packages/cosmic-ext-applet-clipboard-manager.nix
        { };
  };

  perSystem =
    {
      self',
      system,
      pkgs,
      ...
    }:
    {
      packages = {
        nixos-options-doc =
          let
            eval = inputs.nixpkgs.lib.evalModules {
              modules = [
                { _module.check = false; }
                inputs.self.modules.nixos.core
                inputs.self.modules.nixos.desktop
                inputs.self.modules.nixos.server
              ];
            };
            cleanEval = inputs.nixpkgs.lib.filterAttrsRecursive (n: v: n != "_module") eval;
            optionsDoc = pkgs.nixosOptionsDoc { inherit (cleanEval) options; };
          in
          pkgs.runCommand "OPTIONS.md" { } ''
            cp ${optionsDoc.optionsCommonMark} $out
          '';

        home-manager-options-doc =
          let
            eval = inputs.nixpkgs.lib.evalModules {
              modules = [
                { _module.check = false; }
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
              ];
            };
            cleanEval = inputs.nixpkgs.lib.filterAttrsRecursive (n: v: n != "_module") eval;
            optionsDoc = pkgs.nixosOptionsDoc { inherit (cleanEval) options; };
          in
          pkgs.runCommand "OPTIONS.md" { } ''
            cp ${optionsDoc.optionsCommonMark} $out
          '';
      };
    };
}
