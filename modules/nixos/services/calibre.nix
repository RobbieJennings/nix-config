{ config, lib, pkgs, inputs, ... }:

{
  options = {
    calibre.enable = lib.mkEnableOption "enables calibre ebook server";
  };

  config = lib.mkIf config.calibre.enable {
    services.calibre-server.enable = lib.mkDefault true;
    services.calibre-server.libraries = lib.mkDefault [ "/media/books"];
  };
}
