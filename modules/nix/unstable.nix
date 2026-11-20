{
  inputs,
  self,
  ...
}:
{
  flake.overlays.unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = final.config.allowUnfree;
    };
  };

  flake.modules.nixos.unstable-packages = {
    nixpkgs.overlays = [ self.overlays.unstable-packages ];
    home-manager.sharedModules = [
      {
        nixpkgs.overlays = [ self.overlays.unstable-packages ];
      }
    ];
  };
}
