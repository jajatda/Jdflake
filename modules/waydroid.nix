{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.custom.waydroid;
in {
  options.services.custom.waydroid = {
    enable = mkEnableOption "Deklaratif Waydroid Environment";
  };

  config = mkIf cfg.enable {
    # Mengaktifkan kontainer utama Waydroid
    virtualisation.waydroid.enable = true;

    # 2. AKTIFKAN LXC & KERNEL SETTING UNTUK JARINGAN KONTAINER
    # Waydroid berjalan di atas LXC, kita butuh opsi ini agar RTNETLINK diizinkan
    virtualisation.lxc.enable = true;
    
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };

    # 3. Konfigurasi Firewall agar memercayai vnic Waydroid
    networking.firewall = {
      enable = true;
      # Kita masukkan kedua kemungkinan nama interface jaringan Waydroid
      trustedInterfaces = [ "waybr0" "waydroid0" ];
    };


    # Memastikan modul kernel pembantu aktif (opsional namun direkomendasikan)
    boot.kernelModules = [ "ashmem_linux" "binder_linux" "tun" "tap"];

    # Mengotomatisasi sesi pengguna lewat systemd user service
    systemd.user.services.waydroid-session = {
      description = "Waydroid User Session Daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.waydroid}/bin/waydroid session start";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    # Memastikan audio PipeWire berjalan optimal untuk kontainer
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}