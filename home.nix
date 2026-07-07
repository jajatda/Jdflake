{ config, pkgs, ... }:

{
  home.username = "jd";
  home.homeDirectory = "/home/jd";
  # programs.git.enable = true;
  home.stateVersion = "25.05";
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
  };
  # imports = [
  #   inputs.niri.homeModules.niri
  # ];

  home.packages = with pkgs; [
    evince
    vlc
    xournalpp
    # apacheOpenOffice
  ];

  # Pastikan module git diaktifkan
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "jajatda";
        email = "jajatd4r@gmail.com";
      };

      commit.gpgSign = true;
      gpg.format = "ssh";
      user.signingKey = "/home/jd/.ssh/id_ed25519.pub";
      
      init.defaultBranch = "main";
      safe.directory = "*"; # Berguna agar git tidak error di direktori flake
      pull.rebase = true;

      # Alias opsional untuk efisiensi
      alias = {
        lg = "log --graph --oneline --decorate --all";
        s = "status";
      };
    };
    

  };
}