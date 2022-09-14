{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.utf8";
    LC_IDENTIFICATION = "fr_FR.utf8";
    LC_MEASUREMENT = "fr_FR.utf8";
    LC_MONETARY = "fr_FR.utf8";
    LC_NAME = "fr_FR.utf8";
    LC_NUMERIC = "fr_FR.utf8";
    LC_PAPER = "fr_FR.utf8";
    LC_TELEPHONE = "fr_FR.utf8";
    LC_TIME = "fr_FR.utf8";
  };

  services.xserver = {
    layout = "ca";
    xkbVariant = "multi";
    xkbOptions = "caps:escape";

    enable = true;
    autorun = true;
    displayManager.defaultSession = "none+awesome";
    windowManager.awesome.enable = true;
  };

  console.keyMap = "ca";

  users.users.chewie = {
    isNormalUser = true;
    description = "Chewie";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  security.polkit.enable = true;

  services.getty.autologinUser = "chewie";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  ];

  environment.pathsToLink = [ "/share/zsh" ];
  environment.shells = [ pkgs.zsh ];

  programs.zsh.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "chewie" ];
  };

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
