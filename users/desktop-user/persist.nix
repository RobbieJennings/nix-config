{
  mkPersist = username: {
    users.${username} = {
      directories = [
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
        { directory = ".gnupg"; mode = "0700"; }
        { directory = ".ssh"; mode = "0700"; }
        { directory = ".nixops"; mode = "0700"; }
        { directory = ".local/share/keyrings"; mode = "0700"; }
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
        ".histfile"
      ];
    };
  };
}
