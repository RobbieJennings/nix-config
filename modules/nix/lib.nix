{
  inputs,
  lib,
  ...
}:
{
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {
    types = {
      resourceProfile = lib.types.submodule {
        options = {
          requests = {
            cpu = lib.mkOption {
              type = lib.types.str;
              description = "Requested CPU core percentage";
            };
            memory = lib.mkOption {
              type = lib.types.str;
              description = "Requested memory";
            };
          };
          limits = {
            cpu = lib.mkOption {
              type = lib.types.str;
              description = "CPU core percentage limit";
            };
            memory = lib.mkOption {
              type = lib.types.str;
              description = "Memory limit";
            };
          };
        };
      };
    };
  };
}
