{
  stdenvNoCC,
  lib,
  rustPlatform,
  fetchFromGitHub,
  opencc,
  pkg-config,
  protobuf,
}:
let
  version = "7.0.0-beta-4";

  origin-src = fetchFromGitHub {
    owner = "KonghaYao";
    repo = "cn-font-split";
    rev = version;
    hash = "sha256-Nvw+JnhRnL0GCjEBu3VLtvmamsUJbX5iZaklKMFiwCI=";
  };

  cargo-lock = ./Cargo.lock;

  src = stdenvNoCC.mkDerivation {
    name = "cn-font-split-src";
    src = lib.cleanSource origin-src;

    patches = [
      ./lang-unicodes.patch
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      rm -rf crates/lang_unicodes
      cp -r ./* $out/
      cp ${cargo-lock} $out/Cargo.lock

      runHook postInstall
    '';
  };

in
rustPlatform.buildRustPackage {
  pname = "cn-font-split";
  inherit src version;

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    protobuf
  ];

  buildInputs = [
    opencc
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "lang-unicodes-0.1.0" = "sha256-VppftEEaxVD8+9hH2K6DhkIqsdp7v/pq+Xe0I6NeMvQ=";
    };
  };

  meta = {
    description = "A revolutionary font subetter that supports CJK and any characters!";
    longDescription = ''
      A revolutionary font subetter that supports CJK and any characters! It enables multi-threaded subset of otf, ttf, and woff2 fonts, allowing for precise control over package size.
    '';
    homepage = "https://github.com/KonghaYao/cn-font-split";
    maintainers = with lib.maintainers; [
      Cryolitia
    ];
    mainProgram = "cn-font-split";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
