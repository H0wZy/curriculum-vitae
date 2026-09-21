# Marcos Junior Bueno Selzler — Curriculum Vitae

Professional résumé built with LaTeX (Overleaf). **Bilingual from a single source**:
English (primary) and Portuguese (secondary).

## Technologies
- LaTeX (XeLaTeX/LuaLaTeX, `fontspec` + `polyglossia`)
- Overleaf

## Building

Both languages come from a single source (`overleaf/main.tex`) via the
`\tr{<EN>}{<PT>}` macro. Edit content **only** in `main.tex`.

| Language | File to compile | Engine |
|----------|-----------------|--------|
| English (default) | `overleaf/main.tex` | XeLaTeX |
| Português | `overleaf/main-pt.tex` | XeLaTeX |

- **Overleaf:** set the desired file as *Main document* and recompile.
- **Local, both PDFs at once:** `./build.ps1`. It compiles with [Tectonic](https://tectonic-typesetting.github.io/)
  (a single `tectonic.exe` on `PATH`, XeTeX engine, packages fetched on first run) and writes
  `files/ENG_CV_*.pdf` and `files/PTBR_CV_*.pdf` with the names linked below.
- **CLI with a TeX install:** `xelatex main.tex` (EN) or `xelatex main-pt.tex` (PT).

## PDF Version
- **English:** [howzysolutions.com/cv.pdf/eng](https://howzysolutions.com/cv.pdf/eng)
- **Português:** [howzysolutions.com/cv.pdf/ptbr](https://howzysolutions.com/cv.pdf/ptbr)

## CI/CD Automation
On push to `main` with changes in `overleaf/`:
1. GitHub Actions compiles both PDFs using Tectonic.
2. Commits updated PDFs to `files/`.
3. Syncs PDFs to Cloudflare R2 bucket `howzysolutions/cv/`.
4. Dispatches build trigger to [howzysolutions](https://github.com/H0wZy/howzysolutions) to update the live portfolio.

## Repository
[View on GitHub](https://github.com/H0wZy/curriculum-vitae)
