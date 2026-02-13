{
  inputs,
  ...
}:
{
  flake.modules.homeManager.gaming =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [
        inputs.self.modules.homeManager.heroic
        inputs.self.modules.homeManager.lutris
        inputs.self.modules.homeManager.prism
      ];

      config = {
        heroic.enable = lib.mkDefault true;
        lutris.enable = lib.mkDefault true;
        prism.enable = lib.mkDefault true;
      };
    };
}
