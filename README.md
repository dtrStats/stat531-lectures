# STAT 531: R in the AI Era (lectures and handouts)

Slides and handouts for the R, data wrangling, visualization, and data cleaning sessions.
Labs live in the separate course project repo.

Published site: https://YOUR-USERNAME.github.io/stat531-lectures/

## Layout

| Path | What it is |
|:--|:--|
| `NN_slides.qmd` | In-class slides for session NN (reveal.js) |
| `NN_handout.qmd` | Detailed handout for session NN (HTML) |
| `data/` | Datasets used in class examples |
| `_quarto.yml` | Site settings (shared by every page) |
| `theme.scss` | Handout theme (PSU colors) |
| `slides.css` | Slide theme (PSU colors) |
| `index.qmd` | Home page; the session table builds itself from the files |
| `docs/` | Rendered site (GitHub Pages serves this folder) |
| `_freeze/` | Cached R results; commit it so renders are reproducible |
| `scripts/prune-drafts.R` | Runs after each render and removes output for pages still marked `draft: true` |

Sessions 2-7 are placeholders marked `draft: true`. Drafts are not built, linked, or listed.

## Publish a session

1. Write the content in `NN_slides.qmd` / `NN_handout.qmd`.
2. Delete the `draft: true` line from the top of the file (and the "Planned outline" stub).
3. `quarto render`
4. `git add . && git commit -m "Publish session NN" && git push`

## Build locally

Requires R, Quarto, and the `tidyverse` package.

```bash
quarto render      # builds the whole site into docs/
quarto preview     # live preview while editing
```
