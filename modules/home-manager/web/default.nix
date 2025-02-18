{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ ./firefox.nix ./chrome.nix ./brave.nix ./thunderbird.nix ./ktorrent.nix ];

  options = { web.enable = lib.mkEnableOption "enables all web utilities"; };

  config = lib.mkIf config.web.enable {
    web.firefox.enable = lib.mkDefault true;
    web.chrome.enable = lib.mkDefault true;
    web.brave.enable = lib.mkDefault true;
    web.thunderbird.enable = lib.mkDefault true;
    web.ktorrent.enable = lib.mkDefault true;
  };
}
