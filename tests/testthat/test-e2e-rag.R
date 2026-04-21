test_that("securecontext embed_custom + retriever returns expected context", {
  skip_if_missing_ecosystem()

  # A minimal deterministic custom embedder: one dim per exact token.
  tokens <- c("cat", "dog", "bird")
  fake_embed <- function(texts) {
    mat <- matrix(0, nrow = length(texts), ncol = length(tokens))
    for (i in seq_along(texts)) {
      for (j in seq_along(tokens)) {
        mat[i, j] <- as.integer(grepl(tokens[j], tolower(texts[i])))
      }
    }
    mat
  }
  emb <- securecontext::embed_custom(fake_embed, dims = length(tokens),
                                     name = "test-tokens")
  vs <- securecontext::vector_store$new(dims = emb@dims)
  ret <- securecontext::retriever(vs, emb)
  securecontext::add_documents(ret, securecontext::document("The cat sat on the mat."))
  securecontext::add_documents(ret, securecontext::document("A dog ran in the park."))

  built <- securecontext::context_for_chat(ret, "cat", max_tokens = 200, k = 1)
  expect_true(nchar(built$context) > 0)
  # The retrieved context should mention the winning document.
  expect_match(built$context, "cat", ignore.case = TRUE)
})

test_that("vector_store$metadata() accessor is usable (R6 private peek removed)", {
  skip_if_missing_ecosystem()
  vs <- securecontext::vector_store$new(dims = 2L)
  vs$add("a", matrix(c(1, 0), nrow = 1), metadata = list(list(chunk_text = "hello")))
  expect_equal(vs$metadata("a")$chunk_text, "hello")
})
