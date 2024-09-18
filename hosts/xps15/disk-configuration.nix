{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vda";
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

                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = ["subvol=home"];
                    };

                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = ["subvol=persist"];
                    };

                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["subvol=nix"];
                    };

                    "/media" = {
                      mountpoint = "/media";
                      mountOptions = ["subvol=media"];
                    };

                    "/games" = {
                      mountpoint = "/games";
                      mountOptions = ["subvol=games"];
                    };

                    "/swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "8192M";
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
