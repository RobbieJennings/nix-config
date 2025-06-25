{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                    };

                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [ "subvol=persist" ];
                    };

                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "subvol=nix" ];
                    };

                    "/media" = {
                      mountpoint = "/media";
                      mountOptions = [ "subvol=media" ];
                    };

                    "/swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "16384M";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
