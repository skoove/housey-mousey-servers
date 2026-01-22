{ pkgs, ... }: {
  imports = [ ./hardware.nix ];
  
  networking.hostName = "housey-mousey";

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
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false;
    };
  };

  services.firefly-iii = {
    enable = true;
    enableNginx = true;
    settings.APP_KEY_FILE = "/firefly-key-file";
  };
}
