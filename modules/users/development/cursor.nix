{
  inputs,
  ...
}:
{
  flake.modules.homeManager.cursor =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        cursor.enable = lib.mkEnableOption "Cursor IDE";
      };

      config = lib.mkIf config.cursor.enable {
        programs.cursor = {
          enable = true;
          profiles = config.programs.vscode.profiles;
        };
      };
    };
}
