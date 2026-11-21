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
}
