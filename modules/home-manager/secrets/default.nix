{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    secrets.enable = lib.mkEnableOption "importing secrets using sops-nix";
  };
}
