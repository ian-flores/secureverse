#' Report resolved versions of all secureverse siblings
#'
#' Prints a small table of package names and installed versions for
#' every sibling package in the secure-r-dev ecosystem. Useful for
#' diagnostic output in bug reports and for verifying that the Remotes
#' pinning in `secureverse` has been honoured by `pak::pak()` or
#' `devtools::install()`.
#'
#' @return Invisibly, a `data.frame(package, version)`.
#' @export
#' @examples
#' secureverse_versions()
secureverse_versions <- function() {
  pkgs <- c(
    "securer", "securetools", "secureguard", "securecontext",
    "orchestr", "securetrace", "securebench"
  )
  rows <- lapply(pkgs, function(pkg) {
    ver <- tryCatch(
      as.character(utils::packageVersion(pkg)),
      error = function(e) NA_character_
    )
    data.frame(package = pkg, version = ver, stringsAsFactors = FALSE)
  })
  df <- do.call(rbind, rows)
  cli::cli_h2("secureverse: sibling versions")
  for (i in seq_len(nrow(df))) {
    cli::cli_li("{df$package[i]}: {df$version[i] %||% 'not installed'}")
  }
  invisible(df)
}

`%||%` <- function(x, y) if (is.null(x) || is.na(x)) y else x
