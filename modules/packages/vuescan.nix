{
  inputs,
  ...
}:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.vuescan = pkgs.callPackage (
        {
          lib,
          stdenv,
          autoPatchelfHook,
          gnutar,
          wrapGAppsHook3,
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
        stdenv.mkDerivation {
          inherit pname version;
          src = inputs.vuescan-source;
          dontStrip = true;

          nativeBuildInputs = [
            autoPatchelfHook
            gnutar
            wrapGAppsHook3
          ];

          buildInputs = [
            gtk3
          ];

          installPhase = ''
            runHook preInstall

            install -Dm755 vuescan $out/bin/vuescan
            install -Dm644 vuescan.svg $out/share/icons/hicolor/scalable/apps/vuescan.svg
            install -Dm644 vuescan.rul $out/lib/udev/rules.d/60-vuescan.rules

            mkdir -p $out/share/applications
            ln -s ${desktopItem}/share/applications/* $out/share/applications/

            runHook postInstall
          '';

          meta = with lib; {
            homepage = "https://www.hamrick.com/about-vuescan.html";
            description = "Scanning software for film scanners";
            license = licenses.unfree;
            platforms = [ "x86_64-linux" ];
          };
        }
      ) { };
    };
}
