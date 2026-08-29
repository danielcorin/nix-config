{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    # https://github.com/direnv/direnv/issues/73#issuecomment-392342423
    stdlib = ''
      export_function() {
        local name=$1
        local alias_dir=$PWD/.direnv/aliases
        mkdir -p "$alias_dir"
        PATH_add "$alias_dir"
        local target="$alias_dir/$name"
        if declare -f "$name" >/dev/null; then
          echo "#!$SHELL" > "$target"
          declare -f "$name" >> "$target" 2>/dev/null
          echo "$name \$*" >> "$target"
          chmod +x "$target"
        fi
      }
    '';
  };
}
