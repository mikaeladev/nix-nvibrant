{
  pkgs ? import <nixpkgs> { },
}:

pkgs.callPackage (
  {
    fetchFromGitHub,
    pkgs,
    stdenv,
  }:

  stdenv.mkDerivation rec {
    pname = "nvibrant";
    version = "1.1.0";

    nativeBuildInputs = with pkgs; [
      python313
      python313Packages.meson
      python313Packages.ninja
    ];

    src = fetchFromGitHub {
      owner = "Tremeschin";
      repo = "nvibrant";
      rev = "ba3f723a6cb5930db38186f9fbb9d71e9047eb13";
      hash = "sha256-Ws8Pxwtg5KaG5kktvoTM9VgQnTG5MGbFNgB3d10R7EM=";
      fetchSubmodules = true;
    };

    buildPhase = ''
      meson setup --buildtype release ./build
      ninja -C ./build
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp ./build/${pname} $out/bin
    '';

    meta = with pkgs.lib; {
      description = "Configure NVIDIA's Digital Vibrance on Wayland";
      homepage = "https://github.com/Tremeschin/nvibrant";
      license = licenses.gpl3;
      mainProgram = "nvibrant";
      maintainers = [ ]; # update this once added to nixpkgs
      platforms = intersectLists platforms.x86_64 platforms.linux;
    };
  }
) { }
