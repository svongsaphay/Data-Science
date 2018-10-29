fluidPage(
    navbarPage(
      
      ########## home page ###########
      title = "HallStat", 
      id ="main",
      theme = shinytheme("slate"), 
      tabPanel("Home",
               tags$head(
                 tags$style(HTML(".my_style_1{ margin-top: -20px; margin-left: -15px; margin-right: -15px;
                                 background-image: url(http://www.scottsfortcollinsauto.com/lg/wp-content/uploads/Stay-Safe-on-New-Year%E2%80%99s-Eve-Don%E2%80%99t-Drink-and-Drive.jpeg);
                                 background-size: 100% auto;background-repeat: no-repeat
                                 }"))),
             class="my_style_1",
             fluidPage(
               fluidRow(
                 
                 column(4,
                        br(),br(),br(),br(),
                        h2(tags$em("Champagne is one of the elegant extras in life.")),
                        h4(tags$em("- Charles Dickens")))
               ),
               fluidRow(
                 br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),""
               )
             )
                 ),
      ########## home page ###########
      
      
      ########## Explore the market ########### 
      tabPanel("Explore the market",
               sidebarLayout(
                 sidebarPanel(         
                   fluidRow(
                     column(
                       width = 12,
                       style = "background-color: #373435",
                       h4('Select the type of division, SAQ banners and divisions, then submit'),
                       br(),
                       radioButtons('typeofdivision', "Type of division", 
                                    choices=c('City','Region')),
                       selectInput('plotbanners', 'SAQ banners', 
                                   choices = c('All',sort(unique(as.character(data$Banner))))),
                       uiOutput('variables'),
                       br (),
                       actionButton(inputId='updateplots',label="Submit"),
                       br(), br()
                     )
                   ),
                   width = 3
                 ),
                 mainPanel( 
                   fluidRow(
                     column(6, plotOutput(outputId = "plot1", width = "500px", height = "320px"),
                            br(),
                            br(),
                            br()),
                     column(6, plotOutput(outputId = "plot2", width = "500px", height = "320px"),
                            br(),
                            br(),
                            br())
                   ),
                   fluidRow(
                     column(12, textOutput('selected_text1'),
                            br(),
                            textOutput('selected_text2'),
                            br(),
                            textOutput('selected_text3'),
                            br(),
                            textOutput('selected_text4'),
                            br(),
                            textOutput('selected_text5')
                            
                     )
                   )
                 )
               )
      ),
      ########## Explore the market ########### 
      
      
      
      ########## data ########### 
      tabPanel("View the data",
               sidebarLayout(
                 sidebarPanel(         
                   fluidRow(
                     column(
                       width = 12,
                       style = "background-color:#373435",
                       h4('Select the type of division, SAQ banners, categories, products and divisions'),
                       br(),
                       radioButtons('typeofdivisiondata', "Type of division", 
                                    choices=c('City','Region')),
                       selectInput('tablebanners',
                                   'SAQ banners',
                                   choices = c('All',sort(unique(as.character(data$Banner))))),
                       selectInput('tablecategory',
                                   'Categories',
                                   choices = c('All',sort(unique(as.character(data$Nature.of.product))))),
                       selectInput('tableproduct',
                                   'Products',
                                   choices = c('All',sort(unique(as.character(data$Description))))),
                       uiOutput('variablesdata'),
                       br(),br()
                     )),
                   width=3),
                 mainPanel(
                   fluidRow(
                     DT::dataTableOutput(outputId="dTable") 
                   )
                 )))
      ########## data ########### 
      
               ))