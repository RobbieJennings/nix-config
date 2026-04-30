{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.netbird-operator-secrets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config =
        lib.mkIf
          (config.netbird-operator.enable && config.secrets.enable && config.secrets.netbird-operator.enable)
          {
            sops = {
              secrets = {
                "netbird/key" = { };
              };
              templates = {
                netbirdMgmtApiKey = {
                  content = builtins.toJSON {
                    apiVersion = "v1";
                    kind = "Secret";
                    metadata = {
                      name = "netbird-mgmt-api-key";
                      namespace = "netbird";
                    };
                    type = "Opaque";
                    immutable = true;
                    stringData = {
                      NB_API_KEY = config.sops.placeholder."netbird/key";
                    };
                  };
                  path = "/var/lib/rancher/k3s/server/manifests/netbird-mgmt-api-key.json";
                };
              };
            };
          };
    };
}
