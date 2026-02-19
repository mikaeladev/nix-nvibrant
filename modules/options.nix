{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    all
    assertMsg
    escapeShellArgs
    floor
    getExe
    map
    match
    mkEnableOption
    mkIf
    mkOption
    mkOptionType
    mkPackageOption
    removeSuffix
    toInt
    toList
    types
    warn
    ;

  clampMax = x: y: if x > y then y else x;

  warnDeprecated =
    old: new: warn "The '${old}' option is deprecated, use '${new}' instead.";

  percentStr = mkOptionType {
    inherit (types.str) merge;
    name = "percentStr";
    description = "percentage string";
    descriptionClass = "noun";
    check = x: types.str.check x && match "[0-9]([0-9]+)?%" x != null;
  };

  cfg = config.services.nvibrant;
in

{
  options.services.nvibrant = {
    enable = mkEnableOption "nvibrant";

    package = mkPackageOption pkgs "nvibrant" { };

    vibrancy = mkOption {
      type = with types; either percentStr (listOf percentStr);
      apply = (x: map (x: toInt (removeSuffix "%" x)) (toList x));
      default = [ ];
      example = [ "125%" ];
      description = ''
        The vibrancy level for your monitor(s).

        Applies in the order of physical ports on your GPU. Only accepts values
        ranging from 0% to 200% with 100% as the baseline.
      '';
    };

    arguments = mkOption {
      type = with types; nullOr (listOf str);
      default = null;
      visible = false;
      example = [ "512" ];
      description = ''
        List of vibrancy levels to pass to nvibrant, ranging from `-1024`
        (greyscale) to `1023` (max saturation), matching the order of physical
        ports in your GPU.
      '';
    };

    service = mkOption {
      type = (pkgs.formats.systemd { }).type;
      default = { };
      internal = true;
    };
  };

  config =
    let
      pkgExe = getExe cfg.package;

      vibrancyLevels =
        assert assertMsg (all (x: x >= 0 && x <= 200) cfg.vibrancy)
          "The 'services.nvibrant.vibrancy' option only accepts values ranging from 0% to 200%";
        if cfg.arguments != null then
          warnDeprecated "services.nvibrant.arguments" "services.nvibrant.vibrancy"
            cfg.arguments
        else
          map (x: clampMax (floor (10.24 * x - 1024)) 1023) cfg.vibrancy;

      serviceScript = pkgs.writeShellScript "apply-nvibrant" ''
        ${pkgExe} ${escapeShellArgs vibrancyLevels}
      '';
    in
    mkIf cfg.enable {
      services.nvibrant.service = {
        Unit = {
          Description = "Applies nvibrant";
          After = [ "graphical.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${serviceScript}";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
}
