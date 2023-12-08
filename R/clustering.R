#' Perform binning procedure to ordinate events
#'
#' @param clicks A data frame of click data
#' @param param The parameter that will be binned
#'
#' @return A matrix with the counts in each bin
#' @export
#'
eventbin <- function(clicks, param) {
  ord <- clicks %>%
    select(Channel, eventId, {{param}}, species) %>%
    mutate(unit = as.character(cut({{param}},
                                   breaks = seq(from = floor(min({{param}})),
                                                to = ceiling(max({{param}})),
                                                by = .1)))) %>%
    group_by(eventId, unit) %>%
    tally() %>%
    pivot_wider(names_from = unit, values_from = n, values_fill = 0) %>%
    column_to_rownames(var="eventId") %>%
    as.matrix()
}
