# secureverse

> Umbrella meta-package for the secure-r-dev ecosystem.

secureverse has no runtime logic of its own. It exists to:

1. **Pin compatible versions** of the seven secure-r-dev component
   packages through a shared `Remotes:` field, so that a single
   `pak::pak("ian-flores/secureverse")` installs a known-good matrix.
2. **Host cross-package end-to-end tests** that exercise combinations
   none of the individual packages own (guarded tools + traced
   pipeline + bundled benchmark + RAG retrieval).

## Installation

```r
# install.packages("pak")
pak::pak("ian-flores/secureverse@v0.1.0")
```

This resolves to:

| Package       | Pinned version |
| ------------- | -------------- |
| securer       | 0.2.0          |
| securetools   | 0.2.0          |
| secureguard   | 0.3.0          |
| securecontext | 0.2.0          |
| orchestr      | 0.2.0          |
| securetrace   | 0.2.1          |
| securebench   | 0.2.0          |

## The stack

```
                    ┌────────────────┐
                    │    securer      │
                    └───────┬────────┘
          ┌─────────────────┼─────────────────┐
          │                 │                  │
   ┌──────▼──────┐  ┌──────▼──────┐  ┌───────▼────────┐
   │ securetools  │  │ secureguard │  │ securecontext   │
   └──────┬───────┘  └──────┬──────┘  └───────┬────────┘
          └─────────────────┼─────────────────┘
                    ┌───────▼──────┐
                    │   orchestr   │
                    └───────┬──────┘
          ┌─────────────────┼─────────────────┐
          │                                   │
   ┌──────▼──────┐                     ┌──────▼──────┐
   │ securetrace  │                    │ securebench  │
   └─────────────┘                     └─────────────┘
```

* **securer** — sandboxed R subprocess with tool-call IPC.
* **securetools** — pre-built `securer_tool()` factories.
* **secureguard** — input/code/output guardrails (local, no API calls).
* **securecontext** — local TF-IDF RAG + optional external embedders.
* **orchestr** — graph-based agent orchestration.
* **securetrace** — OpenTelemetry-style observability backbone.
* **securebench** — guardrail benchmarking (P/R/F1) with bundled
  reference datasets.

All coupling is runtime-soft: every sibling declares siblings as
`Suggests`, not `Imports`, and uses `securetrace::with_span()` through
an `.trace_active()` gate. secureverse just pins the versions that are
known to work together.

## Verifying your install

```r
secureverse::secureverse_versions()
#> -- secureverse: sibling versions --------------------------
#> * securer: 0.2.0
#> * securetools: 0.2.0
#> * secureguard: 0.3.0
#> * securecontext: 0.2.0
#> * orchestr: 0.2.0
#> * securetrace: 0.2.1
#> * securebench: 0.2.0
```

## Running the E2E tests

```r
# from the cloned repo
devtools::test()
```

Tests skip cleanly if any sibling is missing, so they work out of the
box for partial installs too.

## See also

* Per-package docs: [securer](https://github.com/ian-flores/securer),
  [securetools](https://github.com/ian-flores/securetools),
  [secureguard](https://github.com/ian-flores/secureguard),
  [securecontext](https://github.com/ian-flores/securecontext),
  [orchestr](https://github.com/ian-flores/orchestr),
  [securetrace](https://github.com/ian-flores/securetrace),
  [securebench](https://github.com/ian-flores/securebench).
* `vignette("ecosystem-integration", package = "securetrace")` — span
  taxonomy and sibling instrumentation pattern.
