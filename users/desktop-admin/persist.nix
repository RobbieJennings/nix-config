{
  username,
  ...
}:

{
  users.${username} = {
    directories = [
      "Books"
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"
      "Games"
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
      ".config"
      ".var"
    ];
    files = [
      ".bashrc"
      ".zshrc"
      ".p10k.zsh"
    ];
  };
}
