{ ... }:

let
  lineWidth = 80;
in

{
  projectRootFile = "flake.nix";

  programs.nixfmt = {
    enable = true;
    strict = true;
    indent = 2;
    width = lineWidth;
  };

  programs.mdformat = {
    enable = true;
    settings.wrap = lineWidth;
    plugins = ps: [
      ps.mdformat-gfm
      ps.mdformat-gfm-alerts
    ];
  };
}
