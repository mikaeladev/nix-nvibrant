{
  description = "Configure NVIDIA's Digital Vibrance on Wayland";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, treefmt, ... }:

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      treefmtEval = treefmt.lib.evalModule pkgs ./treefmt.nix;
    in

    {
      formatter.${system} = treefmtEval.config.build.wrapper;

      homeModules = rec {
        default = nvibrant;
        nix-nvibrant = nvibrant;
        nvibrant = import ./module.nix;
      };

      nixosModules = rec {
        default = nvibrant;
        nix-nvibrant = nvibrant;
        nvibrant = import ./module.nix;
      };

      packages.${system} = rec {
        default = nvibrant;
        nvibrant = import ./default.nix { inherit pkgs; };
      };

      overlays = rec {
        default = nvibrant;
        nvibrant = final: _: { nvibrant = import ./default.nix { pkgs = final; }; };
      };
    };
}
