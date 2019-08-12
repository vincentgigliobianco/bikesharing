source("packages.R")
source("config.R")

ui <- dashboardPage(
  skin = "black",
  
  # le DASHBOARD HEADER
  dashboardHeader(title = "Dashboard"),
  
    
  # le DASHBOARD SIDEBAR
  dashboardSidebar(
    
    # les options sidebar
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    
    sidebarMenu(
      menuItem("Time series of Y", tabName = "ONGLET_draft", icon = icon("plane")),
      menuItem("2D Graph", tabName = "ONGLET_offset", icon = icon("plane")),
      menuItem("3D Graph", tabName = "ONGLET_habits", icon = icon("plane")),
      menuItem("Help", tabName = "ONGLET_recherche", icon = icon("plane")),
    
      selectInput(
        inputId = "selected_var",
        label = "Selectionnez une variable",
        choices = all_var_names,
        selected = all_var_names[1],
        selectize = TRUE
      ),
      selectInput(
        inputId = "selected_var_bis",
        label = "Selectionnez une variable",
        choices = all_var_names,
        selected = all_var_names[2],
        selectize = TRUE
      ),
      sliderInput("selected_period",
                  label = "Sélectionnez une période:",
                  min = min(df$datetime),
                  max = max(df$datetime),
                  dragRange = T,
                  value = c(min(df$datetime),max(df$datetime)),
                  timeFormat="%Y-%m-%d")
      
    
      # actionButton(inputId = "button_next",label ="Suivant"),
      
      # radioButtons(inputId="decision",
      #              label="Faites votre choix",
      #              choices = c("match","doubt","unmatch"),
      #              selected = NULL,
      #              inline = FALSE,
      #              width = NULL,
      #              choiceNames = NULL,
      #              choiceValues = NULL),
      # actionButton("goButton", "Save")
      
    
    ) # fin de la sidebar menu
    
    
    
    
  ), # fin de la dashboardsidebar
  
  
  
  
  
  # LE DASHBOARD BODY
  dashboardBody(
    
    # Les styles
    tags$style(type="text/css",
               ".shiny-output-error { visibility: hidden; }",
               ".shiny-output-error:before { visibility: hidden; }"
    ),
    
    
    
    
    
    
    
    tabItems(
      
      
      
      
      
      
      
      # Debut onglet draft
      tabItem(
        tabName = "ONGLET_draft",
        
        
        # ROW 1 - Onglet draft
        fluidRow(
          box(
            collapsible = TRUE,
            collapsed = FALSE,
            solidHeader = TRUE,
            status = "primary",
            title="Time Series du Training Set",
            width=12,
            dygraphOutput("mydygraph")
          )
        ),
        fluidRow(
          # box(
          #   collapsible = TRUE,
          #   collapsed = FALSE,
          #   solidHeader = TRUE,
          #   status = "primary",
          #   title="Carte des geoclusters de l'id",
          #   width=6,
          #   verbatimTextOutput("info")
          # ),
        ),
        fluidRow(
        ),
        fluidRow(
        ),
        fluidRow(
        ),
        fluidRow(
        )
        
      ), # FIN ONGLET draft
      
      
      
      
      
      
      # Debut onglet offset
      tabItem(
        tabName = "ONGLET_offset",
        
        # ROW 1 - Onglet offset
        fluidRow(
          box(
            collapsible = TRUE,
            collapsed = FALSE,
            solidHeader = TRUE,
            status = "primary",
            title="2D graph",
            width=12,
            plotOutput("my2Dplot")
          )
        )
      
      ), # FIN ONGLET OFFSET, rajouter virgule apres parenthese si autre onglet
      
      
    
      # début Onglet habits
      tabItem(
        tabName = "ONGLET_habits",

        # ROW 1 - Onglet HABITS
        fluidRow(
          box(
            collapsible = TRUE,
            collapsed = FALSE,
            solidHeader = TRUE,
            status = "primary",
            title="3D graph",
            width=12,
            plotOutput("my3Dplot")
          )
        ),
        fluidRow(
        ),
        fluidRow(
        ),
        fluidRow(
        ),
        fluidRow(
        ),
        fluidRow(
        ),
        fluidRow(
        )
      ), # fin onglet habits
      
      
      
      
      
      # Debut onglet RECHERCHE
      tabItem(
        tabName = "ONGLET_recherche",
        # R1 - Onglet recherche
        fluidRow(
        box(
          collapsible = TRUE,
          collapsed = FALSE,
          solidHeader = TRUE,
          status = "primary",
          title="Variables definition",
          width=12,
          includeMarkdown("variables_def.md")
        )
        )
      ) # Fin ONGLET RECHERCHE
      
      
      
      
    
    ) # fin de tabitems global
    
    
    
    
    
    
  ) # fin dashboard body
  
  
) # fin dashboard page














