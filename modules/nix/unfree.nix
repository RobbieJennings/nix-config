{
  inputs,
  ...
}:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };

  flake.modules.nixos.unfree-packages = {
    nixpkgs.config.allowUnfree = true;
    home-manager.sharedModules = [
      {
        nixpkgs.config.allowUnfree = true;
      }
    ];
  };
}
