{
  mkSecret = username: {
    "users/${username}/password".neededForUsers = true;
  };

  mkUser = config: username: {
    ${username} = {
      initialPassword = null;
      hashedPasswordFile = config.sops.secrets."users/${username}/password".path;
    };
  };
}
