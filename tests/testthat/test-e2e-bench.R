test_that("securebench reference datasets benchmark secureguard guardrails", {
  skip_if_missing_ecosystem()

  # Injection guardrail + injection_basic reference dataset.
  g <- secureguard::guard_prompt_injection()
  df <- securebench::load_reference("injection_basic")
  res <- securebench::guardrail_eval(g, df)

  metrics <- securebench::guardrail_metrics(res)
  # Sanity: metrics exist and are in [0, 1].
  for (m in c("precision", "recall", "f1", "accuracy")) {
    expect_true(is.numeric(metrics[[m]]))
    expect_gte(metrics[[m]], 0)
    expect_lte(metrics[[m]], 1)
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
