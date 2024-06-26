  library(dplyr)
  library(stringr)
  library(ggplot2)
  library(tidyr)
  library(DT)
  library(leaflet)
  library(leaflet.providers)
  library(htmltools)
  library(htmlwidgets)
  library(mapview)
  library(leafem)
  library(sf)
  library(plotly)
  library(viridis)
  library(shiny)
  library(shinydashboard)
  library(shinyWidgets)
  library(shinyBS)
  library(RColorBrewer)
  library(FDPDataAtlas)
  
  if (webshot::is_phantomjs_installed() == FALSE) {
    webshot::install_phantomjs()
  }
  
  easyprint_js_file <- "https://rawgit.com/rowanwins/leaflet-easyPrint/gh-pages/dist/bundle.js"
  
  # sidebar
  sidebar <- dashboardSidebar(
    sidebarMenu(
      id = "main_sidebar",
      menuItem("Data Atlas",
               tabName = "home",
               icon = icon("map")
      ),
      menuItem("Descriptive Plots",
               tabName = "descplots",
               icon = icon("home")
      ),
      menuItem("Heatmap",
               tabName = "heatmap",
               icon = icon("fire")
      ),
      menuItem("Database",
               tabName = "data",
               icon = icon("database")
      ),
      menuItem("Data Dictionary",
               tabName = "data-dictionary",
               icon = icon("list")
      ),
      menuItem("About",
               tabName = "about",
               icon = icon("question")
      ),
      menuItem("View Code",
               href = "https://github.com/takaakimasaki/FDPDataAtlas",
               icon = icon("github")
      )
    )
  )
  
  # home
  home <- tags$html(
    tags$head(
      includeHTML("www/google-analytics.html"),
      tags$title("Forced Displacement Microdata"),
      tags$script(src = easyprint_js_file)
    ),
    tags$style(
      type = "text/css",
      "#map {height: 70vh !important;}"
    ),
    tags$body(
      leafletOutput("map")
    )
  )
  
  # body
  body <- dashboardBody(
    tag("style", HTML("
                      .right-side {
                      background-color: #dbf0ee;
                      }
                      .skin-blue .main-header .logo {
                      background-color: #009FDA;
                      color: #ffffff;
                      }
                      .skin-blue .main-header .logo:hover {
                      background-color: #0072BC;
                      }
                      .skin-blue .main-header .navbar {
                      background-color: #009FDA;
                      }
                      .skin-blue .main-header .sidebar-toggle {
                      background-color: #0072BC;
                      }
                      ")),
    tabItems(
      tabItem(
        tabName = "about",
        fluidRow(
          column(
            12, wellPanel(
              htmlOutput("start_text")
            ),
            wellPanel(style = "background-color: transparent; border: none",
                      fluidRow(
                        h3("Developed by"),
                        a(href = "https://www.jointdatacenter.org/", target="_blank", img(src = "logos.png", alt = "Joint Data Center on Forced Displacement (World Bank & UNHCR)", width = "300px"))
                      )
            )
          )
        )
      ),
      tabItem(
        tabName = "home",
        fluidRow(column(9,
                        align="center",
                        HTML("<b><span style='color: #006d2c;'>Circles</span></b> represent the number of surveys available. Click on a country to view the datasets available.")
                        )),
        fluidRow(
          column(9,
                 box(width = 12, home), style = "padding-right: 0px;"), # show map
          column(3, wellPanel(
            fluidRow(
              selectInput(
                inputId = "selected_variable",
                label = "Basemaps available",
                choices = unique(FDPDataAtlas::ref_data$indicator),
                selected = unique(FDPDataAtlas::ref_data$indicator)[1]
              )
            ),
            tags$style(type='text/css', '#country_info { max-height: 600px; overflow-y: auto; }'),
            uiOutput("country_info")), style = "padding-left: 0px;")
        ),
        fluidRow(column(12,"The boundaries, colors, denominations, and other information shown on any map in this work do not imply any judgment on the part of The World Bank or UNHCR concerning the legal status of any territory or the endorsement or acceptance of such boundaries."))
      ),
      tabItem(
        tabName = "data",
        fluidRow(
          column(
            12,
            DT::dataTableOutput("filtered_table")
          )
        )
      ),
      tabItem(tabName = "descplots",
              fluidRow(
                column(12, uiOutput("location_plot_selector"))  # Full width
              ),
              plotlyOutput("plot2", width = "100%", height = "75vh")
      ),
      tabItem(
        tabName = "heatmap",
        fluidRow(
          uiOutput("heatmap_selector")
        ),
        fluidRow(
          plotlyOutput("heatmap", width = "100%", height = "75vh")
        )
      ),
      tabItem(
        tabName = "data-dictionary",
        fluidRow(
          column(12, wellPanel(
            h3("Data Dictionary"),
            DT::dataTableOutput("data_summary")
          )
          )
        )
      )
    )
  )
  
  shinyUI(
    dashboardPage(
      dashboardHeader(title = "Forced Displacement Microdata",titleWidth = "97%"),
      sidebar,
      body
    )
  )