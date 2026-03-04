{
  inputs,
  ...
}:
{
  flake.modules.nixos.server =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.k3s
        inputs.self.modules.nixos.longhorn
        inputs.self.modules.nixos.metallb
        inputs.self.modules.nixos.node-feature-discovery
        inputs.self.modules.nixos.cert-manager
        inputs.self.modules.nixos.intel-device-plugins
        inputs.self.modules.nixos.monitoring
        inputs.self.modules.nixos.nextcloud
        inputs.self.modules.nixos.gitea
        inputs.self.modules.nixos.homepage
        inputs.self.modules.nixos.media-server
        inputs.self.modules.nixos.tailscale-operator
      ];

      config = {
        k3s.enable = lib.mkDefault true;
        longhorn.enable = lib.mkDefault true;
        metallb.enable = lib.mkDefault true;
        node-feature-discovery.enable = lib.mkDefault true;
        cert-manager.enable = lib.mkDefault true;
        intel-device-plugins.enable = lib.mkDefault true;
        monitoring.enable = lib.mkDefault true;
        nextcloud.enable = lib.mkDefault true;
        gitea.enable = lib.mkDefault true;
        homepage.enable = lib.mkDefault true;
        media-server.enable = lib.mkDefault true;
        tailscale-operator.enable = lib.mkDefault true;
      };
    };
}
