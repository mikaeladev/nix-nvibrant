{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.services.nvibrant;
in

{
  imports = [ ./options.nix ];

  config = mkIf cfg.enable {
    systemd.user.services = {
      apply-nvibrant = with cfg.service; {
        enable = true;
        after = Unit.After;
        description = Unit.Description;
        serviceConfig = Service;
        wantedBy = Install.WantedBy;
      };
    };

    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
        message = "The 'services.nvibrant' module only supports x86_64-linux";
      }
    ];
  };
}
