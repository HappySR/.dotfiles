{
  programs.git = {
    enable = true;
    lfs.enable = true;

    # These have been moved into the settings block
    settings = {
      user = {
        name = "Subhajit Roy";
        email = "darrang48@gmail.com";
        signing = {
          key = "2FE279D928DDD672";
          signByDefault = true;
        };
      };

      # Content from extraConfig is now directly in settings
      init.defaultBranch = "main";

      url = {
        "git@github.com:HappySR/".insteadOf = "me:";
        "git@github.com:".insteadOf = "gh:";
        "git@gitlab.com:".insteadOf = "gl:";
        "git@codeberg.org:".insteadOf = "cb:";
      };

      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = "all"; # Usually "all" or true depending on preference
      };
    };
  };
}
