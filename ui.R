### User Interface 

# Bloc de texte avec la taille de police commune à toute la page
body_text <- function(...) {
  tags$div(style = "font-size: 15px;", ...)
}

# Lien externe (s'ouvre dans un nouvel onglet)
# .noWS = "outside" : pas d'espace ajouté avant/après le lien
# (les espaces éventuels doivent être écrits explicitement dans le texte)
ext_link <- function(url, label = url) {
  tags$a(label, href = url, target = "_blank", rel = "noopener noreferrer",
         .noWS = "outside")
}

# Onglet d'un site de suivi : titre, image (dossier www/) et description
# (la description est optionnelle : à remplir plus tard)
site_panel <- function(tab_title, heading, img, description = NULL) {
  tabPanel(
    tab_title,
    tags$h3(heading),
    column(7, tags$figure(tags$img(src = img, width = "100%"))),
    column(5, body_text(description))
  )
}


# ---- Page d'accueil ---------------------------------------------------------

home_panel <- fluidPage(
  style = "max-width: 1000px; margin: 0 auto;",
  
  tags$h1("Mediterranean SOMLIT Time Series Explorer"),
  
  # -- About ------------------------------------------------------------------
  tags$h2("About"),
  body_text(
    tags$p(
      "This R Shiny app is a visualization tool for exploring time series from
      the National Observation Service (SNO) SOMLIT (",
      ext_link("https://somlit.fr"),
      "). It covers the 2012\u20132025 period and includes data from three
      monitoring sites in the northwestern Mediterranean Sea: Marseille,
      Banyuls and Villefranche."
    ),
    tags$p(
      "The monitoring sites are sampled bi-weekly following standardized
      protocols. The data presented here include surface samples only.
      Hydrological and biogeochemical variables include temperature, salinity,
      chlorophyll a, ammonium, nitrate, nitrite, phosphate and orthosilicic
      acid. Pico- and nanophytoplankton assemblages are characterized by flow
      cytometry. All samples are analysed at the BioPIC platform (Observatoire
      Oc\u00e9anologique de Banyuls, France)."
    ),
    tags$p(
      "Seven groups are distinguished: RedPicoProk, OraPicoProk, RedPico,
      OraNano, RedNano, HetHNA and HetLNA. A more detailed description of these
      groups is provided by Thyssen et al. (2022) and in the Natural
      Environment Research Council (NERC) Vocabulary Server (",
      ext_link("https://vocab.nerc.ac.uk/collection/F02/current/"),
      ")."
    ),
    tags$p("For more details, please refer to the related documents below.")
  ),
  br(),
  
  # -- Related documents ------------------------------------------------------
  tags$h2("Related documents"),
  body_text(
    "Couteyen Carpaye, M., Nerini, D., Garcia, F., Lagadec, V., Nunige, S.,
    Pecqueur, D., Salmeron, C., Buniak, L., Didry, M., Feuerstein, J.-M., and
    Gr\u00e9gori, G.: Reconstructing pico- and nanophytoplankton assemblages
    from long-term coastal thermohaline observations, EGUsphere [preprint], ",
    ext_link("https://doi.org/10.5194/egusphere-2026-3454"),
    ", 2026."
  ),
  br(),
  
  # -- Related dataset --------------------------------------------------------
  tags$h2("Related dataset"),
  body_text(
    "Savoye Nicolas, Lizon Fabrice, Breton Elsa, Claquin Pascal, Joly Orianne,
    Sultan Emmanuelle, Jung Jean-Luc, Bozec Yann, Boulart C\u00e9dric,
    Rimmelin-Maury Peggy, Leynaert Aude, Agogu\u00e9 H\u00e9l\u00e8ne, Pineau
    Philippe, Del amo Yolanda, Conan Pascal, Mostajir Behzad, Gr\u00e9gori
    G\u00e9rald, Mousseau Laure, Mend\u00e8s Fabrice (2026). SOMLIT (Service
    d'Observation en Milieu Littoral) time series (French Research
    Infrastructure ILICO): long-term core parameter monitoring of French
    coasts. SEANOE. ",
    ext_link("https://doi.org/10.17882/100323")
  ),
  br(),
  
  # -- Monitoring sites -------------------------------------------------------
  tags$h2("Monitoring sites"),
  navlistPanel(
    "Mediterranean Sea",
    br(),
    site_panel("Marseille",    "Frioul, Marseille",    "Marseille.png"),
    site_panel("Villefranche", "Point B, Villefranche", "Villefranche.png"),
    site_panel("Banyuls",      "Sola, Banyuls",         "Banyuls.png"),
    widths = c(2, 9)
  ),
  br(),
  
  # -- References -------------------------------------------------------------
  tags$h3("References"),
  body_text(
    "Thyssen M, Gr\u00e9gori G, Cr\u00e9ach V, Lahbib S, Dugenne M, Aardema HM,
    Artigas L-F, Huang B, Barani A, Beaugeard L, Bellaaj-Zouari A, Beran A,
    Casotti R, Del Amo Y, Denis M, Dubelaar GBJ, Endres S, Haraguchi L,
    Karlson B, Lambert C, Louchart A, Marie D, Moncoiff\u00e9 G, Pecqueur D,
    Ribalet F, Rijkeboer M, Silovic T, Silva R, Marro S, Sosik HM, Sourisseau
    M, Tarran G, Van Oostende N, Zhao L and Zheng S (2022) Interoperable
    vocabulary for marine microbial flow cytometry. ",
    em("Front. Mar. Sci."),
    " 9:975877. doi: ",
    ext_link("https://doi.org/10.3389/fmars.2022.975877",
             "10.3389/fmars.2022.975877")
  ),
  br(),
  
  # -- Citation ---------------------------------------------------------------
  tags$h3("Citation"),
  p("If you use SOMLITMed Explorer in your work, please cite:"),
  p(em("Couteyen Carpaye, M. (2026). SOMLITMed Explorer [Computer software]. Zenodo.",
       ext_link("https://doi.org/10.5281/zenodo.23039092")
  )),
  br(),
  
  # -- Funding ----------------------------------------------------------------
  tags$h3("Funding"),
  body_text(
    "This application was developed as part of the doctoral thesis of Mathilde
    Couteyen Carpaye at Aix-Marseille University, within the CYTOMED project.
    The project was co-funded by the French Office for Biodiversity (OFB) and
    the Rh\u00f4ne-M\u00e9diterran\u00e9e-Corse Water Agency (AERMC)."
  ),
  br(),
  
  # -- Contact ----------------------------------------------------------------
  tags$h3("Contact"),
  p(
    strong("Mathilde Couteyen Carpaye"),
    br(),
    "PhD student \u2013 Mediterranean Institute of Oceanography (MIO)",
    br(),
    "Aix-Marseille Universit\u00e9"
  ),
  p(
    "For questions, comments or technical issues, please contact ",
    a("mathilde.couteyen@mio.osupytheas.fr",
      href = "mailto:mathilde.couteyen@mio.osupytheas.fr",
      .noWS = "outside"),
    "."
  )
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

