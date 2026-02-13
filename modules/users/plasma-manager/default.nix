{
  inputs,
  ...
}:
{
  flake.modules.homeManager.plasma-manager =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        plasma-manager.enable = lib.mkEnableOption "plasma-manager";
      };

      imports = [
        inputs.self.modules.homeManager.plasma-manager-input
        inputs.self.modules.homeManager.plasma-manager-look-and-feel
        inputs.self.modules.homeManager.plasma-manager-panels
      ];

      config = lib.mkMerge [
        {
          programs.plasma.enable = true;
          plasma-manager.enable = lib.mkDefault true;
        }

        (lib.mkIf config.plasma-manager.enable {
          plasma-manager = {
            input.enable = lib.mkDefault true;
            look-and-feel.enable = lib.mkDefault true;
            panels.enable = lib.mkDefault true;
          };
        })
      ];
    };
}
