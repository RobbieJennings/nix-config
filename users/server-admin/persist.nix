{
  username,
  ...
}:

{
  users.${username} = {
    directories = [
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"
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
      ".local/share/direnv"
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
