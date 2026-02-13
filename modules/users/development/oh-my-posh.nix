{
  inputs,
  ...
}:
{
  flake.modules.homeManager.oh-my-posh =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        oh-my-posh.enable = lib.mkEnableOption "oh-my-posh";
      };

      config = lib.mkIf config.oh-my-posh.enable {
        programs = {
          bash.enable = true;
          zsh.enable = true;
          oh-my-posh = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
            useTheme = "gruvbox";
          };
        };
      };
    };
}
