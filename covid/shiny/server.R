library(shiny)
library(leaflet)


shinyServer(function(input, output, session) {
    
    observe({
        tempDF <- shp@data
        tempDF <- tempDF[tempDF$State == input$state, ]
        updateSelectInput(session, "county", choices = sort(unique(as.character(tempDF$Name))))
    })
    
    zoomReactive <- reactive({
        tempDF <- shp[shp$State == input$state, ]
        tempDF <- tempDF[tempDF$Name == input$county, ]
        return(tempDF)
    })
    
    mapDFReactive <- reactive({
        cols <- c("Name", input$social, 'longitude', 'latitude', 'radius', 'PrcSDstc')
        tempDF <- shp[cols]
        names(tempDF@data)[2] <- c("variable")
        return(tempDF)
    })
    
    frontierReactive <- reactive({
        dta <- pfTable()
        pf <- psel(dta, low(variable) * low(PrcSDstc)) 
        print(head(pf))
        return(pf)
    })
    
    pfTable <- reactive({
        tempDF <- shp@data
        tempDF <- tempDF[complete.cases(tempDF), ]
        cols <- c("Name", input$social, 'PrcSDstc')
        tempDF <- tempDF[cols]
        names(tempDF)[2] <- c("variable")
        return(tempDF)
    })
    
    output$socialMap <- renderLeaflet({
        
        dta <- mapDFReactive()

        binpal <- colorBin("Greens", dta$variable, 6, pretty = FALSE)
        
        leaflet() %>%
            setView(lat = 37.0902, lng = -95.7129, zoom = 3) %>%
            addTiles() %>%
            addPolygons(data = dta, stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
                        color = ~binpal(variable), popup = ~paste(variable)) %>%
            addCircles(data = dta, lng = ~longitude, lat = ~latitude, fillColor = 'red',
                             radius = dta$radius * 15000, stroke = FALSE, popup = ~paste(dta$PrcSDstc))

    })
    
    output$tbl <- renderDataTable({
        frontierReactive()
    })
    
    observe({
        
        tempCoords <- zoomReactive()
        
        leafletProxy("socialMap") %>%
            clearGroup('tempCounty') %>%
            setView(lat = tempCoords$latitude, lng = tempCoords$longitude, zoom = 9) %>%
            addPolygons(data = tempCoords, stroke = TRUE, fillColor = "transparent", group = "tempCounty")
        
    })
    
    observe({

        temp <- frontierReactive()

        tempSHP <- shp[shp$Name %in% temp$Name, ]

        leafletProxy("socialMap") %>%
            clearGroup("tempPF") %>%
            addPolygons(data = tempSHP, stroke = TRUE, fillColor = "transparent", group = "tempPF")




    })

})

