# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot"; };
    grub = {
       efiSupport = true;
       useOSProber = true;
       device = "nodev"; };
  };

  networking = {
    hostName = "mundus";
    firewall = { enable = false; }; 
    networkmanager = { enable = true; };
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    packages=[ pkgs.terminus_font ];
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nano
    brave
    wget
    neofetch
    gnome.nautilus
    gnome.eog
    gnome.gedit
    gnome.gnome-tweaks
    gnome.gnome-disk-utility
    gnome.gnome-terminal
    gnome-browser-connector
    docker
    qemu
    virt-manager
    virt-viewer
    distrobox
    rsync
    imagemagick
    libreoffice-still
    fzf
    zip
    unzip
    unrar
    p7zip
    ntfs3g
    dosfstools
    git
    curl
    evince
    ffmpeg
    sxiv
    mpv
    emacs-nox
    pass
    vscodium
    zsh-syntax-highlighting
    zsh-autosuggestions
  ];

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      (nerdfonts.override { fonts = [ "Meslo" ]; }) ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
        serif = [ "Noto Serif" "Source Han Serif" ];
        sansSerif = [ "Noto Sans" "Source Han Sans" ]; };
    };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.core-utilities.enable = false;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable Virtualisation support
  virtualisation = {
    docker = { enable = true; };
    libvirtd = { enable = true; };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services = {
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      allowSFTP = true; };
    sshd.enable = true;
    #printing.enable = true; 
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.error = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    shell = pkgs.zsh;
  };

  # Nix daemon config
  nix = {
    # Flakes settings
    package = pkgs.nixVersions.stable;

    settings = {
      # Automate `nix store --optimise`
      auto-optimise-store = true;

      # Required by Cachix to be used as non-root user
      trusted-users = [ "root" "error" ];

      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;

      # Binary caches
      #substituters = [
      #  "https://cache.nixos.org"
      #  "https://cache.garnix.io"
      #  "https://gvolpe-nixos.cachix.org"
      #];
      #trusted-public-keys = [
      #  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      #  "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      #  "gvolpe-nixos.cachix.org-1:0MPlBIMwYmrNqoEaYTox15Ds2t1+3R+6Ycj0hZWMcL0="
      #];

      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
