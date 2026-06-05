# nix-nvibrant

A lightweight flake providing Home Manager & NixOS modules for
[nvibrant][nvibrant-repo].

## Installation

Add this repo to your flake's inputs like so:

```nix
# flake.nix

{
  inputs = {
    # [...]
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nvibrant = {
      url = "github:mikaeladev/nix-nvibrant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nvibrant, home-manager, ... }: {
      nixosConfigurations.PC_NAME = nixpkgs.lib.nixosSystem {
        # [...]
        modules = [
          nvibrant.nixosModules.default
          # [...]
        ];
      };

      homeConfigurations.USER_NAME = home-manager.lib.homeManagerConfiguration {
        # [...]
        modules = [
          nvibrant.homeModules.default
          # [...]
        ];
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

{
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
