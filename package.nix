{ stdenv
, lib
, ruby
}:

stdenv.mkDerivation(finalAttrs: {
  pname = "nixos-profiles-tool";
  version = "0.0.1";
  src = lib.cleanSource ./.;

  buildInputs = [
    ruby
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -vp $out/bin
    mkdir -vp $out/share/nixos-profiles-tool/
    mv -v -t  $out/share/nixos-profiles-tool/ src 

    cat > $out/bin/nixos-profiles-tool <<EOF
    #!${ruby}/bin/ruby
    load "$out/share/nixos-profiles-tool/src/nixos-profiles-tool"
    EOF
    chmod +x $out/bin/nixos-profiles-tool

    runHook postInstall
  '';
})
