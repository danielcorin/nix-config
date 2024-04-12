{ config, pkgs, ... }:

{
  programs.eza = {
    enable = true;
    extraOptions = [ "--group-directories-first" ];
    icons = true;
    git = true;
  };

}
