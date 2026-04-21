# secureverse 0.1.0

Initial release. Umbrella meta-package for the secure-r-dev ecosystem.

## Features

* `secureverse_versions()` — list resolved versions of all seven
  sibling packages for diagnostic output.
* Pinned `Remotes:` across all siblings at their tagged versions
  (securer 0.2.0, securetools 0.2.0, secureguard 0.3.0,
  securecontext 0.2.0, orchestr 0.2.0, securetrace 0.2.1,
  securebench 0.2.0) so `pak::pak("ian-flores/secureverse")` installs a
  known-good matrix.
* End-to-end tests exercising combinations no individual package owns:
  guarded tools, traced pipelines, RAG retrieval via `embed_custom`,
  and benchmarking with the new bundled reference datasets.
