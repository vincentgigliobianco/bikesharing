shinyServer(function(input, output, session) {
  data <- reactive({
    fun_filter_df(df,input$selected_period[1],input$selected_period[2])
  }) 
  
  # output$myvariablesdef <- renderPrint({
  #   variables_definition
  # })
  
  output$mydygraph <- renderDygraph({
    time_series_graph
  })
  
  output$my2Dplot <- renderPlot({
    fun_build_2d_plot(data(),input$selected_var)
  })
  
  output$my3Dplot <- renderPlot({
    fun_build_3dplot(data(),input$selected_var,input$selected_var_bis)
  })
  
})