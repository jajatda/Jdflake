{ pkgs, ... }:

{
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

  # services.gnome.evolution-data-server.enable = false;
  # services.gnome.gnome-browser-connector.enable = false;
  # services.gnome.games.enable = false;
}