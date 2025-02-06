{
  lib,
  rustPlatform,
  fetchFromGitHub,
  hyfetch,
  makeWrapper,
  neofetch,
}:
let

in
rustPlatform.buildRustPackage rec {
  pname = "hyfetch";
  version = "2.0.0-rc1";

  src = fetchFromGitHub {
    owner = "hykilpikonna";
    repo = "hyfetch";
    rev = version;
    hash = "sha256-ocIrTMBxiJ80sGfPl2mHpqV2LCGwKLZ08AAT2uJNM0I=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    makeWrapper
  ];

  buildInputs = [
    neofetch
  ];

  prePatch = ''
    rm -rf neofetch
    ln -s ${lib.getExe neofetch} neofetch
  '';

  cargoHash = "sha256-BNYfVMU4vVhW7Ie5ykxkzcBRwBhtjmPDx8m/cjPa8eI=";

  meta = hyfetch.meta // {
    maintainers = with lib.maintainers; [ cryolitia ];
  };
}
