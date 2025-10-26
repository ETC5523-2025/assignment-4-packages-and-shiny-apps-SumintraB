library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Most Common Names in America"),
  sidebarLayout(
    sidebarPanel(
      selectInput("name", "Choose a name:", choices = sort(unique(names$name))),
      radioButtons("sex", "Gender:", choices = c("F", "M"), inline = TRUE),
      sliderInput("yearRange", "Select year range:",
                  min = 1880, max = 2021, value = c(1950, 2021), sep = "")
    ),
    mainPanel(
      plotOutput("trendPlot"),
      textOutput("summaryText")
    )
  )
)

server <- function(input, output) {
  output$trendPlot <- renderPlot({
    df <- subset(names, name == input$name & sex == input$sex &
                   year >= input$yearRange[1] & year <= input$yearRange[2])
    ggplot(df, aes(year, count)) +
      geom_line(color = "steelblue", linewidth = 1.2) +
      labs(x = "Year", y = "Number of babies",
           title = paste("Popularity of", input$name))
  })

  output$summaryText <- renderText({
    df <- subset(names, name == input$name & sex == input$sex)
    peak <- df[which.max(df$count), ]
    paste0("Peak popularity in ", peak$year, " with ",
           peak$count, " babies named ", input$name, ".")
  })
}

shinyApp(ui, server)
