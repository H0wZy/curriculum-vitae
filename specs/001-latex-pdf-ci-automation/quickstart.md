# Quickstart & Verification: Automated LaTeX Compilation & Deploy

**Feature**: `001-latex-pdf-ci-automation`
**Spec**: [spec.md](./spec.md)

## Verification Scenarios

### 1. Local Build Verification
Run the PowerShell build script:
```powershell
./build.ps1
```
Verify:
1. `files/ENG_CV_Marcos_Junior_Bueno_Selzler.pdf` is created and updated.
2. `files/PTBR_CV_Marcos_Junior_Bueno_Selzler.pdf` is created and updated.
3. Both PDFs can be opened and have valid contents.

### 2. GitHub Actions CI Verification
1. Inspect `.github/workflows/deploy.yml`.
2. Push a commit or trigger `workflow_dispatch`.
3. Verify steps:
   - Tectonic compiles `main.tex` and `main-pt.tex` without errors.
   - S3/R2 upload step uploads both files to `howzysolutions/cv/eng/` and `howzysolutions/cv/ptbr/`.
   - Dispatch step notifies `H0wZy/howzysolutions`.
