{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.jellyfin-plugins =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      moonbasePlugin = pkgs.fetchzip {
        url = "https://github.com/Moonfin-Client/Plugin/releases/download/3.0.0/Moonfin.Server-3.0.0.0.zip";
        hash = "sha256-TJgXfN+pnhA/CLr/Zk+aOgZhELC8O6/IZ5fTdW5/v9w=";
        stripRoot = false;
      };
      fileTransformationPlugin = pkgs.fetchzip {
        url = "https://github.com/IAmParadox27/jellyfin-plugin-file-transformation/releases/download/3.0.3.0/Release-12.2.0.zip";
        hash = "sha256-xjmCbTvr7BxkCTGNqY2lbQCVFfbxhw9Bszh01IoLZUQ=";
        stripRoot = false;
      };
      openSubtitlesPlugin = pkgs.fetchzip {
        url = "https://github.com/jellyfin/jellyfin-plugin-opensubtitles/releases/download/v25/open-subtitles_25.0.0.0.zip";
        hash = "sha256-If7p65jk2tbRJsKBSKJFrnW8/++MaDcRK0azfc8gco0=";
        stripRoot = false;
      };
      introSkipperPlugin = pkgs.fetchzip {
        url = "https://github.com/intro-skipper/intro-skipper/releases/download/12.0%2Fv12.0.6.0/intro-skipper-v12.0.6.0.zip";
        hash = "sha256-g8Oiyt4NK8pyCXt2M1B7EpEL71kUGGkxtXSzKndUuOQ=";
        stripRoot = false;
      };
    in
    {
      _module.args = {
        inherit
          moonbasePlugin
          fileTransformationPlugin
          openSubtitlesPlugin
          introSkipperPlugin
          ;
      };
    };
}
