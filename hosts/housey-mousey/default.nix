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
    virtualHost = "0.0.0.0:9123";
  };
}
