{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.mysql = {
    enable = lib.mkEnableOption "enable mysql module";
    user = lib.mkOption {
      type = lib.types.str;
      description = "unix user that gets passwordless (socket auth) admin access to mysql";
    };
  };

  config = lib.mkIf config.mysql.enable {
    services.mysql = {
      enable = true;
      # Oracle MySQL. Swap for pkgs.mariadb if you ever want MariaDB instead.
      package = pkgs.mysql84;
      settings.mysqld = {
        # Local development only, do not expose to the network.
        bind-address = "127.0.0.1";
      };
      ensureUsers = [
        {
          name = config.mysql.user;
          ensurePermissions = {
            "*.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };
  };
}
