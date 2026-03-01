{
  inputs,
  ...
}:
{
  flake.modules.nixos.intel-device-plugins =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.intel-device-plugins-operator
        inputs.self.modules.nixos.intel-gpu-plugin
      ];

      options = {
        intel-device-plugins.enable = lib.mkEnableOption "Intel device plugins for kubernetes";
      };

      config = lib.mkIf config.intel-device-plugins.enable {
        intel-device-plugins = {
          operator.enable = lib.mkDefault true;
          gpu.enable = lib.mkDefault true;
        };
      };
    };
}
