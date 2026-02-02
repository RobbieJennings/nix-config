{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  gnutar,
  wrapGAppsHook3,
  glibc,
  gtk3,
  makeDesktopItem,
}:

let
  pname = "vuescan";
  version = "9.8";
  desktopItem = makeDesktopItem {
    name = "VueScan";
    desktopName = "VueScan";
    genericName = "Scanning Program";
    comment = "Scanning Program";
    icon = "vuescan";
    terminal = false;
    type = "Application";
    startupNotify = true;
    categories = [
      "Graphics"
      "Utility"
    ];
    keywords = [
      "scan"
      "scanner"
    ];
    exec = "vuescan";
  };
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://www.hamrick.com/files/vuex6498.tgz";
    sha256 = "sha256-tD7KoPH1BGzyURle4ga5b56js0L+lhDD69X0iuC4YJ4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    gnutar
    wrapGAppsHook3
  ];
  buildInputs = [
    glibc
    gtk3
  ];

  dontStrip = true;

  installPhase = ''
    install -m755 -D vuescan $out/bin/vuescan
    mkdir -p $out/share/icons/hicolor/scalable/apps/
    mkdir -p $out/lib/udev/rules.d/
    mkdir -p $out/share/applications/
    cp vuescan.svg $out/share/icons/hicolor/scalable/apps/vuescan.svg
    cp vuescan.rul $out/lib/udev/rules.d/60-vuescan.rules
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.hamrick.com/about-vuescan.html";
    description = "Scanning software for film scanners";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
