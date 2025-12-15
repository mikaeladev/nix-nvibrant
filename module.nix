{ isHomeModule ? false }:
{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkIf
    mkOption
    mkAliasOptionModule
    mkEnableOption
    mkPackageOption
    concatStringsSep
    getExe
    types
  ;

  cfg = config.services.nvibrant;

  script = pkgs.writeShellApplication {
    name = "nvibrant-apply";
    runtimeInputs = [ cfg.package ];
    text = ''
      ${if cfg.vibrancy != [] then "nvibrant ${concatStringsSep " " cfg.vibrancy}" else ""}
      ${if cfg.dithering != [] then "ATTRIBUTE=dithering nvibrant ${concatStringsSep " " cfg.dithering}" else ""}
    '';
  };

  service = {
    Unit = {
      Description = "Apply nvibrant";
      After = [ "graphical.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${getExe script}";
    };
    Install.WantedBy = [ "default.target" ];
  };
in
{
  imports = [
    (mkAliasOptionModule [ "services" "nvibrant" "arguments" ] [ "services" "nvibrant" "dithering" ])
  ];

  options.services.nvibrant = {
    enable = mkEnableOption "Enable nvibrant service";

    package = mkPackageOption pkgs "nvibrant" { };

    vibrancy = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "512" ];
      description = ''
        List of vibrancy levels to pass to nvibrant, ranging from `-1024`
        (greyscale) to `1023` (max saturation), matching the order of physical
        ports in your GPU.
      '';
    };

    dithering = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "1" ];
      description = ''
        List of dithering levels to pass to nvibrant, with `0` for auto,
        `1` for enable, and `2` (default) for disable, matching the order of
        physical ports in your GPU.
      '';
    };
  };

  config = mkIf cfg.enable (
    if isHomeModule then {
      home.packages = [ cfg.package ];
      systemd.user.services.nvibrant = service;
    } else {
      environment.systemPackages = [ cfg.package ];
      systemd.services.nvibrant = {
        enable = cfg.vibrancy != [] || cfg.dithering != [];
        wantedBy = service.Install.WantedBy;
        after = service.Unit.After;
        description = service.Unit.Description;
        serviceConfig = service.Service;
      };
    }
  );
}
