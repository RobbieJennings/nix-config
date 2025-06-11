{ lib, stdenv, fetchurl, autoPatchelfHook, rpm, cpio }:

let
  pname = "epson-v550-plugin";
  version = "2.30.4";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    urls = [
      "https://download2.ebz.epson.net/iscan/plugin/perfection-v550/rpm/x64/iscan-perfection-v550-bundle-${version}.x64.rpm.tar.gz"
      "https://web.archive.org/web/https://download2.ebz.epson.net/iscan/plugin/perfection-v550/rpm/x64/iscan-perfection-v550-bundle-${version}.x64.rpm.tar.gz"
    ];
    sha256 = "f8b3abf21354fc5b9bc87753cef950b6c0f07bf322a94aaff2c163bafcf50cd9";
  };

  nativeBuildInputs = [ autoPatchelfHook rpm ];

  installPhase = ''
    cd plugins
    ${rpm}/bin/rpm2cpio iscan-plugin-perfection-v550-*.x86_64.rpm | ${cpio}/bin/cpio -idmv
    mkdir -p $out/share
    mkdir -p $out/lib
    cp -r usr/share/* $out/share
    cp -r usr/lib64/* $out/lib
  '';

  meta = with lib; {
    homepage = "http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX";
    description = "plugin files for epson perfection v550 scanner";
    license = licenses.epson;
    platforms = platforms.linux;
  };
}
