{ lib
, python3
, fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "sse-starlette";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sysid";
    repo = "sse-starlette";
    rev = "v${version}";
    hash = "sha256-kDcSG/3foP7fMZKYrkKx6FHvT9c9rSzxyv2EHjQ2WSA=";
  };

  nativeBuildInputs = [
    python3.pkgs.pdm-backend
  ];

  propagatedBuildInputs = with python3.pkgs; [
    anyio
    starlette
    uvicorn
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    examples = [
      fastapi
    ];
  };

  pythonImportsCheck = [ "sse_starlette" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/sysid/sse-starlette";
    changelog = "https://github.com/sysid/sse-starlette/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    mainProgram = "sse-starlette";
  };
}
