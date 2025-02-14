{ config, lib, pkgs, inputs, ... }:

{
  options = {
    auto-update.enable = lib.mkEnableOption "enables automatic update of nix store";
  };

  config = lib.mkIf config.auto-update.enable {
    system.autoUpgrade = {
      enable = lib.mkDefault true;
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
