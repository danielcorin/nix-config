{ pkgs, lib, ... }:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  home.file.".skhdrc" = lib.mkIf isDarwin {
    source = ./skhdrc;
    force = true;
  };

  # skhd resolves ~/.skhdrc to its Nix store target at startup. Reloading would
  # keep reading the old target after Home Manager replaces the symlink, so
  # restart the service after the new generation has been linked.
  home.activation.restartSkhd = lib.mkIf isDarwin (
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      if [[ -x /opt/homebrew/bin/skhd ]]; then
        /opt/homebrew/bin/skhd --restart-service || true
      fi
    ''
  );
}
