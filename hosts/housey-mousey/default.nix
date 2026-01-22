{ ... }: {
  imports = [ ./hardware.nix ];
  
  networking.hostName = "housey-mousey";

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
