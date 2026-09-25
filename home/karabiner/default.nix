{ pkgs, lib, ... }:

{
  home.file.".config/karabiner.edn".source = ./karabiner.edn;

  # Regenerate karabiner.json on every switch so it can't drift from the edn.
  home.activation.goku = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ${pkgs.goku}/bin/goku
  '';
}
