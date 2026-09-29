{
  lib,
  config,
  pkgs,
  ...
}:

let
  kernel = config.boot.kernelPackages.kernel;

  linuwu-sense = pkgs.stdenv.mkDerivation {
    pname = "linuwu-sense";
    version = "git";
    __structuredAttrs = true;

    src = pkgs.fetchFromGitHub {
      owner = "PXDiv";
      repo = "Div-Linuwu-Sense";
      rev = "d8ea437d847268dd9fe2a49ae28d0723dd720968";
      hash = "sha256-VA8i6kTQ4p5AqSW/jNWJOB4/I4pXV3KKIcrcZ2zHrgM=";
    };

    postPatch = ''
      sed -i 's/\bstrncpy(/memcpy(/' src/linuwu_sense.c
    '';

    nativeBuildInputs = kernel.moduleBuildDependencies;
    hardeningDisable = [
      "pic"
      "format"
    ];

    makeFlags = (lib.filter (f: !(lib.hasPrefix "O=" f)) kernel.makeFlags) ++ [
      "KVER=${kernel.modDirVersion}"
      "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    ];

    installPhase = ''
      runHook preInstall
      install -D src/linuwu_sense.ko \
        $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86/linuwu_sense.ko
      runHook postInstall
    '';
  };

  kbPath = "/sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi/four_zoned_kb";

  kb-wave-on = pkgs.writeShellScriptBin "kb-wave-on" ''
    echo "3,5,100,2,0,150,255" | sudo tee ${kbPath}/four_zone_mode
  '';

  kb-off = pkgs.writeShellScriptBin "kb-off" ''
    echo "0,0,0,1,0,0,0" | sudo tee ${kbPath}/four_zone_mode
  '';
in
{
  options.linuwu-sense.enable = lib.mkEnableOption "Linuwu-Sense (Acer Predator/Nitro RGB keyboard and platform module)";

  config = lib.mkIf config.linuwu-sense.enable {
    boot.extraModulePackages = [ linuwu-sense ];
    boot.blacklistedKernelModules = [ "acer_wmi" ];
    boot.kernelModules = [ "linuwu_sense" ];

    users.groups.linuwu_sense = { };
    users.users.subhajitroy.extraGroups = [ "linuwu_sense" ];

    systemd.tmpfiles.rules = [
      "f ${kbPath}/four_zone_mode 0660 root linuwu_sense - -"
      "f ${kbPath}/per_zone_mode 0660 root linuwu_sense - -"
      "f /sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi/predator_sense/fan_speed 0660 root linuwu_sense - -"
      "f /sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi/predator_sense/usb_charging 0660 root linuwu_sense - -"
      "f /sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi/predator_sense/battery_limiter 0660 root linuwu_sense - -"
    ];

    # Lights off at every boot, before any login.
    systemd.services.linuwu-sense-off = {
      description = "Turn off Predator keyboard RGB at boot";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-modules-load.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.coreutils}/bin/tee ${kbPath}/four_zone_mode";
        StandardInput = "data";
        StandardInputText = "0,0,0,1,0,0,0";
      };
    };

    environment.systemPackages = [
      kb-wave-on
      kb-off
    ];
  };
}
