# Feature Specification: Automated LaTeX Compilation, Cloudflare R2 Upload & Portfolio Deploy Trigger

**Feature Branch**: `001-latex-pdf-ci-automation`

**Created**: 2026-09-21

**Status**: Ready for Planning

**Input**: User description: "Automate LaTeX PDF build, R2 upload to howzysolutions/cv/, and dispatch build/deploy to howzysolutions repository"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Continuous PDF Compilation on Commit (Priority: P1)

A resume author pushes updates to `overleaf/main.tex` or `overleaf/main-pt.tex` on the `main` branch. The system automatically compiles both the English and Brazilian Portuguese curriculum vitae using Tectonic (XeTeX) in CI, ensuring that syntax or formatting errors in LaTeX are caught immediately without manual local builds.

**Why this priority**: Eliminates human error in PDF generation and ensures that every committed change has matching, valid PDF artifacts.

**Independent Test**: Push a commit modifying a bullet point in `overleaf/main.tex`. Verify GitHub Actions runs, compiles both documents, and produces two valid PDF artifacts (`ENG_CV_*.pdf` and `PTBR_CV_*.pdf`) with exit code 0.

**Acceptance Scenarios**:

1. **Given** a valid commit pushed to `main`, **When** the CI workflow triggers, **Then** both English and Brazilian Portuguese PDFs compile cleanly within 2 minutes.
2. **Given** a commit containing broken LaTeX syntax, **When** the CI workflow triggers, **Then** the job fails with a clear compiler error log and prevents downstream publishing.

---

### User Story 2 - Automated Cloudflare R2 Bucket Sync (Priority: P1)

After successful compilation of the PDFs, the system automatically uploads both compiled PDF files to the designated Cloudflare R2 storage bucket (`howzysolutions/cv/`), organizing them into their respective locale directories (`cv/eng/` and `cv/ptbr/`).

**Why this priority**: Keeps remote cloud storage synchronized with the latest resume artifacts as an authoritative, durable object store.

**Independent Test**: Trigger the CI workflow and check the Cloudflare R2 bucket `howzysolutions` to verify that `cv/eng/ENG_CV_*.pdf` and `cv/ptbr/PTBR_CV_*.pdf` exist with updated timestamps matching the commit.

**Acceptance Scenarios**:

1. **Given** successfully compiled PDF artifacts in CI, **When** the upload step runs, **Then** the files are written to the R2 bucket under `cv/eng/` and `cv/ptbr/` with `application/pdf` content type.
2. **Given** missing or invalid R2 credentials, **When** the upload step runs, **Then** the step fails cleanly with an informative error message.

---

### User Story 3 - Automated Portfolio Deployment Trigger (Priority: P2)

Once the new CV PDFs are compiled and uploaded, the CI workflow sends a webhook/repository dispatch event to `H0wZy/howzysolutions`. This initiates the portfolio's build and deploy pipeline, allowing the live site (`howzysolutions.com`) to extract the latest CV facts, generate fresh `/cv.md`, and deploy in under a minute without manual intervention.

**Why this priority**: Achieves true end-to-end automation across repositories: updating the resume repository automatically updates the live portfolio.

**Independent Test**: Push a test commit to `curriculum-vitae` and verify that a repository dispatch event is received by `howzysolutions`, triggering a new build run.

**Acceptance Scenarios**:

1. **Given** a completed PDF build and upload on `curriculum-vitae`, **When** the dispatch step runs, **Then** a `repository_dispatch` event of type `cv_updated` is delivered to `H0wZy/howzysolutions`.
2. **Given** `howzysolutions` receives the event, **When** its CI executes, **Then** it rebuilds with the new CV source and publishes to `howzysolutions.com`.

---

### Edge Cases

- **Rate Limits / API Failures**: If the Cloudflare R2 or GitHub API encounters transient errors, the workflow should report the failure and allow manual re-runs via `workflow_dispatch`.
- **Secret Absence**: If secrets (Cloudflare API token, GitHub PAT) are not yet configured on a fork or branch, the build and compilation steps should still succeed, with deployment steps gracefully skipped or gated on `main`.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST provide a GitHub Actions workflow in `.github/workflows/deploy.yml` that triggers on `push` to `main` and on `workflow_dispatch`.
- **FR-002**: The workflow MUST compile both `overleaf/main.tex` (English) and `overleaf/main-pt.tex` (Portuguese) using the Tectonic engine.
- **FR-003**: The workflow MUST produce output PDF files named `ENG_CV_Marcos_Junior_Bueno_Selzler.pdf` and `PTBR_CV_Marcos_Junior_Bueno_Selzler.pdf`.
- **FR-004**: The workflow MUST upload both generated PDFs to Cloudflare R2 bucket `howzysolutions` using S3-compatible API or Wrangler/CLI.
- **FR-005**: The workflow MUST trigger a repository dispatch event on `H0wZy/howzysolutions` upon successful compilation and upload.
- **FR-006**: The local build script `build.ps1` MUST remain consistent with the CI compilation process.

### Key Entities

- **CvArtifact**: The compiled PDF binary output of a specific language variant (English or Brazilian Portuguese).
- **R2StorageDestination**: The target path in Cloudflare R2 (`howzysolutions/cv/eng/` and `howzysolutions/cv/ptbr/`).
- **DeployTriggerEvent**: The dispatch payload sent to the portfolio repository to initiate downstream publishing.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Full end-to-end workflow execution (compilation, upload, dispatch) completes in under 3 minutes in GitHub Actions.
- **SC-002**: 100% of commits to `main` produce verified valid PDF documents that can be opened without corruption.
- **SC-003**: Zero manual build steps required to propagate resume updates from `curriculum-vitae` to `howzysolutions.com`.

## Assumptions

- Cloudflare R2 credentials (Account ID, Access Key ID, Secret Access Key) and a GitHub Personal Access Token (PAT) with repository dispatch permissions will be supplied as GitHub repository secrets.
- `howzysolutions` repository will have its CI workflow configured to listen for `repository_dispatch` events.
