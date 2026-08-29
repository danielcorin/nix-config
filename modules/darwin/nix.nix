{ lib, ... }:

{
  nix.settings = {
    cores = 0;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    max-jobs = "auto";
    sandbox = true;
    trusted-users = lib.mkForce [ "root" ];
  };

  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 7;
      Hour = 3;
      Minute = 15;
    };
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;

  # Disabled after the builder crash-looped and continuously rebuilt its disk image.
  nix.linux-builder.enable = false;
}
