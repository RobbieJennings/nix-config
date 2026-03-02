{
  inputs,
  ...
}:
{
  flake.modules.homeManager.cosmic-manager =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        cosmic-manager.enable = lib.mkEnableOption "cosmic-manager";
      };

      imports = [
        inputs.self.modules.homeManager.cosmic-manager-appearance
        inputs.self.modules.homeManager.cosmic-manager-applets
        inputs.self.modules.homeManager.cosmic-manager-compositor
        inputs.self.modules.homeManager.cosmic-manager-panels
        inputs.self.modules.homeManager.cosmic-manager-shortcuts
        inputs.self.modules.homeManager.cosmic-manager-wallpapers
      ];

      config = lib.mkMerge [
        {
          wayland.desktopManager.cosmic.enable = true;
          cosmic-manager.enable = lib.mkDefault true;
        }

        (lib.mkIf config.cosmic-manager.enable {
          cosmic-manager = {
            appearance.enable = lib.mkDefault true;
            applets.enable = lib.mkDefault true;
            compositor.enable = lib.mkDefault true;
            panels.enable = lib.mkDefault true;
            shortcuts.enable = lib.mkDefault true;
            wallpapers.enable = lib.mkDefault true;
          };
        })
      ];
    };
}
