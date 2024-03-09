{ lib
, python3
, fetchFromGitHub
, httpx-sse
}:

python3.pkgs.buildPythonPackage rec {
  pname = "llm-mistral";
  version = "0.3";
  pyproject = true;
  dontCheckRuntimeDeps = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-mistral";
    rev = version;
    hash = "sha256-ddaYXvbee66Keh5loQOs4xuOrtoQ06lHlBWlLiUp2zI=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
    python3.pkgs.httpx
    httpx-sse
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    test = [
      pytest
      pytest-httpx
    ];
  };

  meta = with lib; {
    description = "LLM plugin providing access to Mistral models using the Mistral API";
    homepage = "https://github.com/simonw/llm-mistral";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
