#!/usr/bin/env bash
# Shared self-check for module-to-slides-video (./scripts/moduleN.sh --check).

media_check_ok() {
  echo "[OK] $*"
}

media_check_fail() {
  echo "[FAIL] $*"
  MEDIA_CHECK_FAILED=1
}

media_check_info() {
  echo "[INFO] $*"
}

media_check_iverilog() {
  if command -v iverilog >/dev/null 2>&1; then
    media_check_ok "iverilog: $(iverilog -V 2>&1 | head -1)"
  else
    media_check_fail "iverilog not found (install: ./scripts/install_iverilog.sh)"
  fi
}

media_check_verilator_optional() {
  if command -v verilator >/dev/null 2>&1; then
    media_check_ok "verilator: $(verilator --version 2>&1 | head -1)"
  else
    media_check_info "verilator not installed (needed for Module 2+ labs: ./scripts/install_verilator.sh)"
  fi
}

media_check_module_dir() {
  local root="$1"
  local mod="$2"
  if [[ -d "$root/module$mod" ]]; then
    media_check_ok "module$mod/ present"
  else
    media_check_fail "module$mod/ missing"
  fi
}

media_check_examples() {
  local root="$1"
  local mod="$2"
  if [[ -d "$root/module$mod/examples" ]]; then
    media_check_ok "module$mod/examples/ present"
  else
    media_check_fail "module$mod/examples/ missing"
  fi
}

# Usage: media_module_check <course_root> <module_number>
media_module_check() {
  local root="$1"
  local mod="$2"
  MEDIA_CHECK_FAILED=0

  echo "=========================================="
  echo "Module $mod: environment self-check"
  echo "=========================================="

  media_check_module_dir "$root" "$mod"
  media_check_examples "$root" "$mod"

  case "$mod" in
    0|1)
      media_check_iverilog
      media_check_verilator_optional
      ;;
    2)
      media_check_verilator_optional
      media_check_iverilog
      ;;
    *)
      media_check_iverilog
      media_check_verilator_optional
      ;;
  esac

  if [[ "${MEDIA_CHECK_FAILED:-0}" -ne 0 ]]; then
    echo "Some required checks failed."
    return 1
  fi
  echo "All required checks passed"
  return 0
}
