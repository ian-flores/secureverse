test_that("securebench reference datasets benchmark secureguard guardrails", {
  skip_if_missing_ecosystem()

  # Injection guardrail + injection_basic reference dataset.
  g <- secureguard::guard_prompt_injection()
  df <- securebench::load_reference("injection_basic")
  res <- securebench::guardrail_eval(g, df)

  metrics <- securebench::guardrail_metrics(res)
  # Sanity: every metric is numeric and in [0, 1]; precision/recall/f1
  # could still be NaN on an arbitrary corpus where the guardrail
  # produces a degenerate confusion-matrix slice (zero predicted
  # positives → undefined precision), but accuracy is always defined
  # and should be a real number for any non-empty labeled dataset.
  for (m in c("precision", "recall", "f1", "accuracy")) {
    v <- metrics[[m]]
    expect_true(is.numeric(v))
    expect_true(is.na(v) || (v >= 0 && v <= 1))
  }
  expect_false(is.na(metrics$accuracy))
  expect_gte(metrics$accuracy, 0)
  expect_lte(metrics$accuracy, 1)
})

test_that("secureverse_versions() surfaces every sibling", {
  skip_if_missing_ecosystem()
  df <- secureverse_versions()
  expect_setequal(df$package,
                  c("securer", "securetools", "secureguard", "securecontext",
                    "orchestr", "securetrace", "securebench"))
  expect_true(all(!is.na(df$version)))
})
