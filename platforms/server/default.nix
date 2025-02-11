{
  mkPlatform = { ... }: {
    imports = [
      ./configuration.nix
      ./persist.nix
      ./secrets.nix
    ];
  };
}
