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
      "nix-config"
      {
        directory = ".ssh";
        mode = "0700";
      }
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
      ".config"
      ".var"
    ];
    files = [
      ".bash_history"
      ".zsh_history"
    ];
  };
}
