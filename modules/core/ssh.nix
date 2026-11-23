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
        services = {
          openssh = {
            enable = true;
            settings = {
              PermitRootLogin = "no";
              PasswordAuthentication = false;
              KbdInteractiveAuthentication = false;
              AllowTcpForwarding = false;
              AllowAgentForwarding = false;
            };
            hostKeys = [
              {
                path = "/etc/ssh/ssh_host_ed25519_key";
                type = "ed25519";
              }
            ];
          };
          fail2ban = {
            enable = true;
            maxretry = 5;
            bantime = "15m";
            bantime-increment.enable = true;
          };
        };
      };
    };
}
