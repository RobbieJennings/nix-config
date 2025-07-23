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
  ];

  options = {
    backup.enable = lib.mkEnableOption "enable restic backup";
  };

  config = lib.mkIf config.backup.enable {
    backup = {
      restic.enable = lib.mkDefault true;
    };
  };
}
