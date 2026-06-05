{
  description = "Configure NVIDIA's Digital Vibrance on Wayland";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, treefmt, ... }:

    let
      eachSystem = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];

      mkTreefmtEval =
        system: treefmt.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix;
    in

    {
      formatter = eachSystem (system: (mkTreefmtEval system).config.build.wrapper);

      homeModules = rec {
        default = nvibrant;
        nix-nvibrant = nvibrant;
        nvibrant = import ./modules/home.nix;
      };

      nixosModules = rec {
        default = nvibrant;
        nix-nvibrant = nvibrant;
        nvibrant = import ./modules/nixos.nix;
      };
    };
}
