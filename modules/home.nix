{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    hm
    intersectLists
    mkIf
    platforms
    ;

  cfg = config.services.nvibrant;
in

{
  imports = [ ./options.nix ];

  config = mkIf cfg.enable {
    systemd.user.services = {
      apply-nvibrant = cfg.service;
    };

    assertions = [
      (hm.assertions.assertPlatform "services.nvibrant" pkgs (
        intersectLists platforms.x86_64 platforms.linux
      ))
    ];
  };
}
