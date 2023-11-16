{pkgs ? import (import ./pkgs.nix) {}}:
pkgs.callPackage ./package.nix {}
