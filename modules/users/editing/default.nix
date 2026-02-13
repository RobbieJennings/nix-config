{
  inputs,
  ...
}:
{
  flake.modules.homeManager.editing =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [
        inputs.self.modules.homeManager.vuescan
        inputs.self.modules.homeManager.darktable
        inputs.self.modules.homeManager.krita
        inputs.self.modules.homeManager.gimp
        inputs.self.modules.homeManager.kdenlive
        inputs.self.modules.homeManager.audacity
      ];

      config = {
        vuescan.enable = lib.mkDefault true;
        darktable.enable = lib.mkDefault true;
        krita.enable = lib.mkDefault true;
        gimp.enable = lib.mkDefault true;
        kdenlive.enable = lib.mkDefault true;
        audacity.enable = lib.mkDefault true;
      };
    };
}
