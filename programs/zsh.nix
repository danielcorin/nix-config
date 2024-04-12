{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history = {
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      extended = true;
      size = 10000000;
      save = 10000000;
      share = true;
      ignorePatterns = [
        "(ls|cd|pwd|exit|mcd)*"
        "git commit *"
        "git clone *"
        "git add *"
        "history *"
      ];
    };
    initExtra = ''
      function mcd () {
        mkdir -p "$1" && cd "$1";
      }

      function now() {
        if [ $# -eq 0 ]; then
          date +%s;
        else
          date -d @$1;
        fi
      }

      eval "$(zoxide init zsh)"
    '';
    shellAliases = {
      dr = "darwin-rebuild switch --flake ~/.config/nix/flake.nix";
      h = "history";
      o = "open .";

      # ls
      ls = "eza --color=auto";
      sl = "eza --color=auto";
      ll = "eza -l --color=auto";
      "l." = "eza -la --color=auto";

      # git
      gs = "git status";
      gd = "git diff";
      gl = "git log";
      gds = "git diff --staged";
      gb = "git branch";
      gp = "git pull";
      ggm = "git checkout main";
      push = "git push origin $(git rev-parse --abbrev-ref HEAD)";

      # colorful cat
      cat = "bat";

      # python
      ea = ". env/bin/activate";
      # python3 is homebrew managed
      venv = "python -m venv .venv";

      # sqlite
      sqlite3 = "rlwrap sqlite3";

      # caffeinate
      caf = "pgrep caffeinate > /dev/null && echo '☕' || echo '💤'";
      tcaf = "pgrep caffeinate > /dev/null && kill $(pgrep caffeinate) || caffeinate -dim &";
    };
  };
}
