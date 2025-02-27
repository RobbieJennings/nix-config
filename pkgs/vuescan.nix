{ lib, stdenv, fetchurl, gnutar, autoPatchelfHook, glibc, gtk3, makeDesktopItem, makeWrapper, epkowa }:

let
  pname = "vuescan";
  version = "9.8";
  desktopItem = makeDesktopItem {
    name = "VueScanix";
    desktopName = "VueScanix";
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
    sha256 = "11ecf13a943f904d226f227f55602ca3e9adba9e63d3bc77677879e82d1baaa8";
  };

  dontStrip = true; # Stripping breaks the program
  nativeBuildInputs = [ gnutar autoPatchelfHook makeWrapper ];
  buildInputs = [ glibc gtk3 epkowa ];

  unpackPhase = ''
    tar xfz $src
  '';

  installPhase = ''
    runHook preInstall
    install -m755 -D VueScan/vuescan $out/bin/vuescan

    mkdir -p $out/share/icons/hicolor/scalable/apps/
    cp VueScan/vuescan.svg $out/share/icons/hicolor/scalable/apps/vuescan.svg

    mkdir -p $out/lib/udev/rules.d/
    cp VueScan/vuescan.rul $out/lib/udev/rules.d/60-vuescan.rules

    mkdir -p $out/share/applications/
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/vuescan --prefix PATH : ${epkowa}/lib/sane
  '';

  meta = with lib; {
    homepage = "https://www.hamrick.com/about-vuescan.html";
    description = "Scanning software for film scanners";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
    ];
  };
}
