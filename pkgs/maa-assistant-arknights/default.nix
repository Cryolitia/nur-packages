{ lib
, maa-assistant-arknights
, fetchFromGitHub
}:

let
  sources = lib.importJSON ./pin.json;
in
(maa-assistant-arknights.overrideAttrs (oldAttrs: {
  pname  = "maa-assistant-arknights-nightly";
  src = fetchFromGitHub {
    owner = "MaaAssistantArknights";
    repo = "MaaAssistantArknights";
    rev = "v${sources.beta.version}";
    sha256 = sources.beta.hash;
  };
}))
