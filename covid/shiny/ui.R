shinyUI(fluidPage(
  
  h2("Social and Digital Inequities & Economic Recovery in the United States", align = "center"),
  
  column(12,
         
    column(6,
  
      h4("Choose a socioeconomic indicator"), 
      
      selectInput("social", " ", choices = c("Median Income" = "MdianInc", "Internet Access" = "PercInt", 
                                             "Percent Republican" = "PERC_GOP", "Percent Democrat" = "PERC_DEM",
                                             "Perent with a Bachelor's Degree or Higher" = "PrcBch_Deg",
                                             "Percent African American",
                                             "Percent Hispanic"))
    
    ),
    
    column(6,
    
      selectInput('state', "Select your State", choices = c("All States", sort(unique(as.character(shp@data$State))))),
    
      selectInput('county', "Select your County", choices = "")
    
    )
  
  ),
  
  column(12,
         
    column(6,  
           
      leafletOutput('socialMap')
      
    ),
    
    column(6,
           
      DTOutput('tbl')
           
    )
    
  )
  
))




