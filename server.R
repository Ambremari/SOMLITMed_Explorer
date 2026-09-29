
function(input, output, session) {
  #------ reactive values
  values <- reactiveValues()
  
  #------ data selection 
  retrieve_data <- function(name){
    res <- switch(name,
                  "hydro_raw_dat" = raw_hydro_data,
                  "hydro_distrib_dat" = raw_hydro_data,
                  "piconano_raw_dat" = raw_piconano_data,
                  "piconano_distrib_dat" = raw_piconano_data,)
    return(res)
  }
  
  #------ download_plot
  download_plot <- function(exportname, plot) {
    downloadHandler(
      filename = function() {
        paste(exportname, "_", Sys.Date(), ".png", sep = "")
      },
      content = function(file) {
        ggsave(file, plot = plot, device = "png", width = 12)
      }
    )
  }
  
  #------PLOT functions
  plot_raw_ts <- function(data, y, x_label, y_label, outliers = NULL, selected_val = NULL){
    if(y_label == ""){
      y_label <- y
    }
    if(x_label == ""){
      x_label <- "TIME"
    }
    data <- data[!is.na(data[,y]),]
    res <- ggplot() +
      geom_point(data = data, aes_string(x = "DATE", y = y, col = "ID_SITE"), size = 2) + 
      theme_light() +
      scale_x_date(date_breaks = "1 year", date_labels = "%Y", expand = c(0.03, 0)) +
      xlab(x_label) + 
      ylab(y_label) +
      scale_color_manual(name="Site", values = my_palette) +
      theme(legend.text = element_text(size = 14),
            legend.title = element_text(size = 16),
            axis.text.x =  element_text(angle=45, hjust=1, size = 13),
            axis.text.y =  element_text(size = 13),
            axis.title = element_text(size = 16))
    if(nrow(outliers) > 0){
      res <- res +
        geom_point(data = outliers, aes_string(x = "DATE", y = y, col="PROF_TEXT"), shape = 4, size = 4) +
        scale_color_manual(name="", values="red", labels="Outliers")
    }
    return(res)
  }
  
  plot_box <- function(data, y, x_label, y_label, x = "ANNEE"){
    if(y_label == ""){
      y_label <- y
    }
    if(x_label == ""){
      x_label <- "TIME"
    }
    data <- data[!is.na(data[,y]),]
    res <- ggplot() +
      geom_boxplot(data = data, aes(x =.data[[x]], y = .data[[y]], fill = .data[["ID_SITE"]]), size=.8) + 
      theme_light() +
      ylab(y_label) + 
      xlab(x_label) + 
      scale_fill_manual(name="Site", values = my_palette) +
      theme(legend.text = element_text(size = 14),
            legend.title = element_text(size = 16),
            axis.text.x =  element_text(angle=45, hjust=1, size = 13),
            axis.text.y =  element_text(size = 13),
            axis.title = element_text(size = 16))
    return(res)
  }
  
  plot_distrib <- function(data, y, x_label, y_label){
    if(y_label == ""){
      y_label <- paste("Count(", y, ")", sep = "")
    }
    if(x_label == ""){
      x_label <- y
    }
    data <- data[!is.na(data[,y]),]
    hist <- data %>% ggplot(aes(.data[[y]])) +
      geom_histogram() +
      xlab(x_label) +
      ylab(y_label) +
      theme_light() +
      theme(legend.text = element_text(size = 14),
            legend.title = element_text(size = 16),
            axis.text.x =  element_text(size = 13),
            axis.text.y =  element_text(size = 13),
            axis.title = element_text(size = 16))
    boxplot <- data %>% 
      ggplot(aes(.data[[y]], 'PROF_TEXT')) + 
      geom_boxplot(outlier.alpha = 0.3, fatten = 1, outlier.size = 3) +
      theme_void() +
      theme(plot.margin = margin(0, 0, 0, 50))
    return(list(boxplot = boxplot, hist = hist))
  }


  
  
  
  # ------ HYDRO OUTPUT ----
  ##download button 
  output$btn_hydro_p1 <- renderUI({
    if(input$hydro_viz_type != ""){
      downloadButton(outputId = "download_hydro_p1", label = "Download plot")
    }
  })
  
  output$btn_hydro_p2 <- renderUI({
    if(input$hydro_viz_type != ""){
      downloadButton(outputId = "download_hydro_p2", label = "Download plot")
    }
  })
  
  ##HYDRO notes
  output$hydro_notes <- renderUI({
    title <- switch(input$hydro_viz_type,
                    "hydro_raw_dat" = "",
                    "hydro_distrib_dat" = "")
    text <- switch(input$hydro_viz_type,
                   "hydro_raw_dat" = "",
                   "hydro_distrib_dat" = "")
    column(12, tags$b(title),
           br(),
           text)
  })
  
  output$hydro_comments <- renderUI({
    switch(input$hydro_viz_type,
           "hydro_raw_dat" = column(12, tags$em(""),
                                    )
    )
           
  })
  
  ### ---- plot 1 ----
  
  output$hydro_plot1 <- renderPlot({
    if(input$hydro_viz_type != ""){
      my_data <- retrieve_data(input$hydro_viz_type)
      plot_name <- input$hydro_viz_type
      if(!input$hydro_compare_sites | input$hydro_viz_type == "hydro_periodo"){
        my_data <-  my_data %>% filter(ID_SITE == input$hydro_site)
        hydro_data <-  hydro_data %>% filter(ID_SITE == input$hydro_site)
        plot_name <- paste(plot_name, input$hydro_site, sep="_")
      } 
      outliers <- anti_join(my_data, hydro_data, by=c("DATE", "ID_SITE", input$hydro_y))
      # RAW visualisation
      if(input$hydro_viz_type %in% c("hydro_raw_dat", "hydro_cleaned_dat")){
        my_plot <- plot_raw_ts(my_data, input$hydro_y, input$hydro_x_lab, input$hydro_y_lab, outliers)
      }
      # Distrib viz
      else if(input$hydro_viz_type == "hydro_distrib_dat"){
        plots <- plot_distrib(my_data, input$hydro_y, input$hydro_x_lab, input$hydro_y_lab)
        my_plot <- plots$hist
      }
      
      if(input$hydro_viz_type == "hydro_distrib_dat"){
        my_plot <- plot_grid(plots$boxplot, plots$hist, align = "v", ncol = 1, rel_heights = c(1, 6))
      }
      print(my_plot)
      output$download_hydro_p1 <- download_plot(plot_name, my_plot)
      
    }
  })
  
  
  
  
  output$hydro_plot2 <- renderPlot({
    plot_name <- input$hydro_viz_type
    if(input$hydro_viz_type %in% c("hydro_raw_dat", "hydro_cleaned_dat", "hydro_distrib_dat")){
      my_data <- retrieve_data(input$hydro_viz_type)
      if(!input$hydro_compare_sites){
        my_data <-  my_data %>% filter(ID_SITE == input$hydro_site)
        hydro_data <-  hydro_data %>% filter(ID_SITE == input$hydro_site)
        if(!is.null(values$selected_data)){
          values$selected_data <- values$selected_data %>% filter(ID_SITE == input$hydro_site)
        }
        plot_name <- paste(plot_name, "box", input$hydro_site, sep="_")
      } 
      outliers <- anti_join(my_data, hydro_data, by=c("DATE", "ID_SITE", input$hydro_y))
      # Raw viz
      if(input$hydro_viz_type %in% c("hydro_raw_dat", "hydro_cleaned_dat")){
        my_plot <- plot_box(my_data, input$hydro_y, input$hydro_x_lab, input$hydro_y_lab)
      }
      # Distrib viz
      else if(input$hydro_viz_type == "hydro_distrib_dat"){
        my_plot <- plot_raw_ts(my_data, input$hydro_y, input$hydro_x_lab, input$hydro_y_lab, outliers, values$selected_data)
      }
      
      print(my_plot)
      output$download_hydro_p2 <- download_plot(plot_name, my_plot)
    }
  })
  
  
  
  #------PICONANO OUTPUT ----
  
  ##notes 
  output$piconano_notes <- renderUI({
    title <- switch(input$piconano_viz_type,
                   "piconano_raw_dat" = "",
                   "piconano_distrib_dat" = "")
    text <- switch(input$piconano_viz_type,
                   "piconano_raw_dat" = "",
                   "piconano_distrib_dat" = "")
    column(12, tags$b(title),
           br(),
           text)
  })
  
  ##download button 
  output$btn_piconano_p1 <- renderUI({
    if(input$piconano_viz_type != ""){
      downloadButton(outputId = "download_piconano_p1", label = "Download plot")
    }
  })
  
  output$btn_piconano_p2 <- renderUI({
    if(input$piconano_viz_type %in% c("piconano_raw_dat", "piconano_cleaned_dat", "piconano_reg_v1")){
      downloadButton(outputId = "download_piconano_p2", label = "Download plot")
    }
  })
  
  # PLOT 1
  output$piconano_plot1 <- renderPlot({
    if(input$piconano_viz_type != ""){
      my_data <- retrieve_data(input$piconano_viz_type)
      plot_name <- input$piconano_viz_type
      if(!input$piconano_compare_sites){
        my_data <-  my_data %>% filter(ID_SITE == input$piconano_site)
        piconano_data <-  piconano_data %>% filter(ID_SITE == input$piconano_site)
        plot_name <- paste(plot_name, input$piconano_site, sep="_")
      } 
      outliers <- anti_join(my_data, piconano_data, by=c("DATE", "ID_SITE", input$piconano_y))
      # RAW visualisation
      if(input$piconano_viz_type %in% c("piconano_raw_dat", "piconano_cleaned_dat")){
        my_plot <- plot_raw_ts(my_data, input$piconano_y, input$piconano_x_lab, input$piconano_y_lab, outliers)
      }
      
      # Distrob viz
      else if(input$piconano_viz_type == "piconano_distrib_dat"){
        plots <- plot_distrib(my_data, input$piconano_y, input$piconano_x_lab, input$piconano_y_lab)
        my_plot <- plots$hist
      }
      
      
      if(input$piconano_viz_type == "piconano_distrib_dat"){
        my_plot <- plot_grid(plots$boxplot, plots$hist, align = "v", ncol = 1, rel_heights = c(1, 6))
      }
      print(my_plot)
      output$download_piconano_p1 <- download_plot(plot_name, my_plot)
    }
  })
  
  # PLOT 2
  output$piconano_plot2 <- renderPlot({
    plot_name <- input$piconano_viz_type
    if(input$piconano_viz_type %in% c("piconano_raw_dat", "piconano_cleaned_dat", "piconano_distrib_dat")){
      my_data <- retrieve_data(input$piconano_viz_type)
      if(!input$piconano_compare_sites){
        my_data <-  my_data %>% filter(ID_SITE == input$piconano_site)
        piconano_data <-  piconano_data %>% filter(ID_SITE == input$piconano_site)
        if(!is.null(values$selected_data)){
          values$selected_data <- values$selected_data %>% filter(ID_SITE == input$piconano_site)
        }
        plot_name <- paste(plot_name, "box", input$piconano_site, sep="_")
      } 
      outliers <- anti_join(my_data, piconano_data, by=c("DATE", "ID_SITE", input$piconano_y))
      
      # Time serie viz
      if(input$piconano_viz_type %in% c("piconano_raw_dat", "piconano_cleaned_dat")){
        my_plot <- plot_box(my_data, input$piconano_y, input$piconano_x_lab, input$piconano_y_lab)
      }
      # Distrib viz
      else if(input$piconano_viz_type == "piconano_distrib_dat"){
        my_plot <- plot_raw_ts(my_data, input$piconano_y, input$piconano_x_lab, input$piconano_y_lab, outliers, values$selected_data)
      }
      
      print(my_plot)
      output$download_piconano_p2 <- download_plot(plot_name, my_plot)
    }
  })
  
  
}