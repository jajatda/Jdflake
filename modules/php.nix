# modules/php.nix
{ config, pkgs, webdev, ... }:

let
  # Merakit PHP kustom beserta ekstensinya
  myPhp = webdev.php84.buildEnv {
    extensions = { enabled, all }: enabled ++ (with all; [
      bcmath
      curl
      dom
      fileinfo
      filter
      gd
      mbstring
      openssl
      pdo
      pdo_mysql
      zip
    ]);
    extraConfig = ''
      memory_limit = 2G
    '';
  };

  # Menyelaraskan Composer dengan PHP kustom di atas
  myComposer = webdev.php84Packages.composer.override { php = myPhp; };
in
{
  # Paket-paket yang akan dipasang ke sistem jika modul ini aktif
  environment.systemPackages = [
    myPhp
    myComposer
    pkgs.git
    pkgs.unzip
  ];
}