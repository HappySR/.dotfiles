{ pkgs, ... }:

{
  # Dolphin, kio-extras, kio-admin, ffmpegthumbs and Breeze already come from
  # services.desktopManager.plasma6 (modules/wm/plasma.nix). These are extras.
  home.packages = with pkgs.kdePackages; [
    ark # archive handling from the context menu
    kdegraphics-thumbnailers # pdf/ps/raw previews
    kimageformats # webp/avif/etc previews
  ];

  # Default applications (Dolphin for folders, plus what was in the old
  # ~/.config/mimeapps.list).
  xdg.mimeApps = {
    enable = true;

    associations.added = {
      "application/json" = [
        "Helix.desktop"
        "dev.zed.Zed.desktop"
      ];
      "application/x-docbook+xml" = [
        "Helix.desktop"
        "dev.zed.Zed.desktop"
      ];
      "application/x-yaml" = [
        "Helix.desktop"
        "dev.zed.Zed.desktop"
      ];
      "text/markdown" = [
        "Helix.desktop"
        "dev.zed.Zed.desktop"
      ];
      "text/plain" = [
        "Helix.desktop"
        "dev.zed.Zed.desktop"
        "code.desktop"
      ];
      "text/x-cmake" = [
        "Helix.desktop"
        "dev.zed.Zed.desktop"
      ];
      "x-scheme-handler/http" = [
        "firefox.desktop"
        "com.brave.Browser.desktop"
      ];
      "x-scheme-handler/https" = [
        "firefox.desktop"
        "com.brave.Browser.desktop"
      ];
      "image/jpeg" = [
        "org.pwmt.zathura-pdf-mupdf.desktop"
        "org.kde.gwenview.desktop"
      ];
      "video/x-matroska" = [ "org.videolan.VLC.desktop" ];
    };

    defaultApplications = {
      "inode/directory" = [ "org.kde.dolphin.desktop" ];

      "application/json" = [ "Helix.desktop" ];
      "application/x-docbook+xml" = [ "Helix.desktop" ];
      "application/x-yaml" = [ "Helix.desktop" ];
      "text/markdown" = [ "Helix.desktop" ];
      "text/plain" = [ "code.desktop" ];
      "text/x-cmake" = [ "Helix.desktop" ];

      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "application/x-extension-htm" = [ "firefox.desktop" ];
      "application/x-extension-html" = [ "firefox.desktop" ];
      "application/x-extension-shtml" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "application/x-extension-xhtml" = [ "firefox.desktop" ];
      "application/x-extension-xht" = [ "firefox.desktop" ];

      "image/jpeg" = [ "org.kde.gwenview.desktop" ];
      "video/x-matroska" = [ "org.videolan.VLC.desktop" ];
      "x-scheme-handler/claude-cli" = [ "claude-code-url-handler.desktop" ];
    };
  };
}
