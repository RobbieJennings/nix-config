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
                      mountOptions = ["subvol=root" "noatime"];
                    };

                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = ["subvol=root" "noatime"];
                    };

                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = ["subvol=persist" "noatime"];
                    };

                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["subvol=nix" "noatime"];
                    };

                    "/media" = {
                      mountpoint = "/media";
                      mountOptions = ["subvol=media" "noatime"];
                    };

                    "/games" = {
                      mountpoint = "/media";
                      mountOptions = ["subvol=media" "noatime"];
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
