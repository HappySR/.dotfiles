{ lib, config, ... }:

{
  options.trusted-substituters.enable = lib.mkEnableOption "enable pulling binary caches from trusted substituters";

  config = lib.mkIf config.trusted-substituters.enable {
    nix.settings = {
      substituters = [
        "https://niri.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
