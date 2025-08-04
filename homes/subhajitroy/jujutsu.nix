{
  programs.jujutsu = {
    enable = true;
    ediff = true;
    settings = {
      user = {
        name = "Subhajit Roy";
        email = "darrang48@gmail.com";
      };
      ui.default-command = "log";
      git.ignore-files = [ "lfs" ];
    };
  };
}
