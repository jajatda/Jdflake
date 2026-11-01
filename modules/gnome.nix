{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myLaptop.gnome;
in
{
  options.myLaptop.gnome = {
    enable = mkEnableOption "GNOME Desktop Environment";
  };

  config = mkIf cfg.enable {
    # services.xserver.enable = true;

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = with pkgs.gnome; [
      # cheese
      # epiphany
      # geary
      # gnome-calendar
      # gnome-contacts
      # gnome-maps
      # gnome-music
      # gnome-photos
      # gnome-tour
      # simple-scan
      # totem
      # yelp
    ];
    environment.systemPackages = with pkgs; [
      gnome-tweaks
    ];

    # services.gnome.evolution-data-server.enable = false;
    # services.gnome.gnome-browser-connector.enable = false;
    # services.gnome.games.enable = false;
  };
}