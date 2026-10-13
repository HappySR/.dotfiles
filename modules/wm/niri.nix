{ pkgs, pkgs', ... }:

{
  programs.niri = {
    enable = true;
    package = pkgs'.niri;
  };

  xdg.portal = {
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.niri = {
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
      "org.freedesktop.impl.portal.Access" = [ "gtk" ];
      "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
  };

  systemd.user.services.plasma-xdg-desktop-portal-kde = {
    overrideStrategy = "asDropin";
    environment.QT_QPA_PLATFORMTHEME = "kde";
  };
}
