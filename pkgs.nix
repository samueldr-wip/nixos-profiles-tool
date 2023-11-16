let
  rev = "e44462d6021bfe23dfb24b775cc7c390844f773d";
  sha256 = "sha256:0nrqv5vy261i9vjawcv1sh39cvhw2idvvj088k724jj04y79z1si";
  owner = "samueldr";
  repo = "nixpkgs";
in
fetchTarball {
  url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
  inherit sha256;
}
