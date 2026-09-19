# Compiles both languages with Tectonic (XeTeX engine, no TeX install needed)
# and writes them to files/ under the names the README and the portfolio link to.
$ErrorActionPreference = 'Stop'
$overleaf = Join-Path $PSScriptRoot 'overleaf'
$files = Join-Path $PSScriptRoot 'files'
$out = Join-Path ([IO.Path]::GetTempPath()) 'cv-build'
New-Item -ItemType Directory -Force $out | Out-Null

$targets = @{
  'main.tex'    = 'ENG_CV_Marcos_Junior_Bueno_Selzler.pdf'
  'main-pt.tex' = 'PTBR_CV_Marcos_Junior_Bueno_Selzler.pdf'
}

Push-Location $overleaf
try {
  foreach ($tex in $targets.Keys) {
    tectonic -X compile $tex --outdir $out
    if ($LASTEXITCODE -ne 0) { throw "tectonic failed on $tex" }
    $pdf = Join-Path $out ([IO.Path]::ChangeExtension($tex, '.pdf'))
    Copy-Item $pdf (Join-Path $files $targets[$tex]) -Force
    Write-Host "ok $tex -> files/$($targets[$tex])"
  }
} finally {
  Pop-Location
}
