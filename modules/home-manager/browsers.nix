{ config, lib, pkgs, inputs, outputs, ... }:

{
  options = {
    browsers.enable = lib.mkEnableOption "enables chrome, brave and firefox web browsers";
  };

  config = lib.mkIf config.browsers.enable {
    programs.firefox.enable = lib.mkDefault true;
    programs.google-chrome.enable = lib.mkDefault true;
    programs.brave.enable = lib.mkDefault true;
  };
}
