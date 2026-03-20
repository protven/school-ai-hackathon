#!/usr/bin/env bash
set -euo pipefail

MODELS_DIR="${MODELS_DIR:-./models}"

CHAT_MODEL_FILE="Qwen_Qwen3-1.7B-Q4_K_M.gguf"
EMBED_MODEL_FILE="qwen3-embedding-0.6b-q4_k_m.gguf"

CHAT_MODEL_URL="https://huggingface.co/bartowski/Qwen_Qwen3-1.7B-GGUF/resolve/main/${CHAT_MODEL_FILE}?download=true"
EMBED_MODEL_URL="https://huggingface.co/sabafallah/Qwen3-Embedding-0.6B-Q4_K_M-GGUF/resolve/main/${EMBED_MODEL_FILE}?download=true"

mkdir -p "${MODELS_DIR}"

download_file() {
  local url="$1"
  local output="$2"

  if [ -f "${output}" ]; then
    echo "[skip] already exists: ${output}"
    return 0
  fi

  if command -v curl >/dev/null 2>&1; then
    echo "[download] curl -> ${output}"
    curl -L --fail --output "${output}" "${url}"
    return 0
  fi

  if command -v wget >/dev/null 2>&1; then
    echo "[download] wget -> ${output}"
    wget -O "${output}" "${url}"
    return 0
  fi

  echo "[error] neither curl nor wget is installed"
  exit 1
}

download_file "${CHAT_MODEL_URL}" "${MODELS_DIR}/${CHAT_MODEL_FILE}"
download_file "${EMBED_MODEL_URL}" "${MODELS_DIR}/${EMBED_MODEL_FILE}"

echo
echo "[ok] models are ready:"
echo " - ${MODELS_DIR}/${CHAT_MODEL_FILE}"
echo " - ${MODELS_DIR}/${EMBED_MODEL_FILE}"
