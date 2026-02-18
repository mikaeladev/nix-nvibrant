# nix-nvibrant

A lightweight flake providing a nixpkgs overlay and Home Manager/NixOS modules
for [nvibrant][nvibrant-repo].

## Installation

Add this repo to your flake's inputs and include the overlay to add `nvibrant`
to nixpkgs, like so:

```nix
# flake.nix

{
  inputs = {
    # [...]
    nvibrant = {
      url = "github:mikaeladev/nix-nvibrant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nvibrant, home-manager, ... }@inputs:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ nvibrant.overlays.default ];
      };
    in
    {
      # for NixOS, set the `pkgs` attribute here
      nixosConfigurations.yourpc = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        # if using home-manager with NixOS, also make sure to override `pkgs`
        # in `home-manager.extraSpecialArgs`
        # [...]
      };

      # for standalone home-manager, set the `pkgs` attribute here
      homeConfigurations.yourname = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # [...]
      };
    }
}
```

## Usage

> [!NOTE]
> This section explains how to use the nvibrant service, not nvibrant itself
> (see [nvibrant's README][nvibrant-usage] instead).

Add the following to your nix config:

```nix
# nvibrant.nix

{ inputs, ... }: {
  # use the other import for NixOS configs
  imports = [
    inputs.nvibrant.homeModules.default
    # inputs.nvibrant.nixosModules.default
  ];

  services.nvibrant = {
    # toggles the service on/off
    enable = true;

    # sets the vibrancy level for each monitor
    vibrancy = [
      "0%"    # greyscale
      "100%"  # normal
      "200%"  # doubled
    ];
  };
}
```

## License

This project is licensed under the terms of the GNU General Public License 3.0.
You can read the full license text in [LICENSE](./LICENSE).

[nvibrant-repo]: https://github.com/Tremeschin/nvibrant
[nvibrant-usage]: https://github.com/Tremeschin/nvibrant?tab=readme-ov-file#-usage
