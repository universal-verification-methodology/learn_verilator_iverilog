# Course media — slides, PDF, and video

Generated teaching assets for each module. Source content: `docs/MODULEN.md` (including **Design Architecture** and **Verification & Testing Methods** sections), `moduleN/EXAMPLES.md`, and per-module diagrams under `media/moduleN/assets/diagrams/`.

See [INDEX.md](INDEX.md) for links to every module’s PPTX, PDF, and video.

## Build (one command)

From the `learn_verilator_iverilog` repo root:

```bash
./scripts/build_all_media.sh
```

| Flag | Purpose |
|------|---------|
| `--install-deps` | `sudo apt install` LibreOffice Impress, ffmpeg, poppler (optional) |
| `--pptx-only` | Skip PDF and video |
| `--module 1` | Single module (supports `0,1,2`) |
| `--regenerate-outlines` | Refresh `outline.yaml` from docs + EXAMPLES |
| `--run-demos` | Re-run terminal capture during verify (slow) |

Requires the Cursor skill: `~/.cursor/skills/module-to-slides-video` (run `bash …/scripts/setup.sh` once).

## Per-module outputs

| File | Description |
|------|-------------|
| `outline.yaml` | Slide plan (machine input for `build_slides.py`) |
| `script.md` | Narration / timing notes for video |
| `assets/manifest.yaml` | Images and demo capture commands |
| `slides.pptx` | Primary deck |
| `slides.pdf` | PDF export |
| `video.mp4` | Silent preview (~8 s/slide; add `audio/narration.wav` for voice) |

## Regenerate outlines

```bash
./scripts/regenerate_media_outlines.sh
./scripts/build_all_media.sh
```

Edit `media/outline_overrides.yaml` or hand-tune `outline.yaml` after generation.

## Git

Intermediate files under `frames/` and `*.log` are gitignored. Commit `slides.pptx` / `slides.pdf` / `video.mp4` only if you want large binaries in the repo.
