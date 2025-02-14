{ lib, stdenv, fetchurl, gnutar, autoPatchelfHook, glibc, gtk3, xorg, libgudev, makeDesktopItem }:
let
  pname = "vuescan";
  version = "9.8";
  desktopItem = makeDesktopItem {
    name = "VueScan2";
    desktopName = "VueScan2";
    genericName = "Scanning Program";
    comment = "Scanning Program";
    icon = "vuescan";
    terminal = false;
    type = "Application";
    startupNotify = true;
    categories = [ "Graphics" "Utility" ];
    keywords = [ "scan" "scanner" ];
    exec = "vuescan";
  };
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
   url = "https://www.hamrick.com/files/vuex6498.tgz";
   sha256 = "9a89142ca0d09c337190e0d821806bd8d76be0e99ffb1c65cbc1c173d897cd78";
  };

  dontStrip = true; # Stripping breaks the program
  nativeBuildInputs = [ gnutar autoPatchelfHook ];
  buildInputs = [ glibc gtk3 xorg.libSM libgudev ];

  unpackPhase = ''
    tar xfz $src
  '';

  installPhase = ''
    install -m755 -D VueScan/vuescan $out/bin/vuescan

    mkdir -p $out/share/icons/hicolor/scalable/apps/
    cp VueScan/vuescan.svg $out/share/icons/hicolor/scalable/apps/vuescan.svg

    mkdir -p $out/lib/udev/rules.d/
    cp VueScan/vuescan.rul $out/lib/udev/rules.d/60-vuescan.rules

    mkdir -p $out/share/applications/
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';
}
