# Tasks: Automated LaTeX Compilation, Cloudflare R2 Upload & Portfolio Deploy Trigger

**Input**: Design documents from `/specs/001-latex-pdf-ci-automation/`
**Prerequisites**: [plan.md](./plan.md), [spec.md](./spec.md), [research.md](./research.md), [quickstart.md](./quickstart.md)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm sources and local build configuration.

- [X] T001 Verify LaTeX sources in `overleaf/` and local execution of `build.ps1`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish GitHub Actions workflow environment.

- [X] T002 [P] Create `.github/workflows/` directory structure

---

## Phase 3: User Story 1 - Continuous PDF Compilation on Commit (Priority: P1) 🎯 MVP

**Goal**: Automatically compile English and Portuguese PDFs in GitHub Actions using Tectonic.

**Independent Test**: Push commit to `main`, verify workflow runs and produces both PDFs cleanly.

- [X] T003 [US1] Create `.github/workflows/deploy.yml` with Tectonic setup and compilation for `overleaf/main.tex` and `overleaf/main-pt.tex`
- [X] T004 [US1] Add artifact verification step ensuring `files/ENG_CV_Marcos_Junior_Bueno_Selzler.pdf` and `files/PTBR_CV_Marcos_Junior_Bueno_Selzler.pdf` exist

**Checkpoint**: Automated compilation in CI functional.

---

## Phase 4: User Story 2 - Automated Cloudflare R2 Bucket Sync (Priority: P1)

**Goal**: Upload compiled PDFs to Cloudflare R2 bucket `howzysolutions/cv/`.

**Independent Test**: Trigger workflow, verify PDFs are uploaded to `howzysolutions/cv/eng/` and `howzysolutions/cv/ptbr/`.

- [X] T005 [US2] Add Cloudflare R2 upload step in `.github/workflows/deploy.yml` using AWS CLI with Cloudflare R2 endpoint and credentials

**Checkpoint**: PDFs synced to durable R2 bucket storage.

---

## Phase 5: User Story 3 - Automated Portfolio Deployment Trigger (Priority: P2)

**Goal**: Dispatch event to `howzysolutions` to trigger rebuild and edge deploy.

**Independent Test**: Trigger workflow, verify repository dispatch sent to `howzysolutions`.

- [X] T006 [US3] Add repository dispatch step to `.github/workflows/deploy.yml` sending `cv_updated` event to `H0wZy/howzysolutions`

**Checkpoint**: Cross-repository deploy trigger operational.

---

## Phase 6: Polish & Verification

**Purpose**: Documentation and consistency checks.

- [X] T007 [P] Update `README.md` with CI automation workflow details and secret configuration guidelines
- [X] T008 Verify local `./build.ps1` compiles without errors
