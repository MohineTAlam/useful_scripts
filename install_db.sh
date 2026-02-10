#!/usr/bin/env bash
set -euo pipefail

# ---------- CONFIG ----------
BASE_DIR="${BASE_DIR:-$HOME/databases}"

# Choose which Kraken2 DB URL you actually want (you mentioned two)
KRAKEN_DB_URL="${KRAKEN_DB_URL:-https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08_GB_20250714.tar.gz}"
KRAKEN_DB_NAME="${KRAKEN_DB_NAME:-k2_standard_08_GB_20250714}"

PLASSEMBLER_DB_URL="${PLASSEMBLER_DB_URL:-https://zenodo.org/record/10158040/files/201123_plassembler_v1.5.0_databases.tar.gz}"
PLASSEMBLER_DB_NAME="${PLASSEMBLER_DB_NAME:-plassembler_db_v1.5.0}"

CHECKM2_DB_NAME="${CHECKM2_DB_NAME:-checkm2_db}"
# ----------------------------

mkdir -p "${BASE_DIR}"

echo "=== Installing Kraken2 prebuilt DB ==="
KRAKEN_DIR="${BASE_DIR}/${KRAKEN_DB_NAME}"
mkdir -p "${KRAKEN_DIR}"
tmp_kraken="$(mktemp -p "${BASE_DIR}" kraken2_db.XXXXXX.tar.gz)"

echo "Downloading: ${KRAKEN_DB_URL}"
wget -O "${tmp_kraken}" "${KRAKEN_DB_URL}"

echo "Extracting to: ${KRAKEN_DIR}"
tar -xvzf "${tmp_kraken}" -C "${KRAKEN_DIR}"
rm -f "${tmp_kraken}"

# The extracted tar typically contains the DB files inside the target dir.
# Kraken2 expects --db to point at the directory containing hash.k2d/opts.k2d/taxo.k2d etc.
echo "Kraken2 DB installed at: ${KRAKEN_DIR}"

echo
echo "=== Installing Plassembler DB (v1.5.0) ==="
PLAS_DIR="${BASE_DIR}/${PLASSEMBLER_DB_NAME}"
mkdir -p "${PLAS_DIR}"
tmp_plas="$(mktemp -p "${BASE_DIR}" plassembler_db.XXXXXX.tar.gz)"

echo "Downloading: ${PLASSEMBLER_DB_URL}"
wget -O "${tmp_plas}" "${PLASSEMBLER_DB_URL}"

echo "Extracting to: ${PLAS_DIR}"
tar -xvzf "${tmp_plas}" -C "${PLAS_DIR}"
rm -f "${tmp_plas}"

echo "Plassembler DB installed at: ${PLAS_DIR}"

echo
echo "=== Installing CheckM2 DB ==="
CHECKM2_DIR="${BASE_DIR}/${CHECKM2_DB_NAME}"
mkdir -p "${CHECKM2_DIR}"

# Assumes checkm2 is installed and on PATH in the current environment.
# If not, install via mamba/conda first.
checkm2 database --download --path "${CHECKM2_DIR}"

echo "CheckM2 DB installed at: ${CHECKM2_DIR}"

echo
echo "=== Nextflow config paths (absolute) ==="
echo "kraken2_db = '${KRAKEN_DIR}'"
echo "plassembler_db = '${PLAS_DIR}'"
echo "checkm2_db = '${CHECKM2_DIR}'"
