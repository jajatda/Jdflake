{ pkgs, config, ... }:

let
  # 1. Paket LaTeX kustom
  # my-texlive = pkgs.texlive.combine {
  #   inherit (pkgs.texlive)
  #     scheme-medium
  #     wrapfig
  #     polyglossia
  #     fontspec
  #     bidi
  #     arabi
  #     zref;
  # };

  my-texlive = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      # 1. Kerangka Dasar (Wajib)
      scheme-medium     # Berisi perintah dasar latex, pdflatex, xelatex, dan alat utama.

      # 2. Paket yang Sering Dipicu oleh Org-mode saat Export
      wrapfig           # Untuk penempatan gambar di sela-sela teks
      capt-of           # Menangani caption/keterangan pada tabel dan gambar (ini yang bikin error kemarin)
      hyperref          # Membuat link/pranala aktif di dalam PDF (daftar isi & catatan kaki bisa diklik)
      ulem              # Digunakan Org-mode untuk menangani teks bergaris bawah (_underline_) dan coret (+strike+)

      # 3. Kebutuhan Bahasa Arab & Font (XeLaTeX)
      fontspec          # Wajib untuk memuat font Arab sistem (seperti Amiri) di XeLaTeX
      bidi              # Mengatur arah teks kanan-ke-kiri (RTL) secara otomatis
      polyglossia       # Paket modern pengelolaan multibahasa (Arab & Indonesia/Inggris)
      arabi

      # 4. Kebutuhan Indeks, Catatan Kaki & Glosari
      zref              # Manajemen referensi halaman tingkat lanjut (dibutuhkan indeks/glosari)
      makeindex         # Program pembantu untuk mengurutkan kata indeks secara alfabetis

      titlesec
      koma-script
      ;
  };

  # 2. Package font Traditional Naskh dari file lokal Anda
  # traditional-naskh = pkgs.stdenv.mkDerivation {
  #   pname = "traditional-naskh-font";
  #   version = "1.0";
  #   # Anda bisa mengarahkan src ke folder lokal absolut di mana Anda menyimpan font Anda
  #   src = /path/ke/folder/font/anda; 
  #   installPhase = ''
  #     mkdir -p $out/share/fonts/truetype
  #     cp *.ttf *.otf $out/share/fonts/truetype/ 2>/dev/null || true
  #   '';
  # };
in
{
  environment.systemPackages = [
    pkgs.texstudio
    my-texlive
  ];

  # Memasang font ke sistem NixOS
  fonts.packages = [
    pkgs.amiri
    pkgs.noto-fonts
    # traditional-naskh
  ];

  # Memastikan font yang diinstal dikenali oleh fontconfig (sangat penting untuk XeLaTeX)
  fonts.fontDir.enable = true;
}