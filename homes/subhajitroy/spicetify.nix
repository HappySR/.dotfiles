{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;

    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    enabledExtensions = with spicePkgs.extensions; [
      # lyrics
      beautifulLyrics
      spicyLyrics
      # playback and polish
      coverAmbience
      shuffle
      keyboardShortcut
      powerBar
      volumePercentage
      playNext
      trashbin
      autoSkipVideo
      sleepTimer
      # stats and info
      songStats
      history
      # cleanup
      adblock
      hidePodcasts
    ];

    enabledCustomApps = with spicePkgs.apps; [
      marketplace
      newReleases
      ncsVisualizer
      historyInSidebar
    ];
  };
}
