{
  description = "NixOS from Scratch";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-2511.url = "github:NixOS/nixpkgs/2c3e5ec5df46d3aeee2a1da0bfedd74e21f4bf3a";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      # url = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager/release-26.05";
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

  outputs = { self, nixpkgs, nixpkgs-2511, nixpkgs-unstable, home-manager, ... }@inputs: {
    nixosConfigurations.x230t = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { 
        inherit inputs; 

        pkgs-2511 = import nixpkgs-2511 {
            system = "x86_64-linux";
            config.allowUnfree = true;
        };

        pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
        };
      };
      modules = [
        ./configuration.nix
        {
          nixpkgs.overlays = [
            (final: prev: {

              # Override default packages with specific versions from nixpkgs-2511
              obs-studio = (import nixpkgs-2511 { 
                system = "x86_64-linux";
                config.allowUnfree = true;
              }).obs-studio;

              steam = (import nixpkgs-2511 { 
                system = "x86_64-linux";
                config.allowUnfree = true;
              }).steam;

            })
          ];
        }
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