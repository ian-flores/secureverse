# Releasing secure-r-dev packages to CRAN

CRAN forbids `Remotes:` in `DESCRIPTION`, but the secure-r-dev
component packages list each other in `Remotes:` so
`pak::pak("ian-flores/<pkg>")` works for non-CRAN consumers. This
document describes the submission flow.

## Submission order

CRAN accepts a package only if all its dependencies are already
available. Submit in this order, waiting for each to land before the
next:

1. `securer`
2. `securetrace`
3. `secureguard` (depends on securer, securetrace)
4. `securecontext` (depends on securetrace; soft on orchestr)
5. `securetools` (depends on securer; soft on secureguard, orchestr,
   securetrace)
6. `orchestr` (soft on everything else)
7. `securebench` (soft on secureguard, securetrace)
8. `secureverse` — only after all seven are on CRAN.

Soft = `Suggests`. Submit can technically proceed before Suggests
land, but vignettes that exercise the soft dep won't build cleanly.

## Building the CRAN tarball

```sh
Rscript secureverse/inst/release/build-cran-tarball.R /path/to/securer
# → securer_0.2.0.tar.gz in cwd, with Remotes: stripped
```

The script clones the package into `tempdir()`, removes the `Remotes:`
block, and runs `R CMD build` with CRAN-friendly flags. The on-disk
package is untouched.

## Final pre-submission checks

```sh
R CMD check --as-cran securer_0.2.0.tar.gz
```

Should report `Status: OK` (0 errors, 0 warnings, 0 notes). CI on each
repo already runs `--as-cran` and is required to be green.

For a wider matrix:

```r
rhub::check_for_cran("securer_0.2.0.tar.gz")
devtools::check_win_devel("securer_0.2.0.tar.gz")
```

## Submission

Upload the tarball at <https://cran.r-project.org/submit.html>. The
text in `cran-comments.md` is what you paste into the "comments"
field.

## After acceptance

Tag the released commit on GitHub (`git tag v0.2.0-cran`) so the on-main
`Remotes:` reference resolves to a known-CRAN-published version even
for downstream non-CRAN packages still depending on the GitHub form.
