{
  description = "Golang Bristol";

  inputs = {
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, gomod2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        appName = "flix";
        version = "1.0.0";
        pkgs    = import nixpkgs {
          inherit system;
          overlays = [ gomod2nix.overlays.default ];
        };

        bin = pkgs.buildGoApplication {
            inherit version;
            pname       = appName;
            src         = ./.;
            modules     = ./gomod2nix.toml;
        };
        docker = pkgs.dockerTools.buildLayeredImage {
          name        = appName;
          tag         = version;
          config.Cmd  = "${bin}/bin/${appName}";
        };
      in
      {
        packages = {
          default = bin;
          inherit bin;
          inherit docker;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            go
            gopls
            golangci-lint
            delve
            gomod2nix.packages.${system}.default
          ];

          shellHook = ''
            echo "Go version: $(go version)"
            go run main.go
          '';
        };
      });
}


