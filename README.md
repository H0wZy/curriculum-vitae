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
- **CLI:** `xelatex main.tex` (EN) or `xelatex main-pt.tex` (PT).

## PDF Version
[Download CV (PDF)](https://raw.githubusercontent.com/H0wZy/curriculum-vitae/main/CV_Marcos_Junior_Bueno_Selzler.pdf)

## Repository
[View on GitHub](https://github.com/H0wZy/curriculum-vitae)
