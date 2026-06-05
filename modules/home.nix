{ config, lib, ... }:

let
  inherit (lib) mkIf;

  cfg = config.services.nvibrant;
in

{
  imports = [ ./options.nix ];

  config = mkIf cfg.enable {
    systemd.user.services = {
      apply-nvibrant = cfg.service;
    };
  };
}
