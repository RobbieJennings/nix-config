{
  inputs,
  ...
}:

{
  additions = final: _prev: import ../pkgs final.pkgs;

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final.system) ;
      config.allowUnfree = final.config.allowUnfree;
    };
  };

  modifications = final: prev: {
    # Don't want applet in system tray
    networkmanagerapplet = prev.networkmanagerapplet.overrideAttrs (old: {
      mesonFlags = [
        "-Dselinux=false"
        "-Dappindicator=no"
      ];
    });
  };
}
