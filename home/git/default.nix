{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = [
      "**/.claude/settings.local.json"
      ".DS_Store"
      "attic"
    ];
    settings = {
      user.name = "Dan Corin";
      user.email = "dcorin6@gmail.com";
      branch.autosetuprebase = "always";
      color.ui = true;
      github.user = "danielcorin";
      push.default = "tracking";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      core.pager = "hunk pager";
    };
  };
}


