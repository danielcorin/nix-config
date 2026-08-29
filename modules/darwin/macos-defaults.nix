{ pkgs, ... }:

{
  fonts.packages = [ pkgs.nerd-fonts.hack ];

  networking.applicationFirewall = {
    enable = true;
    enableStealthMode = true;
  };

  programs.zsh.enable = true;

  system.defaults = {
    dock = {
      orientation = "left";
      autohide = true;
      autohide-delay = 0.0;
      showhidden = true;
      show-recents = false;
      tilesize = 32;
      largesize = 48;
      magnification = true;
      mineffect = "suck";
      launchanim = false;
    };

    menuExtraClock.IsAnalog = true;
    screencapture.location = "~/Desktop";
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark";
      AppleFontSmoothing = 1;
      AppleShowScrollBars = "Always";
      NSAutomaticQuoteSubstitutionEnabled = false;
      InitialKeyRepeat = 18;
      KeyRepeat = 1;
      "com.apple.trackpad.scaling" = 1.0;
      "com.apple.sound.beep.feedback" = 0;
      _HIHideMenuBar = false;
    };

    trackpad.Clicking = true;
  };
}
