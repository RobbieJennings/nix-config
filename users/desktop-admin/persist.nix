{ username, ... }:

{
  persistence."/persist".users.${username} = {
    directories = [
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"
      "Games"
      "Books"
      "nix-config"
      {
        directory = ".ssh";
        mode = "0700";
      }
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
      {
        directory = ".local/share/kwalletd";
        mode = "0700";
      }
      ".local/share/flatpak"
      ".local/share/Steam"
      ".local/share/PrismLauncher"
      ".local/state/cosmic"
      ".local/state/cosmic-comp"
      ".config"
      ".var"
    ];
  };
}
