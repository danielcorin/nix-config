{ lib
, python3
, fetchFromGitHub
, sse-starlette
}:

python3.pkgs.buildPythonPackage rec {
  pname = "httpx-sse";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "florimondmanca";
    repo = "httpx-sse";
    rev = version;
    hash = "sha256-nU8vkmV/WynzQrSrq9+FQXtfAJPVLpMsRSuntU0HWrE=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    python3.pkgs.httpx
    python3.pkgs.twine
    sse-starlette
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    test = [
      black
      mypy
      pytest
      pytest-asyncio
      pytest-cov
      ruff
    ];
  };

  pythonImportsCheck = [ "httpx_sse" ];

  meta = with lib; {
    description = "Consume Server-Sent Event (SSE) messages with HTTPX";
    homepage = "https://github.com/florimondmanca/httpx-sse";
    changelog = "https://github.com/florimondmanca/httpx-sse/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
