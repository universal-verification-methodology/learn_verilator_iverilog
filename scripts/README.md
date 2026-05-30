# Scripts

Installation, module orchestrators, and **slides/PDF/video** generation.

## Media scripts

| Script | Purpose |
|--------|---------|
| `build_all_media.sh` | Build **all** modules: pptx → pdf → video |
| `verify_all_media.sh` | Verify outlines, assets, and deliverables |
| `regenerate_media_outlines.sh` | Regenerate `media/moduleN/outline.yaml` from docs + EXAMPLES |

```bash
./scripts/build_all_media.sh              # full build
./scripts/build_all_media.sh --module 1   # one module
./scripts/regenerate_media_outlines.sh    # refresh outlines only
./scripts/verify_all_media.sh             # quick check
```

Outputs: `media/moduleN/slides.pptx`, `slides.pdf`, `video.mp4`. See [media/README.md](../media/README.md) and [media/INDEX.md](../media/INDEX.md).

## Module scripts

Run from the **repository root**:

| Script | Module |
|--------|--------|
| `module0.sh` | Installation and setup |
| `module1.sh` | iverilog deep dive |
| `module2.sh` | Verilator deep dive |
| `module3.sh` … `module8.sh` | Testbench topics through methodology |

Each module script supports `--check` (environment self-check for the media pipeline) and `--help`.

Example:

```bash
./scripts/module1.sh --check
./scripts/module1.sh --compilation
```

## Install scripts

| Script | Purpose |
|--------|---------|
| `install_iverilog.sh` | Install Icarus Verilog |
| `install_verilator.sh` | Install Verilator |
| `install_gtkwave.sh` | Install GTKWave |

## Making scripts executable

```bash
chmod +x scripts/*.sh scripts/lib/*.sh
```
