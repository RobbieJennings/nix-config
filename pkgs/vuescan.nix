{ lib, stdenv, fetchurl, gnutar, autoPatchelfHook, glibc, gtk3, makeDesktopItem }:

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
    sha256 = "b770828d280d5600c63b6c214484f32abac3edf9e361b7d563391797f24b4457";
  };

  dontStrip = true;
  nativeBuildInputs = [ gnutar autoPatchelfHook ];
  buildInputs = [ glibc gtk3 ];

  unpackPhase = ''
    tar xfz $src
  '';

  installPhase = ''
    install -m755 -D VueScan/vuescan $out/bin/vuescan
    mkdir -p $out/share/icons/hicolor/scalable/apps/
    mkdir -p $out/lib/udev/rules.d/
    mkdir -p $out/share/applications/
    cp VueScan/vuescan.svg $out/share/icons/hicolor/scalable/apps/vuescan.svg
    cp VueScan/vuescan.rul $out/lib/udev/rules.d/60-vuescan.rules
    ln -s ${desktopItem}/share/applications/* $out/share/applications
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
