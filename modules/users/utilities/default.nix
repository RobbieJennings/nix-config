{
  inputs,
  ...
}:
{
  flake.modules.homeManager.utilities =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.homeManager.vlc
        inputs.self.modules.homeManager.office
        inputs.self.modules.homeManager.spotify
        inputs.self.modules.homeManager.calibre
        inputs.self.modules.homeManager.obsidian
        inputs.self.modules.homeManager.obs
        inputs.self.modules.homeManager.kolourpaint
      ];

      config = {
        vlc.enable = lib.mkDefault true;
        office.enable = lib.mkDefault true;
        spotify.enable = lib.mkDefault true;
        calibre.enable = lib.mkDefault true;
        obsidian.enable = lib.mkDefault true;
        obs.enable = lib.mkDefault true;
        kolourpaint.enable = lib.mkDefault true;
      };
    };
}
