{ lib
, rustPlatform'
, maa-cli
, fetchFromGitHub
, maa-assistant-arknights
, installShellFiles
}:
let
  sources = lib.importJSON ./pin.json;
in
rustPlatform'.buildRustPackage rec {
  pname = "maa-cli-nightly";
  version = sources.maa-cli.version;

  src = fetchFromGitHub {
    owner = "MaaAssistantArknights";
    repo = "maa-cli";
    rev = "v${sources.maa-cli.version}";
    hash = sources.maa-cli.hash;
  };

  nativeBuildInputs = maa-cli.nativeBuildInputs;

  buildInputs = maa-cli.buildInputs;

  buildNoDefaultFeatures = maa-cli.buildNoDefaultFeatures;
  buildFeatures = maa-cli.buildFeatures;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  postInstall = maa-cli.postInstall + ''
    mkdir -p manpage
    $out/bin/maa mangen --path manpage
    installManPage manpage/*
  '';

  meta = maa-cli.meta;
}
