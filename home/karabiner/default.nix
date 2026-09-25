{ pkgs, ... }:

{
  home.file.".config/karabiner.edn" = {
    source = ./karabiner.edn;
    onChange = "${pkgs.goku}/bin/goku";
  };
}
