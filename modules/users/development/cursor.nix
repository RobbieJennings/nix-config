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
          package = pkgs.unstable.code-cursor;
          profiles = config.programs.vscode.profiles;
        };
      };
    };
}
