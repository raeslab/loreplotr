library(dplyr)
library(tidyr)
library(nnet)
library(effects)
library(ggplot2)


validate_input <- function(df, x,y) {
  # Validate input
  if (!(x %in% names(df)) || !(y %in% names(df))) {
    stop("One or more variables do not exist in the dataframe.")
  }
}

get_group_dots_data <- function(dots_data, i, groups) {
  group = groups[i]
  end_pos = length(groups) + 2

  group_dots_data = dots_data %>% filter(V1 == group)

  if (i+3 < end_pos) {
    group_dots_data = group_dots_data %>% mutate_at(groups,as.numeric) %>%
      mutate(ymax = rowSums(across((i+2):end_pos)),
             ymin = rowSums(across((i+3):end_pos))) %>%
      mutate(position = runif(n(), ymin + (ymax-ymin)*0.05, ymax - (ymax-ymin)*0.05))
  } else {
    group_dots_data = group_dots_data %>% mutate_at(groups,as.numeric) %>%
      mutate(ymax = rowSums(across((i+2):end_pos)),
             ymin = 0) %>%
      mutate(position = runif(n(), ymin + (ymax-ymin)*0.05, ymax - (ymax-ymin)*0.05))
  }

  group_dots_data = group_dots_data %>% select(V2, position) %>% mutate_if(is.character,as.numeric)

  return(group_dots_data)
}

plot_area <- function(df, x, y, draw_dots=TRUE) {
  # Prepare data and load it into the global environment (required for Effect function)
  .GlobalEnv$wdf = df %>% select(c({{x}}, {{y}}))

  # Fit multinomial and generate data for areas
  formula <- reformulate(x, response = y)
  mnom_model = multinom(formula, data=wdf)

  predicted_probabilities = Effect(x, mnom_model, xlevels=300)
  probabilities_df = data.frame(predicted_probabilities$x, predicted_probabilities$prob)

  melt_data <- pivot_longer(probabilities_df, -{{x}}, names_to = y, values_to = "value")
  melt_data[[y]] <-  gsub('prob.', '', melt_data[[y]])

  g <- ggplot(melt_data, aes_string(x=x, y="value", fill=y)) +
    geom_area() +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.background = element_blank(),
      axis.title.y = element_blank(),
    )

  if (draw_dots) {
    groups = unique(melt_data[[y]])

    dots_data <- as.data.frame(cbind(df[[y]], df[[x]], predict(mnom_model, newdata = df[x], "probs")))


    for (i in 1:length(groups)) {
      group_dots_data = get_group_dots_data(dots_data, i, groups)

      g = g + geom_point(data=group_dots_data , aes(x=V2, y=position), fill="white", colour="white", size=3, alpha=0.7)
    }
  }

  return(g)
}


#' Draw Loreplot
#'
#' Draws a logistic regression plot for the provided data
#' @param df The input data
#' @param x  Continuous variable to be shown on the x-axis
#' @param y  Categorical variable, predicated probabilities shown on y-axis
#' @return ggplot2 plot
#' @examples
#' mtcars$cyl <- paste("cyl", mtcars$cyl, sep="_")
#' mtcars %>% loreplotr("mpg", "cyl")
#' @export
loreplotr <- function(df, x, y, draw_dots=TRUE) {
  validate_input(df, x, y)

  g = df %>%
    plot_area(x, y, draw_dots = draw_dots)

  return(g)
}
