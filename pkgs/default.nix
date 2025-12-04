pkgs: {
  vuescan = pkgs.callPackage ./vuescan.nix { };
  epson-v550-plugin = pkgs.callPackage ./epson-v550-plugin.nix { };
  cosmic-ext-applet-clipboard-manager =
    pkgs.callPackage ./cosmic-ext-applet-clipboard-manager.nix
      { };
}
