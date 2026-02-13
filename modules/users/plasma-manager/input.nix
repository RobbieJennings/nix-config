{
  inputs,
  ...
}:
{
  flake.modules.homeManager.plasma-manager-input =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        plasma-manager.input.enable = lib.mkEnableOption "plasma-manager input customisations";
      };

      config = lib.mkIf config.plasma-manager.input.enable {
        programs.plasma.input.keyboard.layouts = [ { layout = "ie"; } ];
      };
    };
}
