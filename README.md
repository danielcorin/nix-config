# nix-darwin and Home Manager configuration

This repository contains my Apple Silicon macOS configuration. It lives at `~/.config/nix` and builds the `dcmbp` nix-darwin host together with the `danielcorin` Home Manager profile.

## Build and apply

Build first so evaluation and package failures happen before privileged activation:

```sh
darwin-rebuild build --flake .#dcmbp
sudo darwin-rebuild switch --flake .#dcmbp
```

Home Manager is imported as a nix-darwin module and is rebuilt with the system. It does not require a separate channel or `home-manager switch` installation ([Home Manager nix-darwin documentation](https://nix-community.github.io/home-manager/nix-flakes/nix-darwin.html)).

## Validate

The flake exposes `nixfmt-tree` as its formatter. Its checks build the complete `dcmbp` system closure and run `deadnix` and `statix` lints:

```sh
nix fmt
nix flake check
```

`nixfmt` is the official Nix formatter ([nixfmt documentation](https://github.com/NixOS/nixfmt#nix-fmt-experimental)). `nix flake check` evaluates and builds derivations exposed through `checks` ([Nix command reference](https://nix.dev/manual/nix/stable/command-ref/new-cli/nix3-flake-check.html)).

## Layout

- `flake.nix` wires pinned inputs, the `dcmbp` host, Home Manager, formatting, and checks.
- `hosts/dcmbp` contains host identity and compatibility settings.
- `modules/darwin` contains Homebrew, Nix daemon, and macOS system settings.
- `home` contains the user profile and program-specific configuration. `home/palette.nix` holds the Monokai colors shared by Ghostty and ccstatusline.

## Design notes

- `flake.lock` is committed so evaluations resolve the same input revisions ([Nix flakes documentation](https://nix.dev/concepts/flakes.html)). nix-darwin and Home Manager both follow the same Nixpkgs input.
- `system.stateVersion = 5` and `home.stateVersion = "23.11"` preserve compatibility with the releases that initialized the machine. They should not be raised merely because inputs are newer ([Home Manager upgrade guide](https://nix-community.github.io/home-manager/usage/upgrading.html)).
- The host targets `aarch64-darwin` only. No Intel `extra-platforms` compatibility is enabled.
- Nix builds use sandboxing, automatic job/core selection, and a `trusted-users` list containing only `root`. Nix warns that daemon trust is effectively root access ([Nix configuration reference](https://nix.dev/manual/nix/stable/command-ref/conf-file.html#conf-trusted-users), [sandbox setting](https://nix.dev/manual/nix/stable/command-ref/conf-file.html#conf-sandbox)).
- Garbage collection runs weekly and retains generations for 30 days; store optimization runs automatically. Explicit `Weekday` scheduling avoids launchd's calendar-day semantics ([Apple launchd scheduling documentation](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/ScheduledJobs.html), [Nix garbage-collection manual](https://nix.dev/manual/nix/stable/command-ref/nix-collect-garbage.html)).
- Homebrew activation does not update or upgrade packages implicitly. `cleanup = "uninstall"` converges installed packages without the application-data deletion performed by `zap` ([nix-darwin Homebrew options](https://nix-darwin.github.io/nix-darwin/manual/), [Homebrew Bundle documentation](https://docs.brew.sh/Brew-Bundle-and-Brewfile)).
- Home Manager owns most command-line tools and their configuration. Homebrew owns macOS app bundles, system integrations, and selected formulae. WezTerm's app comes from Homebrew while Home Manager owns its configuration.
- Homebrew installs `mise` to avoid building it from source through Nix; zsh activates it directly. The official mise guide documents Homebrew as a supported alternative installation ([mise installation guide](https://mise.jdx.dev/installing-mise.html#homebrew)).
- The macOS application firewall and stealth mode are enabled, and automatic macOS updates are allowed ([Apple firewall guide](https://support.apple.com/guide/mac-help/mh34041/mac), [Apple update guide](https://support.apple.com/guide/mac-help/mchlpx1065/mac)). FileVault and its recovery key remain outside version control ([Apple FileVault guide](https://support.apple.com/guide/mac-help/mh11785/mac)).

## Earlier inspiration

I use [GitHub Code Search](https://cs.github.com) to learn from configurations people have generously open-sourced. Helpful resources include:

- [Nixcademy: Nix on macOS](https://nixcademy.com/2024/01/15/nix-on-macos/)
- [David Teather: Nix macOS setup](https://davi.sh/til/nix/nix-macos-setup/)
- [mhanberg dotfiles](https://github.com/mhanberg/.dotfiles/blob/73c03c941077e31d6e95336ac7973ad1a770b331/nix-darwin/flake.nix)
- [bphenriques fzf configuration](https://github.com/bphenriques/dotfiles/blob/0c73e2577b17960014526711d41a685a8b52c824/home/config/terminal/fzf/default.nix#L6)
- [Native fix for apps under the MacBook Pro notch](https://flaky.build/native-fix-for-applications-hiding-under-the-macbook-pro-notch)
- [maxbrunet dotfiles](https://github.com/maxbrunet/dotfiles/)
- [malob nixpkgs configuration](https://github.com/malob/nixpkgs)
- [milogert tmux configuration](https://github.com/milogert/dotfiles-1/blob/925236213c09d19c091878b6f7070f90f99952fc/hosts/_common/darwin/tmux.nix)
- [Josean Martinez: SketchyBar setup](https://www.josean.com/posts/sketchybar-setup)
- [Martin Heinz: managing dotfiles with Nix](https://martinheinz.dev/blog/110)
- [davish setup](https://github.com/davish/setup/)
