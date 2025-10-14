#' @keywords internal
#' @noRd
parse_imf_sdmx_json <- function(message) {
  `%||%` <- function(a, b) if (!is.null(a)) a else b

  # Defensive checks
  if (is.null(message) || is.null(message$data)) {
    return(tibble::tibble())
  }
  data_sets <- message$data$dataSets
  structures <- message$data$structures
  if (
    is.null(data_sets) || length(data_sets) < 1 ||
      is.null(structures) || length(structures) < 1
  ) {
    return(tibble::tibble())
  }

  ds <- data_sets[[1]]
  st <- structures[[1]]

  # Dimensions metadata
  series_dims <- st$dimensions$series
  obs_dims <- st$dimensions$observation
  obs_dim <- if (!is.null(obs_dims) && length(obs_dims) >= 1) {
    obs_dims[[1]]
  } else {
    NULL
  }

  # Helpers to map index -> code/id
  index_to_code <- function(dim_def, idx) {
    if (
      is.null(dim_def) || is.null(dim_def$values) || length(dim_def$values) < 1
    ) {
      return(NA_character_)
    }
    i <- suppressWarnings(as.integer(idx))
    if (is.na(i)) return(NA_character_)
    i <- i + 1L
    if (i < 1L || i > length(dim_def$values)) return(NA_character_)
    v <- dim_def$values[[i]]
    (v$id %||% v$value) %||% NA_character_
  }

  obs_index_to_period <- function(idx) {
    if (
      is.null(obs_dim) || is.null(obs_dim$values) || length(obs_dim$values) < 1
    ) {
      return(NA_character_)
    }
    i <- suppressWarnings(as.integer(idx))
    if (is.na(i)) return(NA_character_)
    i <- i + 1L
    if (i < 1L || i > length(obs_dim$values)) return(NA_character_)
    v <- obs_dim$values[[i]]
    (v$value %||% v$id) %||% NA_character_
  }

  # No series present -> empty tibble
  if (is.null(ds$series) || length(ds$series) == 0) {
    return(tibble::tibble())
  }

  # Prepare column names for series dimensions
  series_dim_ids <- character(0)
  if (!is.null(series_dims) && length(series_dims) > 0) {
    series_dim_ids <- vapply(
      series_dims, function(x) as.character(x$id), character(1)
    )
  }

  # Build rows
  rows <- list()
  row_idx <- 0L
  series_keys <- names(ds$series)
  for (sk in series_keys) {
    s_entry <- ds$series[[sk]]
    # Decode series key indices to codes
    sk_parts <- strsplit(sk, ":", fixed = TRUE)[[1]]
    # Ensure length matches; pad if necessary
    if (length(sk_parts) < length(series_dim_ids)) {
      sk_parts <- c(
        sk_parts, rep(NA_character_, length(series_dim_ids) - length(sk_parts))
      )
    }
    series_codes <- if (length(series_dim_ids) > 0) {
      mapply(
        function(dim_def, idx) index_to_code(dim_def, idx),
        series_dims, sk_parts, SIMPLIFY = TRUE, USE.NAMES = FALSE
      )
    } else {
      character(0)
    }

    # Key is observation index; value is vector where first is OBS_VALUE
    obs_keys <- names(s_entry$observations)
    if (length(obs_keys) == 0) next
    for (ok in obs_keys) {
      obs <- s_entry$observations[[ok]]
      # Observation value is the first element; handle NULLs gracefully
      obs_val_raw <- if (length(obs) >= 1) obs[[1]] else NA
      obs_val_num <- NA_real_
      if (!is.null(obs_val_raw)) {
        tmp <- suppressWarnings(as.numeric(obs_val_raw))
        if (length(tmp) == 1 && !is.na(tmp)) {
          obs_val_num <- tmp
        } else if (is.character(obs_val_raw)) {
          # Map common non-numeric flags to NA
          if (obs_val_raw %in% c("NA", "NP", "ND", "N/A")) {
            obs_val_num <- NA_real_
          }
        }
      }
      time_period <- obs_index_to_period(ok)

      row_idx <- row_idx + 1L
      row <- c(
        stats::setNames(as.list(series_codes), series_dim_ids),
        list(TIME_PERIOD = time_period, OBS_VALUE = obs_val_num)
      )
      rows[[row_idx]] <- row
    }
  }

  if (length(rows) == 0) return(tibble::tibble())
  # Bind rows; ensure consistent columns
  df <- tibble::as_tibble(dplyr::bind_rows(rows))
  df
}
