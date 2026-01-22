{ ... }: {
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
}
