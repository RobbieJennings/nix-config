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
        directory = ".gnupg";
        mode = "0700";
      }
      {
        directory = ".ssh";
        mode = "0700";
      }
      {
        directory = ".nixops";
        mode = "0700";
      }
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
      ".local/share/kwalletd"
      ".local/share/direnv"
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
