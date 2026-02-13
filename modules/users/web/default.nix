{
  inputs,
  ...
}:
{
  flake.modules.homeManager.web =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.homeManager.firefox
        inputs.self.modules.homeManager.chrome
        inputs.self.modules.homeManager.brave
        inputs.self.modules.homeManager.thunderbird
        inputs.self.modules.homeManager.qbittorrent
      ];

      config = {
        firefox.enable = lib.mkDefault true;
        chrome.enable = lib.mkDefault true;
        brave.enable = lib.mkDefault true;
        thunderbird.enable = lib.mkDefault true;
        qbittorrent.enable = lib.mkDefault true;
      };
    };
}
