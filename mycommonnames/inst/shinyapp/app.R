# inst/shinyapp/app.R
library(shiny)
library(ggplot2)
library(dplyr)
library(scales)
library(bslib)

babynames_df <- mycommonnames::names

ui <- fluidPage(
  theme = bs_theme(bootswatch = "flatly"),
  titlePanel("Most Common Names in America"),

  sidebarLayout(
    sidebarPanel(
      helpText("Fields: name (first name), sex (F/M), year (1880–2021), count (# babies), proportion (% of births)."),

      # Searchable dropdowns
      selectizeInput(
        "name1", "Search or select first name:",
        choices = NULL, options = list(placeholder = "Type a name…", maxOptions = 1000)
      ),
      selectizeInput(
        "name2", "Compare with (optional):",
        choices = NULL, options = list(placeholder = "Type a name…", maxOptions = 1000)
      ),

      radioButtons("sex", "Gender:", choices = c("F" = "F", "M" = "M"), inline = TRUE),

      radioButtons("metric", "Y-axis:", inline = TRUE,
                   choices = c("Count" = "count", "Proportion (%)" = "proportion"),
                   selected = "count"),

      sliderInput("yearRange", "Select year range:",
                  min = 1880, max = 2021, value = c(1950, 2021), sep = "")
    ),

    mainPanel(
      plotOutput("trendPlot"),
      p(em("Interpretation: Higher line = more popularity for that name in that year.
            Compare shapes to see rise/fall across generations.")),
      textOutput("summaryText")
    )
  )
)

server <- function(input, output, session) {
  # Build the full name list once (fast)
  all_names <- sort(unique(babynames_df$name))

  # Populate dropdowns server-side
  updateSelectizeInput(session, "name1", choices = all_names, selected = "Samantha", server = TRUE)
  updateSelectizeInput(session, "name2", choices = all_names, selected = "Scarlette", server = TRUE)

  output$trendPlot <- renderPlot({
    req(input$name1, input$sex)

    selected_names <- unique(na.omit(c(input$name1, input$name2)))
    df <- babynames_df |>
      filter(
        name %in% selected_names,
        sex == input$sex,
        year >= input$yearRange[1],
        year <= input$yearRange[2]
      )

    # pick metric and axis format
    ycol   <- if (input$metric == "count") "count" else "proportion"
    ylab   <- if (input$metric == "count") "Number of babies" else "Proportion of births"
    yscale <- if (input$metric == "count") {
      scale_y_continuous(labels = label_comma())
    } else {
      scale_y_continuous(labels = label_percent(accuracy = 0.01))
    }

    validate(
      need(nrow(df) > 0, "No data for this selection. Try a different name/gender/year range.")
    )

    ggplot(df, aes(x = year, y = .data[[ycol]], color = name)) +
      geom_line(linewidth = 1.2) +
      yscale +
      labs(
        x = "Year",
        y = ylab,
        title = paste("Popularity of", paste(selected_names, collapse = " vs "), "(", input$sex, ")"),
        color = "Name"
      ) +
      theme_minimal() +
      theme(legend.position = "bottom")
  })

  output$summaryText <- renderText({
    req(input$name1, input$sex)

    names_to_summarize <- unique(na.omit(c(input$name1, input$name2)))
    if (length(names_to_summarize) == 0) return("Select at least one name.")

    summaries <- lapply(names_to_summarize, function(nm) {
      df <- babynames_df %>% filter(name == nm, sex == input$sex)
      if (!nrow(df)) return(paste0("No data for ", nm, "."))

      if (input$metric == "count") {
        peak <- df[which.max(df$count), ]
        paste0(nm, ": peak ", peak$year, " with ",
               format(peak$count, big.mark = ","), " babies")
      } else {
        peak <- df[which.max(df$proportion), ]
        paste0(nm, ": peak ", peak$year, " at ",
               percent(peak$proportion, accuracy = 0.01))
      }
    })

    paste(summaries, collapse = "  |  ")
  })
}

shinyApp(ui, server)


