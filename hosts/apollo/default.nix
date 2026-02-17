{ pkgs, config,  ... }: {
  imports = [ ./hardware.nix ];
  
  networking.hostName = "apollo";

  networking.firewall.allowedTCPPorts = [
    7000 # miniflux
    9123 # firefly-iii
    8384 # syncthing
    27015 # steam servers
    80 443
  ];

  networking.firewall.allowedUDPPorts = [
    27015 3478 3479 3480# steam servers
    7777 7778 # nuclear option
  ];

  networking.firewall.allowedUDPPortRanges = [
    # steam servers
    { from =27014; to =27030;}
  ];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.audiobookshelf = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
  };

  services.miniflux = {
    enable = true;
    config = {
      CREATE_ADMIN = 0;
      FETCH_NEBULA_WATCH_TIME = 1;
      FETCH_ODYSEE_WATCH_TIME = 1;
      LISTEN_ADDR = "0.0.0.0:7000";
    };
  };

  services.transmission = {
    package = pkgs.transmission_4;
    enable = true;
    openFirewall = true;
    openRPCPort = true;
    serviceConfig = {
      ReadWritePaths = [
        "/mnt/data/jellyfin"
      ];
    };
    
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false;
      download-dir = "/mnt/data/jellyfin";
      incomplete-dir = "/var/lib/transmission/.incomplete";
      incomplete-dir-enabled = true;
    };
  };

  services.firefly-iii = {
    enable = true;
    settings = {
      APP_KEY_FILE = "/firefly-key-file";
      TRUSTED_PROXIES= "**";
    };
    enableNginx = true;
    virtualHost = "0.0.0.0";
  };

  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
    openDefaultPorts = true;
  };

  users.users.steam = {
    isNormalUser = true;
    description = "steam";
    hashedPassword = "$6$MrRpNZYZst7X/2mj$Gcq4RzrltyvNt19zdaHi1PETcnxChzauo.5NpPruiUTkxqcJ592MpyzUuMrpZ8xARjLlkEaerIx8d/rtOJ4K9.";
    packages = [
      pkgs.steamcmd pkgs.steam-run
    ];
  };

  users.users.minecraft = {
    isNormalUser = true;
    description = "minecraft";
    hashedPassword = "$6$BbvJY8EJrVm6Ng9c$QoQycQkW7hbkWLuoOVFaXN4PFTM0ffFU/XYgjoimLt0Bhqp8xCIAEOC1PtMqtOYpprTyvb2oYiaAhydGGaUEc.";
  };
}
