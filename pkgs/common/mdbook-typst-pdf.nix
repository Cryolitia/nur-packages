{ lib
, rustPlatform'
, fetchFromGitHub
}:

rustPlatform'.buildRustPackage rec {
  pname = "mdbook-typst-pdf";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "KaiserY";
    repo = "mdbook-typst-pdf";
    rev = "v${version}";
    hash = "sha256-fQTRnl7Z+HZuJ2CrofxmVTrz6Hyf8NpUJ2SWlow+zmY=";
  };

  cargoHash = "";

  cargoLock.outputHashes = {
    "typst-0.11.0" = "sha256-RbkirnVrhYT/OuZSdJWMOvQXAeBmsFICsCrezyT6ukA=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  meta = with lib; {
    description = "将 mdBook 转换为 PDF。";
    homepage = "https://github.com/KaiserY/mdbook-typst-pdf";
    license = licenses.asl20;
    maintainers = with maintainers; [ Cryolitia ];
    #mainProgram = "maa";
  };
}
