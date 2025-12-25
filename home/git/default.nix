{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "Dan Corin";
      user.email = "dcorin6@gmail.com";
      branch.autosetuprebase = "always";
      color.ui = true;
      github.user = "danielcorin";
      push.default = "tracking";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}


