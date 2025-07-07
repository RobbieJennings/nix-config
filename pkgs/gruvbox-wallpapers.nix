{
  lib,
  stdenv,
  fetchFromGitHub,
}:

let
  pname = "gruvbox-wallpapers";
  version = "1.0.0";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "AngelJumbo";
    repo = "gruvbox-wallpapers";
    rev = "725fefba8b0c3a77b3ab1f75deb62789de72c81f";
    hash = "sha256-kZTtuWBOC5bEWnyFAVQC373pVdbM8hqliQUWSGkz22o=";
  };

  buildPhase = "";

  installPhase = ''
    mkdir -p $out/wallpapers
    cp -r wallpapers/* $out/wallpapers
  '';

  meta = with lib; {
    homepage = "https://github.com/AngelJumbo/gruvbox-wallpapers";
    description = "Wallpapers for gruvbox color scheme";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
