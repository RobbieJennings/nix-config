{
  inputs,
  self,
  ...
}:
{
  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    let
      nixosEval = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          { _module.check = lib.mkForce false; }
        ]
        ++ builtins.attrValues {
          inherit (self.modules.nixos)
            settings
            core
            desktop
            server
            ;
        };
      };

      homeManagerEval = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            _module.check = lib.mkForce false;
            home = {
              username = "docs";
              homeDirectory = "/home/docs";
            };
          }
        ]
        ++ builtins.attrValues {
          inherit (self.modules.homeManager)
            settings
            secrets
            theme
            backup
            cosmic-manager
            development
            editing
            gaming
            plasma-manager
            utilities
            web
            ;
        };
      };

      isVisible =
        option:
        (option.visible or true)
        && lib.any (declaration: lib.hasPrefix (toString self.outPath) (toString declaration)) (
          option.declarations or [ ]
        );

      mkOptionsDoc =
        name: options:
        let
          doc = pkgs.nixosOptionsDoc {
            options = builtins.removeAttrs options [ "_module" ];
            transformOptions =
              option:
              option
              // {
                visible = isVisible option;
              };
          };
        in
        pkgs.runCommand name { } ''
          cp ${doc.optionsCommonMark} $out
          sed -i \
            -e 's+\/nix\/store\/[a-z0-9]*-source\/++g' \
            -e 's+file:\/\/+../+g' \
            -e 's+, via option flake[^])]*++g' \
            $out
        '';
    in
    {
      packages = {
        nixos-options-doc = mkOptionsDoc "nixos-options-doc" nixosEval.options;
        home-manager-options-doc = mkOptionsDoc "home-manager-options-doc" homeManagerEval.options;
      };
    };
}
