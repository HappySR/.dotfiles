{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Subhajit Roy";
    userEmail = "darrang48@gmail.com";
    signing = {
      key = "2FE279D928DDD672";
      signByDefault = true;
    };
    extraConfig = {
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
        showUntrackedFiles = true;
      };
    };
  };
}
