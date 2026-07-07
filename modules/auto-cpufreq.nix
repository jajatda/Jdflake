{ config, lib, pkgs, ... }:

with lib;

{
  options.myLaptop.autoCpufreq = {
    enable = mkEnableOption "Enable auto-cpufreq with sensible defaults";

    aggressive = mkEnableOption "Aggressive power saving (battery)" // { default = true; };
  };

  config = mkIf config.myLaptop.autoCpufreq.enable {
    services.tlp.enable = false;  # konflik

    services.auto-cpufreq = {
      enable = true;

      settings = mkMerge [
        # default yang bagus untuk ThinkPad
        {
          battery = {
            governor = "powersave";
            turbo = "never";  # atau "auto" kalau mau kadang boost
             # Battery threshold settings
            enable_thresholds = true;
            start_threshold = 80; # Start charging when below 75%
            stop_threshold = 95;  # Stop charging at 80%
          };
          charger = {
            governor = "performance";
            turbo = "auto";
          };

        }
        

        # kalau aggressive = true, lebih hemat lagi
        (mkIf config.myLaptop.autoCpufreq.aggressive {
          battery = {
            governor = "powersave";
            turbo = "never";
            energy_performance_preference = "power";
          };
        })
      ];
    };

    services.thermald.enable = true;  # hampir selalu bagus bareng auto-cpufreq
  };
}