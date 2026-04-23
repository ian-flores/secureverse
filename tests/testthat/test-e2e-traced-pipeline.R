test_that("spans from multiple siblings nest under a single trace", {
  skip_if_missing_ecosystem()

  tr <- securetrace::with_trace("e2e", {
    # securetools emits a tool span
    calc <- securetools::tool_calculator()
    calc@fn(expression = "2 + 2")

    # secureguard emits a guardrail span
    g <- secureguard::guard_prompt_injection()
    secureguard::run_guardrail(g, "hello world")

    # securecontext emits an embed span
    emb <- securecontext::embed_tfidf(c("cat sat", "dog ran"))
    securecontext::embed_texts(emb, c("cat"))

    securetrace::current_trace()
  }, exporter = securetrace::exporter_console(verbose = FALSE))

  span_names <- vapply(tr$spans, function(s) s$name, character(1))
  # At least one span from each of the three siblings that ran above.
  expect_true(any(grepl("^tool\\.", span_names)))
  expect_true(any(grepl("^guardrail\\.|^bench\\.", span_names)) ||
              any(grepl("injection", span_names, ignore.case = TRUE)))
  expect_true(any(grepl("^context\\.", span_names)))
})
