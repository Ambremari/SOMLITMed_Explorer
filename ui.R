### User Interface 
source("main.R")


#----- HOME PANELS ----
home_panel <- fluidPage(
  style = "max-width: 1000px; margin: 0 auto;",
  tags$h1("Mediterranean SOMLIT Time Series Explorer"),
  tags$h2("About"),
  tags$div(style = "font-size: 15px;", 
           "This R Shiny app is a visualization tool for exploring time series from the National Observation Service (SNO) SOMLIT (https://somlit.fr). It covers the 2012–2025 period and includes data from three monitoring sites in the northwestern Mediterranean Sea: Marseille, Banyuls and Villefranche.

The monitoring sites are sampled bi-weekly following standardized protocols. The data presented here include surface samples only. Hydrological and biogeochemical variables include temperature, salinity,chlorophyll a,  ammonium, nitrate, nitrite, phosphate and orthosilicic acid. Pico- and nanophytoplankton assemblages are characterized by flow cytometry. All samples are analysed at the BioPIC platform (Observatoire Océanologique de Banyuls, France).

Seven groups are distinguished: RedPicoProk, OraPicoProk, RedPico, OraNano, RedNano, HetHNA and HetLNA. A more detailed description of these groups is provided by Thyssen et al. (2022) and in the Natural Environment Research Council (NERC) Vocabulary Server (https://vocab.nerc.ac.uk/collection/F02/current/).

For more details, please refer to the related documents below."),
  br(),
  tags$h2("Related documents"),
  tags$div(style = "font-size: 15px;", 
           "Couteyen Carpaye, M., Nerini, D., Garcia, F., Lagadec, V., Nunige, S., Pecqueur, D., Salmeron, C., Buniak, L., Didry, M., Feuerstein, J.-M., and Grégori, G.: Reconstructing pico- and nanophytoplankton assemblages from long-term coastal thermohaline observations, EGUsphere [preprint], https://doi.org/10.5194/egusphere-2026-3454, 2026."),
  br(),
  tags$h2("Related dataset"),
  tags$div(style = "font-size: 15px;", 
           "Savoye Nicolas, Lizon Fabrice, Breton Elsa, Claquin Pascal, Joly Orianne, Sultan Emmanuelle, Jung Jean-Luc, Bozec Yann, Boulart Cédric, Rimmelin-Maury Peggy, Leynaert Aude, Agogué Hélène, Pineau Philippe, Del amo Yolanda, Conan Pascal, Mostajir Behzad, Grégori Gérald, Mousseau Laure, Mendès Fabrice (2026). SOMLIT (Service d'Observation en Milieu Littoral) time series (French Research Infrastructure ILICO): long-term core parameter monitoring of French coasts. SEANOE. https://doi.org/10.17882/100323"),
  br(),
  tags$h2("Monitoring sites"),
  navlistPanel(
    "Mediterranean Sea",
    br(),
    tabPanel("Marseille", 
             tags$h3("Frioul, Marseille"),
             column(7, tags$figure(
               tags$img(src = "Marseille.png",
                        width = "100%"))),
             column(5, tags$div(style = "font-size: 15px;",
                                "",
                                tags$br(),
                                ""))),
    tabPanel("Villefranche", 
             tags$h3("Point B, Villefranche"),
             column(7, tags$figure(
               tags$img(src = "Villefranche.png",
                        width = "100%"))),
             column(5, tags$div(style = "font-size: 15px;",
                                "",
                                tags$br(), 
                                ""))),
    tabPanel("Banyuls",
             tags$h3("Sola, Banyuls"),
             column(7, tags$figure(
               tags$img(src = "Banyuls.png",
                        width = "100%"))),
             column(5, tags$div(style = "font-size: 15px;",
                                "",
                                tags$br(), 
                                ""))),
    widths = c(2, 9)
  ),
  br(),
  tags$h3("References"),
  tags$div(style = "font-size: 15px;", 
           "Thyssen M, Grégori G, Créach V, Lahbib S, Dugenne M, Aardema HM, Artigas L-F, Huang B, Barani A, Beaugeard L, Bellaaj-Zouari A, Beran A, Casotti R, Del Amo Y, Denis M, Dubelaar GBJ, Endres S, Haraguchi L, Karlson B, Lambert C, Louchart A, Marie D, Moncoiffé G, Pecqueur D, Ribalet F, Rijkeboer M, Silovic T, Silva R, Marro S, Sosik HM, Sourisseau M, Tarran G, Van Oostende N, Zhao L and Zheng S (2022) Interoperable vocabulary for marine microbial flow cytometry. Front. Mar. Sci. 9:975877. doi: 10.3389/fmars.2022.975877"),
  br(),
  tags$h3("Citation"),
  p(
    "If you use SOMLITMed Explorer in your work, please cite:"
  ),
  p(
    em("Citation to be provided.")
  ),
  br(),
  tags$h3("Funding"),
  tags$div(style = "font-size: 15px;", 
           "This application was developed as part of the doctoral thesis of Mathilde Couteyen Carpaye at Aix-Marseille University, within the CYTOMED project. The project was co-funded by the French Office for Biodiversity (OFB) and the Rhône-Méditerranée-Corse Water Agency (AERMC)."),
  br(),
  tags$h3("Contact"),
  p(
    strong("Mathilde Couteyen Carpaye"),
    br(),
    "PhD student – Mediterranean Institute of Oceanography (MIO)",
    br(),
    "Aix-Marseille Université"
  ),
  p(
    "For questions, comments or technical issues, please contact ",
    a(
      "mathilde.couteyen@mio.osupytheas.fr",
      href = "mathilde.couteyen@mio.osupytheas.fr"
    ),
    "."
  ),
)

# HOME TAB ----
home_tab <- tabPanel(
  "Home",
  home_panel,
  value = "home"
)

#----- VISUALISATION PANELS ----
##---- HYDRO DATA ----
hydro_panel <- fluidPage(
  br(),
  sidebarPanel(
    tags$b("Select the visualization to display"),
    selectInput(
      inputId = "hydro_viz_type",
      label = "",
      choices = c("Time series" = "hydro_raw_dat",
                  "Data distribution" = "hydro_distrib_dat"),
      selected = "hydro_raw_dat"
    ),
    # Select stations
    checkboxInput(
      inputId = "hydro_compare_sites",
      label = "Compare sites", 
      value = FALSE
    ),
    selectInput(
      inputId = "hydro_site",
      label = "Site",
      choices = stations,
      selected = stations[2]
    ),
    # Select variable for y-axis
    selectInput(
      inputId = "hydro_y",
      label = "Y-axis:",
      choices = hydro_columns,
      selected = hydro_columns[1]
    ),
    br(), 
    tags$b("Set axis labels"),
    br(),
    column(6, textInput(
      inputId = "hydro_x_lab",
      label = "X-axis label",
      value = ""
    )),
    column(6, textInput(
      inputId = "hydro_y_lab",
      label = "Y-axis label",
      value = ""
    )),
    br(),
    uiOutput("hydro_notes"),
    br(),
    uiOutput("hydro_comments")
  ),
  
  mainPanel(
    br(),
    withSpinner(plotOutput("hydro_plot1", 
                           height = "360px",
                           click = "hydro_plot1_click")),
    column(2, uiOutput("btn_hydro_p1")),
    br(),
    withSpinner(plotOutput("hydro_plot2", height = "360px")),
    column(2, uiOutput("btn_hydro_p2"))
  )
)

##---- PICONANO DATA ----
piconano_panel <- fluidPage(
  style = "max-width: 1500px; margin: 0 auto;",
  br(),
  sidebarPanel(
    tags$b("Select the visualization to display"),
    selectInput(
      inputId = "piconano_viz_type",
      label = "",
      choices = c("Time series" = "piconano_raw_dat",
                  "Data distribution" = "piconano_distrib_dat"),
      selected = "piconano_raw_dat"
    ),
    # Select stations
    checkboxInput(
      inputId = "piconano_compare_sites",
      label = "Compare sites", 
      value = FALSE
    ),
    selectInput(
      inputId = "piconano_site",
      label = "Site",
      choices = stations,
      selected = stations[2]
    ),
    # Select variable for y-axis
    selectInput(
      inputId = "piconano_y",
      label = "Y-axis:",
      choices = unname(choices_piconano),
      selected = unname(choices_piconano)[1]
    ),
    br(), 
    tags$b("Set axis labels"),
    br(),
    column(6, textInput(
      inputId = "piconano_x_lab",
      label = "X-axis label",
      value = ""
    )),
    column(6, textInput(
      inputId = "piconano_y_lab",
      label = "Y-axis label",
      value = ""
    )),
    br(),
    uiOutput("piconano_notes"),
    br(),
    uiOutput("piconano_comments")
  ),
  
  mainPanel(
    br(),
    withSpinner(plotOutput("piconano_plot1", height = "360px")),
    column(2, uiOutput("btn_piconano_p1")),
    br(),
    withSpinner(plotOutput("piconano_plot2", height = "360px")),
    column(2, uiOutput("btn_piconano_p2"))
  )
)

# ---- VISUALISATION TAB ---- 
viz_tab <- tabPanel(
  "Data visualization",
  value = "viz", 
  div(
    style = "max-width: 1200px; margin: 0 auto;",
    tabsetPanel( 
      tabPanel("HYDRO", hydro_panel), 
      tabPanel("PICONANO", piconano_panel)
    )
  )
)




#----- NAVIGATION LAYOUT ----
tagList(
  tags$link(rel = "stylesheet", type = "text/css", href = "somlit_style.css"),
  navbarPage(
    "SOMLITMed Explorer",
    home_tab,
    viz_tab,
    theme = "paper",
    footer = tags$div(
      class = "app-footer",
      style = "text-align: center; padding: 10px 0; font-size: 0.85em; color: #666;",
      "© 2026 Mathilde Couteyen Carpaye — SOMLITMed Explorer"
    )
  )
)

