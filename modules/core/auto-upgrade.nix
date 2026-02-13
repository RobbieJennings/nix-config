{
  inputs,
  ...
}:
{
  flake.modules.nixos.auto-upgrade =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        auto-upgrade.enable = lib.mkEnableOption "automatic update of nix flake from github";
      };

      config = lib.mkIf config.auto-upgrade.enable {
        system.autoUpgrade = {
          enable = true;
          flake = lib.mkDefault "github:robbiejennings/nix-config";
          flags = lib.mkDefault [
            "-L" # print build logs
          ];
          dates = lib.mkDefault "02:00";
          randomizedDelaySec = lib.mkDefault "45min";
        };
      };
    };
}
