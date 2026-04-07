{ pkgs, config,  ... }: {
  imports = [ ./hardware.nix ];
  
  networking.hostName = "apollo";

  networking.firewall.allowedTCPPorts = [
    7000 # miniflux
    9123 # firefly-iii
    8384 # syncthing
    27015 # steam servers
    80 443 # web servers
  ];

  networking.firewall.allowedUDPPorts = [
    27015 3478 3479 3480# steam servers
    7777 7778 # nuclear option
  ];

  networking.firewall.allowedUDPPortRanges = [
    # steam servers
    { from =27014; to =27030;}
  ];

  users.groups = {
    # give all services ( and users ) that need it the data group for access to /mnt/data
    data.members = [
      "zie" "elaine" "kobi" # users (mmm kobi's services.,,,, mayb these are services...)

      # services
      "transmission"
      "jellyfin"
      "audiobookshelf"
      "calibre"
    ];
  };

  systemd.services.dataPermissions = {
    description = "set /mnt/data/ ownsership and perms";
    after = [ "users-groups.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      # set all files and directorys to be data group and rwxrwxr-x
      # also setgid bit on dirs 
      find /mnt/data -type d -exec chgrp data {} \;
      find /mnt/data -type d -exec chmod 2775 {} \;

      # set all files to be data group and rw-rw-r--
      find /mnt/data -type f -exec chgrp data {} \;
      find /mnt/data -type f -exec chmod 664 {} \;
    '';
  };

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
    adminCredentialsFile = pkgs.writeText "miniflux-admin-creds" ''
      ADMIN_USERNAME=zie
      ADMIN_PASSWORD=SuperSecurePassword
    '';
    config = {
      CREATE_ADMIN = 1;
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
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false;
      download-dir = "/mnt/data/jellyfin";
      incomplete-dir = "/var/lib/transmission/.incomplete";
      incomplete-dir-enabled = true;
    };
  };

  # ensure transmission is able to access what it needs
  systemd.services.transmission.serviceConfig = {
    ReadWritePaths = [
      "/mnt/data/"
    ];
  };

  services.firefly-iii = {
    enable = true;
    settings = {
      APP_KEY_FILE = "/firefly-key-file";
      TRUSTED_PROXIES= "**";
      TZ = "Australia/Brisbane";
    };
    enableNginx = true;
    virtualHost = "0.0.0.0";
  };

  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
    openDefaultPorts = true;
  };

  services.calibre-web = {
    enable = true;
    openFirewall = true;
    listen.ip = "0.0.0.0";
  };

  users.users.minecraft = {
    isNormalUser = true;
    description = "minecraft";
    hashedPassword = "$6$BbvJY8EJrVm6Ng9c$QoQycQkW7hbkWLuoOVFaXN4PFTM0ffFU/XYgjoimLt0Bhqp8xCIAEOC1PtMqtOYpprTyvb2oYiaAhydGGaUEc.";
  };
}
