# Implementation Plan: Automated LaTeX Compilation, Cloudflare R2 Upload & Portfolio Deploy Trigger

**Branch**: `001-latex-pdf-ci-automation` | **Date**: 2026-09-21 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-latex-pdf-ci-automation/spec.md`

## Summary

Automate the build and distribution pipeline for the curriculum vitae. On every push to `main`, a GitHub Actions workflow compiles the LaTeX sources into English and Brazilian Portuguese PDFs using Tectonic, uploads them to Cloudflare R2 bucket `howzysolutions/cv/`, and dispatches a build trigger to `H0wZy/howzysolutions`.

## Technical Context

**Language/Version**: LaTeX / XeTeX, Bash, PowerShell
**Primary Dependencies**: Tectonic typesetting engine, AWS CLI / Cloudflare R2 API
**Storage**: GitHub repository (`files/`), Cloudflare R2 bucket (`howzysolutions/cv/`)
**Testing**: CI compilation check, local `./build.ps1` execution
**Target Platform**: GitHub Actions (Ubuntu latest), Cloudflare R2
**Project Type**: Document build automation / CI pipeline
**Performance Goals**: < 2 minutes CI build and upload time
**Constraints**: Zero regression to existing TeX macros (`\tr{<EN>}{<PT>}`)
**Scale/Scope**: 2 documents (`main.tex`, `main-pt.tex`), 2 PDF artifacts, 1 GitHub Actions workflow

## Constitution Check

- Reproducible builds: PASS. Tectonic builds reliably in both Linux and Windows.
- Secure secrets: PASS. Secrets (`CLOUDFLARE_ACCOUNT_ID`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY`, `HOWZYSOLUTIONS_DEPLOY_TOKEN`) remain in GitHub Actions secrets.
- Independent verification: PASS. Local `./build.ps1` works standalone without CI dependencies.

## Project Structure

### Documentation (this feature)

```text
specs/001-latex-pdf-ci-automation/
├── plan.md              # This plan
├── research.md          # Technical rationale
├── quickstart.md        # Run and verification guide
└── tasks.md             # Actionable task list
```

### Source Code (repository root)

```text
.github/
└── workflows/
    └── deploy.yml       # GitHub Actions workflow for compile, R2 upload, and dispatch

overleaf/
├── main.tex             # English / bilingual LaTeX source
├── main-pt.tex          # Portuguese LaTeX entry point
└── fonts/               # Local TTF fonts

files/
├── ENG_CV_Marcos_Junior_Bueno_Selzler.pdf
└── PTBR_CV_Marcos_Junior_Bueno_Selzler.pdf

build.ps1                # Local PowerShell build script
```

## Complexity Tracking

*No violations or unnecessary dependencies.*
