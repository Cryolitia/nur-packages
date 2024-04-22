{ lib
, maa-assistant-arknights
, fetchFromGitHub
, stdenv
}:

let
  sources = lib.importJSON ./pin.json;
in
(maa-assistant-arknights.overrideAttrs (oldAttrs: {
  pname  = "maa-assistant-arknights";
  src = fetchFromGitHub {
    owner = "MaaAssistantArknights";
    repo = "MaaAssistantArknights";
    rev = "v${sources.beta.version}";
    sha256 = sources.beta.hash;
  };
  # https://github.com/NixOS/nixpkgs/issues/306042
  meta = oldAttrs // {
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
}))
