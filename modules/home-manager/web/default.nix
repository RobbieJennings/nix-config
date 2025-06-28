{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./firefox.nix
    ./chrome.nix
    ./brave.nix
    ./thunderbird.nix
    ./ktorrent.nix
  ];

  options = {
    web.enable = lib.mkEnableOption "all web utilities";
  };

  config = lib.mkIf config.web.enable {
    web = {
      firefox.enable = lib.mkDefault true;
      chrome.enable = lib.mkDefault true;
      brave.enable = lib.mkDefault true;
      thunderbird.enable = lib.mkDefault true;
      ktorrent.enable = lib.mkDefault true;
    };
  };
}
