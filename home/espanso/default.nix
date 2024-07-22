{ config, lib, pkgs, ... }:

{
  services.espanso = {
    enable = true;
    matches = {
        abbreviations = {
            matches = [
                {
                    trigger = "tbh";
                    replace = "to be honest";
                }
                {
                    trigger = "btw";
                    replace = "by the way";
                }
                {
                    trigger = "afaik";
                    replace = "as far as I know";
                }
                {
                    trigger = "pls";
                    replace = "please";
                }
                {
                    trigger = "iirc";
                    replace = "if I recall correctly";
                }
            ];
        };
    };
  };
}
