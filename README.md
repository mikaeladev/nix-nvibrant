[nvibrantRepo]: https://github.com/Tremeschin/nvibrant
[nvibrantUsage]: https://github.com/Tremeschin/nvibrant?tab=readme-ov-file#-usage

<!---->

# nix-nvibrant

A lightweight flake providing a nixpkgs overlay and Home Manager/NixOS modules
for [nvibrant][nvibrantRepo].

## Installation

Add this repo to your flake's inputs and include the overlay to add `nvibrant`
to nixpkgs, like so:

```nix
# flake.nix

{
  # [...]

  inputs = {
    # [...]

    nvibrant = {
      url = "github:mikaeladev/nix-nvibrant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, nvibrant, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nvibrant.overlays.default ];
      };
    in
    {
      # for NixOS, set the `pkgs` attribute here
      nixosConfigurations = nixpkgs.lib.nixosSystem {
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
> (see [nvibrant's README][nvibrantUsage] instead).

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

    # sets the vibrancy level for each output
    vibrancy = [
      "-1024" # greyscale
      "1023" # +200% saturation
      # ...
    ];

    # likewise sets the dithering level for each output
    dithering = [
      "0" # auto
      "1" # enabled
      "2" # disabled
    ];
  };
}
```

## License

This project is licensed under the terms of the GNU General Public License 3.0.
You can read the full license text in [LICENSE](./LICENSE).
