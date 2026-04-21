skip_if_missing_ecosystem <- function() {
  for (pkg in c("securer", "securetools", "secureguard", "securecontext",
                "orchestr", "securetrace", "securebench")) {
    skip_if_not_installed(pkg)
  }
}

# Minimal MockChat compatible with orchestr::Agent. Returns a fixed
# response on each $chat() call so the E2E tests never talk to a real
# LLM provider.
mock_chat_class <- function() {
  R6::R6Class(
    "MockChat",
    public = list(
      response = NULL,
      turns = list(),
      initialize = function(response) {
        self$response <- response
      },
      chat = function(...) self$response,
      clone_chat = function() self,
      get_last_turn = function() NULL,
      get_turns = function() self$turns
    )
  )
}
