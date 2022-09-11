{ config, pkgs, dotfiles, ... }:
{
  home.username = "chewie";
  home.homeDirectory = "/home/chewie";
  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    htop
    wget
    curl
    rxvt-unicode
    python3
    vim_configurable
    universal-ctags
    most
    polkit_gnome
  ];

  xsession.enable = true;
  xsession.windowManager.awesome.enable = true;

  programs.zsh.enable = true;

  # Dotfiles

  home.file.".vimrc".source = "${dotfiles}/vim/.vimrc";
  home.file.".vim" = {
    source = "${dotfiles}/vim/.vim";
    recursive = true;
  };
  home.file.".Xresources".source = "${dotfiles}/X/.Xresources";
  home.file.".ctags".source = "${dotfiles}/ctags/.ctags";
  home.file.".inputrc".source = "${dotfiles}/readline/.inputrc";
  home.file.".gitconfig".source = "${dotfiles}/git/.gitconfig";
  home.file.".gitignore".source = "${dotfiles}/git/.gitignore";
  home.file.".zshrc".source = "${dotfiles}/zsh/.zshrc";

  xdg.configFile.awesome = {
    source = "${dotfiles}/awesome";
    recursive = true;
  };

  systemd.user.services = {
    polkit-gnome-authentication-agent-1 = {
      Unit = {
        After = [ "graphical-session-pre.target" ];
        Description = "polkit-gnome-authentication-agent-1";
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
        Type = "simple";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

}
