{
  pkgs ? import <nixpkgs> { },
}:

pkgs.callPackage (
  {
    lib,
    fetchFromGitHub,
    python3Packages,
    git,
  }:

  python3Packages.buildPythonApplication (finalAttrs: {
    pname = "nvibrant";
    version = "1.2.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "Tremeschin";
      repo = "nvibrant";
      rev = "v${finalAttrs.version}";
      hash = "sha256-YUeHFRv1w/BXKdfkbmA/1pi0enCfL6UqV+x+uBroPFY=";
      fetchSubmodules = true;
      leaveDotGit = true;
    };

    patches = [ ./hatch_build.patch ];

    build-system = with python3Packages; [
      hatchling
      meson
      ninja
    ];

    dependencies = with python3Packages; [ packaging ];

    nativeBuildInputs = [ git ];

    meta = with lib; {
      description = "Configure NVIDIA's Digital Vibrance on Wayland";
      homepage = "https://github.com/Tremeschin/nvibrant";
      license = licenses.gpl3Only;
      mainProgram = "nvibrant";
      maintainers = [ maintainers.mikaeladev ];
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
  })
) { }
