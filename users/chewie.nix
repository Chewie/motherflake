{ config, pkgs, dotfiles, ... }:
{
  home.username = "chewie";
  home.homeDirectory = "/home/chewie";
  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    htop
    wget
    rxvt-unicode
    python3
    vim_configurable
    universal-ctags
    most
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

}
