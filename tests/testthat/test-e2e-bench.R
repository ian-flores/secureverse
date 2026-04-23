test_that("securebench reference datasets benchmark secureguard guardrails", {
  skip_if_missing_ecosystem()

  # Injection guardrail + injection_basic reference dataset.
  g <- secureguard::guard_prompt_injection()
  df <- securebench::load_reference("injection_basic")
  res <- securebench::guardrail_eval(g, df)

  metrics <- securebench::guardrail_metrics(res)
  # Sanity: each metric is either a valid [0, 1] score or NaN/NA when the
  # guardrail's behaviour against the current bundled dataset produces a
  # degenerate confusion-matrix slice (e.g. zero predicted positives →
  # undefined precision). The E2E goal here is that the pipeline runs
  # end-to-end through secureguard + securebench, not that the metrics
  # are impressive. Bring-your-own-corpus benchmarks should assert tighter
  # ranges.
  for (m in c("precision", "recall", "f1", "accuracy")) {
    v <- metrics[[m]]
    expect_true(is.numeric(v))
    expect_true(is.na(v) || (v >= 0 && v <= 1))
  }
})

test_that("secureverse_versions() surfaces every sibling", {
  skip_if_missing_ecosystem()
  df <- secureverse_versions()
  expect_setequal(df$package,
                  c("securer", "securetools", "secureguard", "securecontext",
                    "orchestr", "securetrace", "securebench"))
  expect_true(all(!is.na(df$version)))
})
