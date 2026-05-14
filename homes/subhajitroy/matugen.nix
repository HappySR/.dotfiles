{ config, pkgs, ... }:

{
  home.packages = [ pkgs.matugen ];

  xdg.configFile."matugen/config.toml".source = ./niri/matugen/config.toml;

  xdg.configFile."matugen/templates".source = ./niri/matugen/templates;
}
