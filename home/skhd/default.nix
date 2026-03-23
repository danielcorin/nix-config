{ pkgs, lib, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  home.file.".skhdrc" = lib.mkIf isDarwin {
    source = ./skhdrc;
    force = true;
  };
}
