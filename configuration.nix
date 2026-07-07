{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 1. Daftarkan Swap File agar aktif saat boot
  swapDevices = [ {
    device = "/swapfile";
    size = 16384; # Dalam MB
  } ];

  # 2. Tentukan Resume Device (UUID Partisi tempat swapfile berada)
  # dapatkan UUID findmnt -no SOURCE,UUID -T /swapfile
  # dapatkan offset sudo filefrag -v /swapfile | awk '{if($1=="0:") print $4}'
 boot.resumeDevice = "/dev/disk/by-uuid/845841e2-709a-4ce9-a79d-80b11839875a";

  # 3. Berikan Kernel Parameter (UUID dan Offset)
 boot.kernelParams = [ 
   "resume=UUID=845841e2-709a-4ce9-a79d-80b11839875a"
   "resume_offset=9414656"
  ];

  networking.hostName = "x230t";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Cairo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = false;
    wayland.enable = true;
  };

  # programs.hyprland.enable = true;
  # programs.niri.enable = true;

  # services.xserver.windowManager.dwm.enable = true;
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.slick = {
        enable = true;

          draw-user-backgrounds = false;
          extraConfig = ''
            background=${./wallpaper.jpg}
            theme-name=Adwaita-dark
            icon-theme-name=Papirus
            font-name=Ubuntu 11
            cursor-theme-name=Adwaita
            draw-grid=false
          '';
    };
  };
  services.xserver.windowManager.dwm = {
    enable = false;
    package = pkgs.dwm.overrideAttrs {
      src = ./config/dwm;
    };
  };
  services.xserver.desktopManager.xfce.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;

  # services.desktopManager.lomiri.enable = true;
  # services.displayManager.defaultSession = "lomiri";


  # services.displayManager.ly.enable = true;
  # services.xserver = {
  #   enable = true;
  #   autoRepeatDelay = 200;
  #   autoRepeatInterval = 35;
  #   windowManager.qtile.enable = true;
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jajatda = {
  #   isNormalUser = true;
  #   description = "Jajat Darajat";
  #   extraGroups = [ "networkmanager" "wheel" ];
  #   packages = with pkgs; [];
  # };

  programs.adb.enable = true;

  users.users.jd = {
    isNormalUser = true;
    # uid = 1000;
    description = "jd";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;
  # programs.dms-shell.enable = true;
  programs.ssh.startAgent = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    rsync
    alacritty
    kitty
    wofi
    gnome-keyring
    seahorse
    gparted
    thinkfan
    # auto-cpufreq

    file-roller
    unrar
    strawberry
    flac

    brightnessctl
    vscode
    firefox
    cava
    ranger
    st
    dmenu
    feh
    neofetch
    pfetch
    ntfs3g
    p7zip


    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc

    #theme
    papirus-icon-theme
    adwaita-icon-theme
    gnome-themes-extra


    wineWowPackages.stableFull     # ← paling direkomendasikan (stable + full dependencies)
    # atau kalau mau versi experimental:
    # wineWowPackages.stagingFull
    # wineWowPackages.unstableFull   # biasanya lebih baru

    winetricks                     # sangat berguna untuk install font, directx, vcrun, dll
  
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
   programs.steam.enable = true;

   programs.obs-studio = {
    enable = true;
    # Optional: Enable Nvidia hardware acceleration
    package = (pkgs.obs-studio.override { cudaSupport = true; });
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs           # Wayland screen capture
      obs-vaapi        # VA-API hardware encoding
      obs-vkcapture    # Vulkan game capture
      obs-pipewire-audio-capture
    ];
  };


  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    amiri
    noto-fonts
  ];

  fonts.fontconfig = {
    enable = true;

    # aturan custom
    localConf = ''
      <match>
        <test name="script" compare="eq">
          <string>arab</string>
        </test>
        <edit name="family" mode="assign" binding="strong">
          <string>Amiri</string>
        </edit>
      </match>
    '';
  };

  services.samba = {
    enable = true;
    # Hapus 'securityType' jika menyebabkan eror, karena sekarang masuk ke 'settings'
    
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnixos";
        "netbios name" = "smbnixos";
        "security" = "user";
        "hosts allow" = "192.168.122. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      public = {
        "path" = "/home/jd/Public"; # Pastikan path ini sesuai
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };


  # myLaptop.thinkfan.enable = true;
  myLaptop.autoCpufreq.enable = true;
  myLaptop.autoCpufreq.aggressive = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";

}
