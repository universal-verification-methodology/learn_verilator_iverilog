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
| `--no-narration` | Skip TTS; silent video at fixed seconds per slide (faster CI) |
| `--run-demos` | Re-run terminal capture during verify (slow) |

Requires the Cursor skill: `~/.cursor/skills/module-to-slides-video` (run `bash …/scripts/setup.sh` once).

## Per-module outputs

| File | Description |
|------|-------------|
| `outline.yaml` | Slide plan (machine input for `build_slides.py`) |
| `script.md` | Per-slide TTS narration (one timing-table row per slide) |
| `assets/manifest.yaml` | Images and demo capture commands |
| `slides.pptx` | Primary deck |
| `slides.pdf` | PDF export |
| `video.mp4` | Slides + TTS narration (`audio/narration.wav`, `captions.srt`, `transcript.txt`) |

## Regenerate outlines

```bash
./scripts/regenerate_media_outlines.sh
./scripts/build_all_media.sh
```

Edit `media/outline_overrides.yaml` (demo commands + architecture code slides) or hand-tune `outline.yaml` after generation.

Each deck includes **Design architecture** (two-column slides + execution code from the repo), **Verification & testing methods**, syllabus topics, command highlights, and hands-on demo slides. Narration is auto-generated from slide bullets and `notes` fields — edit `script.md` to refine voiceover text.

## Git

Intermediate files under `frames/` and `*.log` are gitignored. Commit `slides.pptx` / `slides.pdf` / `video.mp4` only if you want large binaries in the repo.
