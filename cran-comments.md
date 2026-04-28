## R CMD check results

0 errors | 0 warnings | 0 notes

* This is a new submission.

## Submission notes

secureverse is an umbrella meta-package for the secure-r-dev ecosystem
(securer, securetools, secureguard, securecontext, orchestr,
securetrace, securebench). It carries no runtime logic of its own,
hosts cross-package end-to-end tests, and provides a
`secureverse_versions()` diagnostic. Submission depends on all seven
component packages already being on CRAN.

## Test environments

* GitHub Actions: ubuntu-latest (release), macOS-latest (release)
* local macOS (aarch64-apple-darwin), R 4.5.x
