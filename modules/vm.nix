{ config, pkgs, ... }:

{
  # Mengaktifkan dconf (diperlukan oleh virt-manager untuk menyimpan setting)
  programs.dconf.enable = true;

  # Paket yang diperlukan
  environment.systemPackages = with pkgs; [
    qemu
    qemu_kvm
    virt-manager
    virt-viewer
    bridge-utils
    libguestfs 
    virtiofsd # Tambahkan ini agar binary tersedia di system path
  ];

  # Mengaktifkan daemon libvirtd
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      # Menggunakan qemu_kvm sudah benar, atau pkgs.qemu_full untuk fitur lengkap
      package = pkgs.qemu_kvm;
      
      # Memberitahu libvirt di mana mencari binary untuk sharing folder
      vhostUserPackages = [ pkgs.virtiofsd ]; 
      
      # Sangat disarankan untuk Windows 10 modern agar aspek rasio & boot lebih stabil
      # ovmf = {
      #   enable = true;
      #   packages = [ pkgs.OVMFFull.fd ];
      # };

      runAsRoot = true;
    };
  };

  # Menambahkan user ke group libvirtd agar bisa menjalankan VM tanpa sudo
  users.users.jd.extraGroups = [ "libvirtd" "kvm" ];

  # Optimasi untuk CPU Intel (ThinkPad X230t menggunakan Intel Core i5/i7)
  boot.extraModprobeConfig = "options kvm_intel nested=1";
}