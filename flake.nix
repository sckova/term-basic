{
  description = "Standalone Home Manager setup";

  inputs = {
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };

    nixpkgs.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/*";

    term = {
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };

      url = "github:sckova/term";
    };
  };

  outputs =
    {
      home-manager,
      nixpkgs,
      term,
      ...
    }:
    let
      mkHome =
        system: user: home:
        home-manager.lib.homeManagerConfiguration {
          modules = [
            term.homeModules.default
            {
              home = {
                homeDirectory = home + user;
                stateVersion = "26.05";
                username = user;
              };

              programs.home-manager.enable = true;
            }
          ];

          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        };
    in
    {
      homeConfigurations = {
        "sckova@asahi" = mkHome "aarch64-linux" "sckova" "/home/";
        "sckova@desktop" = mkHome "x86_64-linux" "sckova" "/home/";
        "sckova@macbook" = mkHome "aarch64-darwin" "sckova" "/Users/";
      };
    };
}
