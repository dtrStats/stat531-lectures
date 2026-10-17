# Runs after every `quarto render`.
# Removes the built output of any session page still marked `draft: true`,
# so unfinished slides and handouts never end up in docs/.
out_dir <- Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR", "docs")
qmds <- list.files(pattern = "^[0-9]{2}_.*\\.qmd$")

for (f in qmds) {
  header <- readLines(f, n = 20, warn = FALSE)
  if (any(grepl("^draft:[[:space:]]*true[[:space:]]*$", header))) {
    html <- file.path(out_dir, sub("\\.qmd$", ".html", f))
    if (file.exists(html)) {
      file.remove(html)
      message("Pruned draft output: ", html)
    }
  }
}
