{
  inputs,
  ...
}:
{
  flake.modules.nixos.garbage-collection =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        garbage-collection.enable = lib.mkEnableOption "automatic garbage collection of nix store";
      };

      config = lib.mkIf config.garbage-collection.enable {
        nix.gc = {
          automatic = true;
          dates = lib.mkDefault "weekly";
          options = lib.mkDefault "--delete-older-than 30d";
        };
      };
    };
}
