{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "llm-claude";
  version = "0.4.0";
  pyproject = true;
  dontCheckRuntimeDeps = true;

  src = fetchFromGitHub {
    owner = "tomviner";
    repo = "llm-claude";
    rev = version;
    hash = "sha256-lC0Tx7zeM8gZ3Ln8VWkq29BsKsMnxHB3s+R086B5BEs=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    anthropic
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    test = [
      click
      pytest
    ];
  };

  meta = with lib; {
    description = "Plugin for LLM adding support for Anthropic's Claude models";
    homepage = "https://github.com/tomviner/llm-claude";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "llm-claude";
  };
}
