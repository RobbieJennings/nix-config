{
  inputs,
  ...
}:
{
  flake.modules.homeManager.neovim =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        neovim.enable = lib.mkEnableOption "Neovim";
      };

      config = lib.mkIf config.neovim.enable {
        programs.neovim = {
          enable = true;
          plugins = [

          ];
        };
      };
    };
}
