{ config, pkgs, lib, ... }:

{
  # ======================
  # KDE Plasma 6 Module
  # ======================

  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;   # biar aplikasi Qt5 juga temanya bagus
  };

  # Display Manager
  services.displayManager.sddm = {
    enable = false;
    wayland.enable = true;         # sangat disarankan
    # theme = "breeze";            # default sudah bagus
  };

  # Pastikan X server aktif (dibutuhkan beberapa komponen)
  # services.xserver.enable = true; sudah di set di configuration.nix

  # ======================
  # Exclude packages yang tidak dibutuhkan
  # ======================
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    # Media & Entertainment
    elisa                     # Music player
    # kamoso                 # Camera app (kalau ada)

    # Games
    kmahjongg
    kmines
    kpat
    ksudoku

    # Internet
    plasma-browser-integration
    # konversation           # IRC client
    # ktorrent

    # Lainnya (opsional, sesuaikan selera)
    # konsole                # Kalau kamu lebih suka terminal lain
    # kate                   # Kalau lebih suka VSCode/Neovim
    # gwenview               # Image viewer (kalau pakai lain)
  ];

  # ======================
  # Paket tambahan yang biasanya berguna
  # ======================
  environment.systemPackages = with pkgs; [
    # Utility KDE yang bagus
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kcolorchooser
    kdePackages.kolourpaint
    kdePackages.ksystemlog
    kdePackages.partitionmanager
    kdePackages.filelight          # disk usage
    kdePackages.ark                # archive manager
    kdePackages.okular             # PDF viewer (ini yang tadinya crash di GNOME)
    kdePackages.gwenview           # image viewer
    kdePackages.spectacle          # screenshot
    kdePackages.dolphin            # file manager (sudah include, tapi biar jelas)

    # Opsional tapi recommended
    kdePackages.kdeconnect-kde     # kalau mau connect ke HP
    # kdePackages.discover         # software center (kalau pakai flatpak)
  ];

  # ======================
  # Beberapa setting yang biasanya bagus
  # ======================
  programs.kdeconnect.enable = true;   # kalau kamu pakai KDE Connect

  # Biar clipboard history lebih bagus (opsional)
  # environment.sessionVariables = {
  #   # ...
  # };
}