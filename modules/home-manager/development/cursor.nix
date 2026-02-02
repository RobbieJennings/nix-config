{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    development.cursor.enable = lib.mkEnableOption "Cursor IDE";
  };

  config = lib.mkIf config.development.cursor.enable {
    home.packages = [ pkgs.code-cursor ];
    home.file = lib.mkIf config.development.vscode.enable {
      # Sync Cursor settings from VSCodium
      ".config/Cursor/User/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/VSCodium/User/settings.json";
      # Sync Cursor keybindings from VSCodium
      ".config/Cursor/User/keybindings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/VSCodium/User/keybindings.json";
      # Sync Cursor extensions from VSCodium
      ".cursor/extensions".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.vscode-oss/extensions";
    };
  };
}
