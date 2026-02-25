{
  inputs,
  ...
}:
{
  flake.modules.nixos.ssh =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        ssh.enable = lib.mkEnableOption "ssh";
      };

      config = lib.mkIf config.ssh.enable {
        services.openssh = {
          enable = true;
          settings = {
            PermitRootLogin = "no";
          };
        };
      };
    };
}

