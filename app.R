# R Shiny App
# Stratified Sampling - Population Mean
# Proportional, Neyman & Optimised Allocation

library(shiny)

ui <- fluidPage(
  
  titlePanel("Stratified Sampling - Estimation of Population Mean"),
  
  sidebarLayout(
    
    sidebarPanel(
      numericInput("L", "Number of Strata:", value = 3, min = 2),
      numericInput("Z", "Z-value (Confidence Level):", value = 1.96),
      numericInput("d", "Allowable Error (Sampling Bias):", value = 2),
      actionButton("calc", "Calculate Sample Size")
    ),
    
    mainPanel(
      h4("Sample Allocation Table"),
      tableOutput("result"),
      br(),
      h4("Experimental Design Plot"),
      plotOutput("plot")
    )
  )
)

server <- function(input, output) {
  
  observeEvent(input$calc, {
    
    # Example data 
    Nh <- c(500, 300, 200)     # Population in each stratum
    Sh <- c(12, 18, 25)        # Standard deviation
    Cost <- c(5, 8, 12)        # Cost per unit
    Time <- c(10, 15, 20)      # Time per unit
    
    N <- sum(Nh)
    Wh <- Nh / N
    
    Z <- input$Z
    d <- input$d
    
    # Proportional Allocation
    n_prop <- (Z^2 * sum(Wh * Sh^2)) / d^2
    n_prop <- ceiling(n_prop)
    nh_prop <- n_prop * Wh
    
    # Neyman Allocation
    n_neyman <- (Z^2 * (sum(Wh * Sh))^2) / d^2
    n_neyman <- ceiling(n_neyman)
    nh_neyman <- n_neyman * (Nh * Sh) / sum(Nh * Sh)
    
    # Optimised Allocation
    # (Cost + Time)
    CT <- Cost * Time
    
    n_opt <- (Z^2 * (sum(Wh * Sh * sqrt(CT)))^2) / d^2
    n_opt <- ceiling(n_opt)
    nh_opt <- n_opt * (Nh * Sh / sqrt(CT)) / sum(Nh * Sh / sqrt(CT))
    
    # Output Table
    output$result <- renderTable({
      data.frame(
        Stratum = paste("Stratum", 1:length(Nh)),
        Population = Nh,
        Proportional = round(nh_prop),
        Neyman = round(nh_neyman),
        Optimised = round(nh_opt)
      )
    })
    
    # Plot Experimental Design
    output$plot <- renderPlot({
      allocation <- rbind(
        Proportional = nh_prop,
        Neyman = nh_neyman,
        Optimised = nh_opt
      )
      
      barplot(
        allocation,
        beside = TRUE,
        col = c("skyblue", "orange", "lightgreen"),
        names.arg = paste("Stratum", 1:length(Nh)),
        main = "Experimental Design: Sample Allocation",
        ylab = "Sample Size",
        xlab = "Strata"
      )
      
      legend(
        "topright",
        legend = rownames(allocation),
        fill = c("skyblue", "orange", "lightgreen")
      )
    })
  })
}

shinyApp(ui = ui, server = server)