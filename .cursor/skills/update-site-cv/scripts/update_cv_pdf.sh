#!/usr/bin/env bash
# Rebuild the 2-page web CV and replace the PDF linked from index.html.
set -euo pipefail

export PATH="/opt/homebrew/bin:${PATH}"

ROOT="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
SRC_DIR="${ROOT}/cv_source/cv_TianyiGu_2_page_web"
TEX="cv_TianyiGu_2_page_web.tex"
BUILT="${SRC_DIR}/cv_TianyiGu_2_page_web.pdf"
DEST="${ROOT}/TianyiGu_CV.pdf"
INDEX="${ROOT}/index.html"
HREF='href="TianyiGu_CV.pdf"'

if [[ ! -f "${SRC_DIR}/${TEX}" ]]; then
  echo "Missing source: ${SRC_DIR}/${TEX}" >&2
  exit 1
fi
if [[ ! -f "${INDEX}" ]]; then
  echo "Missing ${INDEX}" >&2
  exit 1
fi
if ! grep -q "${HREF}" "${INDEX}"; then
  echo "index.html does not link to TianyiGu_CV.pdf (${HREF})" >&2
  exit 1
fi
if ! command -v pdflatex >/dev/null 2>&1; then
  echo "pdflatex not found on PATH" >&2
  exit 1
fi

(
  cd "${SRC_DIR}"
  pdflatex -interaction=nonstopmode -halt-on-error "${TEX}" >/tmp/update_cv_pdf.log
)
if [[ ! -f "${BUILT}" ]]; then
  echo "Build did not produce ${BUILT}" >&2
  exit 1
fi

find "${SRC_DIR}" -maxdepth 1 -type f \( \
  -name '*.aux' -o -name '*.log' -o -name '*.out' -o -name '*.upa' -o -name '*.upb' \
\) -delete

cp -f "${BUILT}" "${DEST}"

echo "Updated ${DEST}"
echo "From ${BUILT}"
echo "index.html still links to TianyiGu_CV.pdf"
ls -l "${DEST}"
