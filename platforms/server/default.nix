{
  mkPlatform = { ... }: {
    imports = [
      ./configuration.nix
      ./persist.nix
    ];
  };
}
