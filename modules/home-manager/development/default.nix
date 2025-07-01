{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./vscode.nix
  ];

  options = {
    development.enable = lib.mkEnableOption "all development tools";
  };

  config = lib.mkIf config.development.enable {
    development = {
      vscode.enable = lib.mkDefault true;
    };
  };
}
