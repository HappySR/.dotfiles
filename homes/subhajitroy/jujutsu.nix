{
  programs.jujutsu = {
    enable = true;
    ediff = true;
    settings = {
      user = {
        name = "Subhajit Roy";
        email = "darrang48@gmail.com";
      };
      signing = {
        key = "2FE279D928DDD672";
        backend = "gpg";
        behavior = "own";
      };
      ui.default-command = "log";
      git.ignore-files = [ "lfs" ];
    };
  };
}
