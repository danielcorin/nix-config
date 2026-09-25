{
  homebrew = {
    enable = true;
    enableZshIntegration = true;

    global.brewfile = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
      upgrade = false;
    };

    brews = [
      "ast-grep"
      "cloudflared"
      "colima"
      "create-dmg"
      "flyctl"
      "hcloud"
      "hledger"
      "jamescun/formulas/httplog"
      "jj"
      "just"
      "licenseplist"
      "llm"
      "mise"
      "nowplaying-cli"
      "ollama"
      "poppler"
      "repomix"
      "sdl2-compat"
      "koekeishiya/formulae/skhd"
      "koekeishiya/formulae/yabai"
      "sox"
      "gromgit/fuse/sshfs-mac"
      "sqlite3"
      "swiftformat"
      "switchaudio-osx"
      "temporal"
      "tctl"
      "whisper-cpp"
      "xcodegen"
      "wrangler"
    ];

    casks = [
      "font-sf-mono"
      "font-sf-pro"
      "ghostty"
      "google-chrome"
      "karabiner-elements"
      "keycastr"
      "macfuse"
      "sf-symbols"
      "wezterm"
    ];

    # Third-party taps used by the fully qualified formulae above.
    taps = [
      "anomalyco/tap"
      "gromgit/fuse"
      "jamescun/formulas"
      "koekeishiya/formulae"
    ];
  };
}
