{
  inputs,
  ...
}:
{
  flake.modules.homeManager.obs =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        obs.enable = lib.mkEnableOption "obs studio screen recorder";
      };

      config = lib.mkIf config.obs.enable {
        programs.obs-studio = {
          enable = true;
          plugins = [ ];
        };
      };
    };
}
