{ lib, stdenv, fetchurl, rpm, cpio, autoPatchelfHook }:

let
  pname = "iscan-perfection-v550-bundle";
  version = "2.30.4";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  nativeBuildInputs = [
    rpm
    cpio
    autoPatchelfHook
  ];

  src = fetchurl {
    urls = [
      "https://download2.ebz.epson.net/iscan/plugin/perfection-v550/rpm/x64/iscan-perfection-v550-bundle-${version}.x64.rpm.tar.gz"
      "https://web.archive.org/web/https://download2.ebz.epson.net/iscan/plugin/perfection-v550/rpm/x64/iscan-perfection-v550-bundle-${version}.x64.rpm.tar.gz"
    ];
    sha256 = "f8b3abf21354fc5b9bc87753cef950b6c0f07bf322a94aaff2c163bafcf50cd9";
  };

  installPhase = ''
    cd plugins
    ${rpm}/bin/rpm2cpio iscan-plugin-perfection-v550-*.x86_64.rpm | ${cpio}/bin/cpio -idmv
    mkdir $out
    cp -r usr/share $out
    cp -r usr/lib64 $out/lib
    mv $out/share/iscan $out/share/esci
    mv $out/lib/iscan $out/lib/esci
  '';

  meta = {
    description = "Plugin to support Perfection V550 Photo scanner";
    homepage = "http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; epson;
    platforms = with lib.platforms; linux;
  };
}
