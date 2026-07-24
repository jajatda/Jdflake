# modules/terminal.nix
{ config, pkgs, ... }: {

  # 1. Konfigurasi Alacritty
  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
      };
      font = {
        normal = { family = "FiraCode Nerd Font"; style = "Regular"; };
        size = 11.0;
      };
      window.opacity = 1;

      # Blok Warna Palet Resmi Everforest (Dark Medium)
      colors = {
        # Warna Utama (Latar Belakang & Teks Utama)
        primary = {
          background = "#2d353b";
          foreground = "#d3c6aa";
          dim_foreground = "#a7c080";
          bright_foreground = "#d3c6aa";
        };

        # Kursor Terminal
        cursor = {
          text = "#2d353b";
          cursor = "#d3c6aa";
        };

        # Seleksi Teks (Block Highlight)
        selection = {
          text = "#2d353b";
          background = "#d3c6aa";
        };

        # Palet Warna Standar (Normal)
        normal = {
          black = "#475258";
          red = "#e67e80";
          green = "#a7c080";
          yellow = "#dbbc7f";
          blue = "#7fbbb3";
          magenta = "#d699b6";
          cyan = "#83c092";
          white = "#d3c6aa";
        };

        # Palet Warna Terang (Bright)
        bright = {
          black = "#475258";
          red = "#e67e80";
          green = "#a7c080";
          yellow = "#dbbc7f";
          blue = "#7fbbb3";
          magenta = "#d699b6";
          cyan = "#83c092";
          white = "#d3c6aa";
        };
      };
    };
  };

  # 2. Konfigurasi Zsh Shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Tetap aktifkan Oh My Zsh untuk plugin bawaannya
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      # Jangan isi 'theme = "powerlevel10k"' di sini karena Nix tidak mendeteksinya secara global otomatis
    };

    # Memasukkan paket Powerlevel10k secara deklaratif melalui plugin Nix
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    # Memastikan file konfigurasi p10k dimuat saat terminal dibuka
    initContent = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };
}
