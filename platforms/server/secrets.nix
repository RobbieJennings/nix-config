{ config, lib, ... }:

{
  config = lib.mkIf config.secrets.enable {
    sops.secrets = {
      k3s-token = { };
    };
  };
}
