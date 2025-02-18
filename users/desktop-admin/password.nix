{
  mkSecret = username: { "passwords/${username}".neededForUsers = true; };

  mkUser = config: username: {
    ${username} = {
      initialPassword = null;
      hashedPasswordFile = config.sops.secrets."passwords/${username}".path;
    };
  };
}
