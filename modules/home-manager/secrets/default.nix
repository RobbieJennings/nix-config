{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    secrets.enable = lib.mkEnableOption "enables importing secrets using sops-nix";
  };
}
