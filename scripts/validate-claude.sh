#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
claude plugin validate --strict "$repo_root/plugins/guzli"
claude plugin validate --strict "$repo_root"
