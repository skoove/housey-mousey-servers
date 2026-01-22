{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    nh       # better rebuilds
    helix    # editor
    fish     # shell
    git
    zellij   # terminal multiplexer
  ];

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;

    users = {
      root = {
        hashedPassword = "$6$oa7.FzYRUz6urCFs$Jt383f5ET9EVQqktoVgEFlkZfkZWSFXmt1BaeWK/Yn4rxr7L1PvgNbXU0cwHURC9xi2QynDjTFfbmA/HArQ0A.";

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQVpPsMT/TM3XRDvhg662rUJ19PbB90FejdkYvtF8wj zie@nixos-desktop"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnGnBgccjncw0VMcpn/qjauAugKrTSzkIjLKssgVG9z zie@nixos-laptop"
        ];
      };
    
      zie = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
        hashedPassword = "$6$OlvFrwWdhd1VlHoC$kinv7.fERmkcwrDTg6e9QFFlAiL8Twd3.ljmB3yNLqS1wpb93hNVWJY6jglJYFJG/z/teAAGlqtrWquJX3rM21";

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQVpPsMT/TM3XRDvhg662rUJ19PbB90FejdkYvtF8wj zie@nixos-desktop"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnGnBgccjncw0VMcpn/qjauAugKrTSzkIjLKssgVG9z zie@nixos-laptop"
        ];
      };

      elaine = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
        hashedPassword = "$6$2xBM53.UM3/ivkcX$tZOSel6jN1tamWbPqOe80UZ/8xJnIv6k7ysslqQseX.X3rbbYlZtAShiEhrHhNiVzutb9/nvYAcWj8lHAd03q1S";
      };

      kobi = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
        hashedPassword = "$6$iWqc5nSn8eV7//PY$UukpD3VLSs41O7lBFtBlsUaD3iZjeYRvPyBvAshHqFH6bdKz1KOxS685l7/SM1tGwm54NZwMNGTM8p7xrcY/T.";
      };
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  security.sudo.wheelNeedsPassword = false; # needed for remote rebuilds :(

  programs.fish.enable = true;

  services.openssh.enable = true;
  services.tailscale.enable = true;

  environment = {
    shellAliases = { sys = "${lib.getExe pkgs.systemd-manager-tui}"; };

    sessionVariables = {
      EDITOR = "hx";
      COLORTERM = "truecolor";
    };
  };

  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };
  
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
  };

  nix.optimise = {
    automatic = true;
    persistent = true;
    dates = [ "18:00" ];
  };
  
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # DO NOT CHANGE EVER I WILL KILL YOU
  system.stateVersion = "26.05";
}
