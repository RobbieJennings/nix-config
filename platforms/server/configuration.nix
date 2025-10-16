{ config, pkgs, ... }:

{
  config = {
    environment.systemPackages = [
      pkgs.git
      pkgs.vim
      pkgs.wget
      pkgs.just
    ];

    server.enable = true;
  };
}
