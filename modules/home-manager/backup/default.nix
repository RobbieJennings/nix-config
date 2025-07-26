{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./restic.nix
    ./rclone.nix
  ];

  options = {
    backup.enable = lib.mkEnableOption "backup with rclone and restic";
  };

  config = lib.mkIf config.backup.enable {
    backup = {
      restic.enable = lib.mkDefault true;
      rclone.enable = lib.mkDefault true;
    };
  };
}
