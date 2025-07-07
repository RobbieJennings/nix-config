pkgs: {
  vuescan = pkgs.callPackage ./vuescan.nix { };
  epson-v550-plugin = pkgs.callPackage ./epson-v550-plugin.nix { };
  gruvbox-wallpapers = pkgs.callPackage ./gruvbox-wallpapers.nix { };
}
