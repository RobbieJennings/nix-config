{ config, lib, pkgs, inputs, ... }:

{
  options = {
    auto-upgrade.enable = lib.mkEnableOption "enables automatic update of nix store";
  };

  config = lib.mkIf config.auto-upgrade.enable {
    system.autoUpgrade = {
      enable = true;
      flake = lib.mkDefault inputs.self.outPath;
      flags = lib.mkDefault [
        "--update-input"
        "nixpkgs"
        "--no-write-lock-file"
        "-L" # print build logs
      ];
      dates = lib.mkDefault "02:00";
      randomizedDelaySec = lib.mkDefault "45min";
    };
  };
}
