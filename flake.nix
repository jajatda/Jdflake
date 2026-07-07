{
  description = "NixOS from Scratch";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs.url = "nixpkgs/nixos-25.11";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      # url = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix.url = "github:jacopone/antigravity-nix";

    # niri = {
    #   url = "github:sodiboo/niri-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # dms = {
    #   url = "github:AvengeMedia/DankMaterialShell/stable";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.x230t = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        ./modules/vm.nix
        ./modules/thinkfan.nix
        ./modules/auto-cpufreq.nix
        # {
        #   myLaptop.autoCpufreq = {
        #     enable = true;          # ini yang wajib
        #     aggressive = true;      # optional, default true sesuai module
        #   };
        # }
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.jd = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}