{
  inputs,
  ...
}:
{
  flake.modules.homeManager.development =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.homeManager.vscode
        inputs.self.modules.homeManager.cursor
        inputs.self.modules.homeManager.neovim
        inputs.self.modules.homeManager.oh-my-posh
      ];

      config = {
        vscode.enable = lib.mkDefault true;
        cursor.enable = lib.mkDefault true;
        neovim.enable = lib.mkDefault true;
        oh-my-posh.enable = lib.mkDefault true;
      };
    };
}
