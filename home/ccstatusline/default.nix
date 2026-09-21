{ lib, pkgs, ... }:

let
  # ccstatusline is not in nixpkgs. The npm tarball ships a single bundled
  # JavaScript file with no runtime dependencies, so wrap it with Node directly.
  ccstatusline = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "ccstatusline";
    version = "2.2.30";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/ccstatusline/-/ccstatusline-${finalAttrs.version}.tgz";
      hash = "sha512-5pzYEFjag+oRAI8udChxiN3lKFtzcHhu8KAsEP3T/wU6u3DsT0QJ3fAL2J4Cr+eo9AqRalqvP4sYpDguzn/1HQ==";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/ccstatusline $out/bin
      cp dist/ccstatusline.js package.json $out/lib/ccstatusline/
      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/ccstatusline \
        --add-flags "$out/lib/ccstatusline/ccstatusline.js"
      runHook postInstall
    '';

    meta = {
      description = "Customizable status line formatter for Claude Code";
      homepage = "https://github.com/sirmalloc/ccstatusline";
      license = pkgs.lib.licenses.mit;
      mainProgram = "ccstatusline";
    };
  });
  # Nerd Font glyphs are written as code points so this file stays readable in
  # editors without the font. Hack Nerd Font is the terminal font everywhere
  # here (home/ghostty, home/alacritty, home/wezterm), so they all render.
  glyph = hex: builtins.fromJSON ''"\u${hex}"'';

  # Monokai, matching the palette in home/ghostty.
  pink = "hex:F92672";
  orange = "hex:FD971F";
  yellow = "hex:E6DB74";
  green = "hex:A6E22E";
  cyan = "hex:66D9EF";
  purple = "hex:AE81FF";
  blue = "hex:819AFF";
  grey = "hex:75715E";

  # Widget padding is a single trailing space, so the bar carries its own
  # trailing space to render as "a | b".
  sep = {
    type = "separator";
    character = glyph "2502" + " ";
    color = grey;
  };

  # Prefix a widget with a glyph. Only a handful of widgets take a symbol
  # natively (git branch, cwd, worktrees); for the rest emit a custom-symbol
  # merged into the value. `merge` suppresses the separator between the two,
  # and the hide state drops the glyph whenever the value renders nothing.
  icon = hex: widget: [
    {
      type = "custom-symbol";
      customSymbol = glyph hex;
      color = widget.color;
      merge = true;
      metadata.hide = "merge-target-hidden";
    }
    (widget // { rawValue = true; })
  ];

  # Put a separator before every widget whose predecessor is not merged into it.
  joinWidgets =
    widgets:
    lib.concatLists (
      lib.imap0 (
        i: w:
        if i > 0 && !((builtins.elemAt widgets (i - 1)) ? merge) then
          [
            sep
            w
          ]
        else
          [ w ]
      ) widgets
    );

  # Every item needs an id; they only have to be unique.
  withIds =
    lines:
    (lib.foldl'
      (acc: line: {
        n = acc.n + builtins.length line;
        out = acc.out ++ [ (lib.imap0 (i: w: w // { id = toString (acc.n + i); }) line) ];
      })
      {
        n = 1;
        out = [ ];
      }
      lines
    ).out;

  # Where am I. The git group sits last because its trailing widgets disappear
  # in a clean or upstream-less repo, and ccstatusline drops the separator that
  # would follow a merge group with an empty tail; at the end of the line that
  # is invisible rather than a stray bar mid-line.
  whereLine = joinWidgets (
    [
      {
        type = "worktree-mode";
        color = blue;
        character = glyph "f126";
      }
      {
        type = "model";
        color = cyan;
        rawValue = true;
      }
    ]
    ++ icon "f0eb" {
      type = "thinking-effort";
      color = purple;
    }
    ++ [
      {
        type = "current-working-dir";
        color = green;
        rawValue = true;
        character = glyph "f07b";
        metadata = {
          abbreviateHome = "true";
          segments = "2";
        };
      }
      {
        type = "git-branch";
        color = pink;
        # rawValue would suppress `character`; this widget has no text label.
        character = glyph "e0a0";
        merge = true;
        metadata.linkToRepo = "true"; # OSC 8 link to the branch on the remote
      }
      {
        type = "git-status"; # + staged, * unstaged, ? untracked, ! conflicts
        color = orange;
        merge = true;
        metadata.hide = "no-git";
      }
      {
        type = "git-ahead-behind";
        color = yellow;
        metadata.hide = "no-git,no-upstream";
      }
    ]
  );

  # What it is costing.
  costLine = joinWidgets (
    icon "f0e4" {
      type = "context-bar";
      color = purple;
      metadata.display = "progress-short"; # 16-cell bar + used/total + %
    }
    ++ icon "f155" {
      type = "session-cost";
      color = yellow;
    }
    ++ icon "f017" {
      type = "block-timer";
      color = orange;
      metadata.compact = "true"; # "2h5m" rather than "2hr 5m"
    }
    ++ icon "f01e" {
      type = "reset-timer";
      color = blue;
      metadata.compact = "true";
    }
    ++ icon "f0e7" {
      type = "session-usage";
      color = pink;
    }
    ++ icon "f133" {
      type = "weekly-usage";
      color = cyan;
    }
  );
in
{
  home.packages = [ ccstatusline ];

  # ccstatusline reads this fixed path; the TUI cannot save over it because it
  # is a read-only store symlink, so edit this file to change the status line.
  #
  # Colors must be a named color, "ansi256:N", or "hex:RRGGBB". A bare
  # "#RRGGBB" is silently dropped and the widget renders uncolored.
  xdg.configFile."ccstatusline/settings.json".text = builtins.toJSON {
    version = 4;
    lines = withIds [
      whereLine
      costLine
      [ ]
    ];

    # "full" uses the whole terminal width; Claude Code is configured with
    # statusLine.padding = 0, so nothing needs to be held back.
    flexMode = "full";
    compactThreshold = 60;
    colorLevel = 3; # truecolor
    defaultPadding = " ";
    defaultPaddingSide = "right";
    inheritSeparatorColors = false;
    globalBold = false;
    minimalistMode = false;

    numberFormat = {
      percent.style = "whole"; # 57% rather than 57.0%
      token.style = "compact"; # 128k rather than 128,000
      cost = {
        style = "precise";
        decimals = 2;
      };
    };

    gitCacheTtlSeconds = 5;
    terminalWidthCacheTtlSeconds = 5;
    customCommandCacheTtlSeconds = 0;

    powerline.enabled = false;
  };
}
