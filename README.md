Update configuration

```sh
darwin-rebuild switch --flake .
```

Install home-manager

```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

Resources that helped created this 🙏

- https://nixcademy.com/2024/01/15/nix-on-macos/
- https://davi.sh/til/nix/nix-macos-setup/
- https://github.com/mhanberg/.dotfiles/blob/73c03c941077e31d6e95336ac7973ad1a770b331/nix-darwin/flake.nix
- https://github.com/bphenriques/dotfiles/blob/0c73e2577b17960014526711d41a685a8b52c824/home/config/terminal/fzf/default.nix#L6
- https://flaky.build/native-fix-for-applications-hiding-under-the-macbook-pro-notch