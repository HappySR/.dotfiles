{ lib, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
    enableFishIntegration = true;
    enableNushellIntegration = true;
    plugins = {
      full-border = pkgs.yaziPlugins.full-border;
      git = pkgs.yaziPlugins.git;
      no-status = pkgs.yaziPlugins.no-status;
      piper = pkgs.yaziPlugins.piper;
    };
    initLua = ./yazi/init.lua;
    settings = {
      mgr.ratio = [
        0
        3
        6
      ];
      plugin = {
        prepend_previewers = [
          {
            name = "*.md";
            run = "piper -- CLICOLOR_FORCE=1 ${pkgs.glow}/bin/glow -w=$w -s=dark \"$1\"";
            group = "md";
            url = "*.md";
          }
          {
            name = "*.tar*";
            run = "piper --format=url -- tar tf \"$1\"";
            group = "tar";
            url = "*.tar";
          }
          {
            name = "*/";
            run = "piper -- eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes \"$1\"";
            group = "*/";
            url = "*/";
          }
        ];
        prepend_fetchers = [
          {
            id = "git";
            name = "*";
            url = "*";
            run = "git";
            group = "git";
          }
          {
            id = "git";
            name = "*/";
            url = "*/";
            run = "git";
            group = "git";
          }
        ];
        preview = {
          max_width = 1500;
          max_height = 1000;
        };
      };
    };
  };
  xdg.configFile."yazi/plugins/no-header.yazi".source = ./yazi/plugins/no-header.yazi;
}
