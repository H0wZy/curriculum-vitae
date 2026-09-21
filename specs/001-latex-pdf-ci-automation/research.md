# Research: Automated LaTeX Compilation, Cloudflare R2 Upload & Portfolio Deploy Trigger

**Feature**: `001-latex-pdf-ci-automation`
**Spec**: [spec.md](./spec.md)

## Decisions & Technical Rationale

### 1. LaTeX Compiler Selection: Tectonic Engine

- **Decision**: Use [Tectonic](https://tectonic-typesetting.github.io/) in GitHub Actions, matching the local `build.ps1` script.
- **Rationale**:
  - Full TeX Live distributions require downloading 4-6 GB of packages, causing CI runners to take 10-15 minutes just to install dependencies.
  - Tectonic is a modern, single-binary XeTeX engine that dynamically fetches only required fonts and packages on-the-fly.
  - The documents (`main.tex` and `main-pt.tex`) rely on `fontspec` and local TTF fonts located in `overleaf/fonts/`, which Tectonic handles natively.
- **Alternatives Considered**:
  - *Full `texlive-full` Ubuntu package*: Rejected due to huge runner size and long setup time (>10 min).
  - *Docker-based Overleaf image*: Rejected due to high overhead and maintenance.

### 2. Cloudflare R2 Upload Mechanism

- **Decision**: Use AWS CLI or Cloudflare Wrangler to upload compiled PDFs to the `howzysolutions` R2 bucket under `cv/eng/` and `cv/ptbr/`.
- **Rationale**:
  - Cloudflare R2 provides a standard S3-compatible API (`https://<ACCOUNT_ID>.r2.cloudflarestorage.com`).
  - GitHub Actions runners come pre-equipped with the AWS CLI. Uploading requires zero third-party action dependencies:
    ```bash
    aws s3 cp files/ENG_CV_Marcos_Junior_Bueno_Selzler.pdf s3://howzysolutions/cv/eng/ENG_CV_Marcos_Junior_Bueno_Selzler.pdf --endpoint-url https://$CLOUDFLARE_ACCOUNT_ID.r2.cloudflarestorage.com --content-type application/pdf
    aws s3 cp files/PTBR_CV_Marcos_Junior_Bueno_Selzler.pdf s3://howzysolutions/cv/ptbr/PTBR_CV_Marcos_Junior_Bueno_Selzler.pdf --endpoint-url https://$CLOUDFLARE_ACCOUNT_ID.r2.cloudflarestorage.com --content-type application/pdf
    ```
- **Alternatives Considered**:
  - *Wrangler CLI*: Requires Node.js setup and `wrangler r2 object put`. Good alternative, but AWS CLI is already present on Ubuntu runners.

### 3. Cross-Repository Dispatch Trigger

- **Decision**: Trigger `howzysolutions` CI via GitHub's `repository_dispatch` REST API.
- **Rationale**:
  - Simple, robust `curl` command authenticated with a GitHub PAT or token:
    ```bash
    curl -X POST \
      -H "Accept: application/vnd.github.v3+json" \
      -H "Authorization: Bearer ${{ secrets.HOWZYSOLUTIONS_DEPLOY_TOKEN }}" \
      https://api.github.com/repos/H0wZy/howzysolutions/dispatches \
      -d '{"event_type":"cv_updated","client_payload":{"commit":"${{ github.sha }}"}}'
    ```
  - `howzysolutions`'s `ci.yml` simply adds `repository_dispatch: types: [cv_updated]` to its `on:` triggers, rebuilding and deploying `howzysolutions.com` in 30 seconds.
