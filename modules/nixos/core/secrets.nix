{ config, lib, pkgs, inputs, ... }:

{
  options = {
    secrets.enable = lib.mkEnableOption "enables importing secrets using sops-nix";
  };

  config = lib.mkIf config.secrets.enable {
    sops.defaultSopsFile = lib.mkDefault ../../../secrets.yaml;
    sops.age.sshKeyPaths = lib.mkDefault [ "/persist/root/.ssh/id_ed25519" ];
  };
}
