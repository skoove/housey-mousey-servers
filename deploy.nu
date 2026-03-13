#! /usr/bin/env -S nu -n --no-std-lib

def main [] {
  let host_ip = "192.168.1.45"
  let hostname = "apollo"

  nixos-rebuild switch --flake .#($hostname) --target-host root@($host_ip) --build-host root@($host_ip)
}
