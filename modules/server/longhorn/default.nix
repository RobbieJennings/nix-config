{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.longhorn =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.longhorn-charts
        inputs.self.modules.nixos.longhorn-images
        inputs.self.modules.nixos.longhorn-settings
        inputs.self.modules.nixos.longhorn-services
      ];

      options = {
        longhorn.enable = lib.mkEnableOption "Longhorn helm chart on k3s";
      };

      config = lib.mkIf config.longhorn.enable {
        systemd.tmpfiles.rules = [
          "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
        ];
        environment.systemPackages = [
          pkgs.util-linux
          pkgs.nfs-utils
        ];
        services.openiscsi = {
          enable = true;
          name = "${config.networking.hostName}-initiatorhost";
        };
      };
    };
}
