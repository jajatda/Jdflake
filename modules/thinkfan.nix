{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.myLaptop.thinkfan;

  # Helper to make the type more readable (optional but nice)
  levelType = types.submodule {
    options = {
      level = mkOption {
        type = types.either types.int (types.enum [ "level auto" "level full-speed" "level disengaged" ]);
        description = "Fan level (0-7, or special strings)";
      };
      low = mkOption {
        type = types.ints.unsigned;
        description = "Lower temperature bound";
      };
      high = mkOption {
        type = types.ints.unsigned;
        description = "Upper temperature bound";
      };
    };
  };
in
{
  options.myLaptop.thinkfan = {
    enable = mkEnableOption "Enable thinkfan fan control for ThinkPad";

    sensors = mkOption {
      type = types.listOf types.attrs;
      default = [
        { type = "hwmon"; hwmon = "/sys/class/hwmon/hwmon*/temp1_input"; name = "CPU"; }
      ];
      description = "List of sensor paths for thinkfan";
    };

    levels = mkOption {
      type = types.listOf (types.listOf (types.either types.int (types.enum [ "level auto" "level full-speed" "level disengaged" ])));
      # atau lebih ketat: types.listOf (types.tupleOf [ levelType.level levelType.low levelType.high ])
      default = [
        [ 0 0 45 ]
        [ 1 38 48 ]
        [ 2 42 52 ]
        [ 3 47 58 ]
        [ 4 54 65 ]
        [ 5 60 75 ]
        [ 7 72 32767 ]
      ];
      example = literalExample ''
        [
          [ 0 0 50 ]
          [ 2 45 60 ]
          [ "level auto" 70 32767 ]
        ]
      '';
      description = ''
        Fan level configuration.
        Each entry: [ level low-temp high-temp ]
        Level can be 0-7 (integer) or strings like "level auto".
      '';
    };
  };

  config = mkIf cfg.enable {
    services.thinkfan = {
      enable = true;
      inherit (cfg) sensors levels;
      extraArgs = [ "-b" "0" ];  # lebih responsif
    };

    boot.extraModprobeConfig = ''
      options thinkpad_acpi fan_control=1
    '';
    # Uncomment kalau di X230 perlu experimental mode (model lama, kadang butuh):
    # boot.kernelParams = [ "thinkpad_acpi.experimental=1" ];
  };
}