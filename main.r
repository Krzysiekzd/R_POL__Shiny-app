library(shiny)
library(bslib)
library(colourpicker)

main_theme <- bs_theme(
  bg = "#700449", fg = "white", primary = "#FCC780",
  base_font = font_google("Space Mono")
)



ui <- fluidPage(
  titlePanel("Aplikacja R Shiny do manipulacji histogramem z gotowego zbioru danych"),
  sidebarLayout(
    sidebarPanel(
      fluidRow(
        
        column(6,
               numericInput("num_of_breaks", label = "Liczba odcinków", value = 25, min = 0, step = 1),
               textInput("x_label",label="Etykieta osi X", value = "Liczba zgonów"),
               textInput("y_label",label="Etykieta osi Y", value = "Częstotliwość"),
               
               
               
        ),
        
        column(6,
               sliderInput("x_range", label = "Oś X - zakres", value = c(500, 3000), min = 0, max = 5000),
               sliderInput("y_range", label = "Oś Y - zakres", value = c(0, 40), min = 0, max = 100)
               
        ),
        column(12, textInput("main_label",label="Tytuł wykresu", value = "Miesięczna liczba zgonów w wypadkah samochodowych w UK w latach 1969-84")),
        column(6, 
               colourInput("bar_color", label="Kolor słupków", value="#F520D9", showColour = "background")),
        column(6,
               colourInput("borders_color", label="Kolor krawędzi", value="#9E0C3B", showColour = "background"),
               
        )
      )##
      
    ),
    mainPanel(
      tabsetPanel(
        id = "tabset",
        tabPanel("Wykres", plotOutput("hist")),
        tabPanel("Dane", h1("Dane z lat 1969-1984"),verbatimTextOutput("summary"),
                 tableOutput("table"))
      )
    )
  ), theme = main_theme
)



server <- function(input, output, session) {
  output$hist <- renderPlot(hist(
    UKDriverDeaths, 
    main=input$main_label,
    xlab = input$x_label,
    ylab = input$y_label,
    xlim=input$x_range,
    ylim=input$y_range,
    col=input$bar_color,
    breaks=input$num_of_breaks,
    border=input$borders_color
  ))
  
  output$summary <- renderPrint({
    x <- UKDriverDeaths
    summary(x)
  })
  
  output$table <- renderTable({
    x <- UKDriverDeaths
    x
  })
  
}


shinyApp(ui, server)