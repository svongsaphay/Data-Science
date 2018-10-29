function(input, output, session){
  
  outVar <- reactive({
    if(input$typeofdivision=='City'){
      vars=city
    } else {
      vars=region
    }
    return(vars)
  }
  )
  
  
  output$variables = renderUI({
    selectInput('variables2', paste('Divisions (per',tolower(input$typeofdivision),')'), outVar())
  })
  
  
  outVardata <- reactive({
    if(input$typeofdivisiondata=='City'){
      varsdata=city
    } else {
      varsdata=region
    }
    return(varsdata)
  }
  )
  
  
  output$variablesdata = renderUI({
    selectInput('variables3', paste('Divisions (per', tolower(input$typeofdivisiondata),')'),outVardata())
  })
  
  
  plot1 <- eventReactive(input$updateplots, {
    if(input$typeofdivision=='City' & input$plotbanners=='All' & input$variables2=='All'){
      data %>% group_by(Nature.of.product)
    } else if(input$typeofdivision=='City' & input$plotbanners=='All' & input$variables2!='All'){
      data %>% filter(City==input$variables2) %>% group_by(Nature.of.product)
    } else if(input$typeofdivision=='City' & input$plotbanners!='All' & input$variables2!='All'){
      data %>% filter(City==input$variables2) %>% filter(Banner==input$plotbanners) %>% group_by(Nature.of.product)
    } else if(input$typeofdivision=='City' & input$plotbanners!='All' & input$variables2=='All'){
      data %>% filter(Banner==input$plotbanners) %>% group_by(Nature.of.product)
    } else if(input$typeofdivision=='Region' & input$plotbanners=='All' & input$variables2=='All'){
      data %>% group_by(Nature.of.product)
    } else if(input$typeofdivision=='Region' & input$plotbanners=='All' & input$variables2!='All'){
      data %>% filter(Name.of.region==input$variables2) %>% group_by(Nature.of.product)
    } else if(input$typeofdivision=='Region' & input$plotbanners!='All' & input$variables2!='All'){
      data %>% filter(Name.of.region==input$variables2) %>% filter(Banner==input$plotbanners) %>% group_by(Nature.of.product)
    } else if(input$typeofdivision=='Region' & input$plotbanners!='All' & input$variables2=='All'){
      data %>% filter(Banner==input$plotbanners) %>% group_by(Nature.of.product)
    }
  })
  
  
  plot2 <- eventReactive(input$updateplots, {
    if(input$typeofdivision=='City' & input$plotbanners=='All' & input$variables2=='All'){
      data %>% group_by(Nature.of.product)
    } else if(input$typeofdivision=='City' & input$plotbanners=='All' & input$variables2!='All'){
      data %>% filter(City==input$variables2) %>% group_by(Nature.of.product)
    } else if(input$typeofdivision=='City' & input$plotbanners!='All' & input$variables2!='All'){
      data %>% filter(City==input$variables2) %>% filter(Banner==input$plotbanners) %>% group_by(Nature.of.product)
    } else if(input$typeofdivision=='City' & input$plotbanners!='All' & input$variables2=='All'){
      data %>% filter(Banner==input$plotbanners) %>% group_by(Nature.of.product)
    } else if(input$typeofdivision=='Region' & input$plotbanners=='All' & input$variables2=='All'){
      data %>% group_by(Nature.of.product)
    } else if(input$typeofdivision=='Region' & input$plotbanners=='All' & input$variables2!='All'){
      data %>% filter(Name.of.region==input$variables2) %>% group_by(Nature.of.product)
    } else if(input$typeofdivision=='Region' & input$plotbanners!='All' & input$variables2!='All'){
      data %>% filter(Name.of.region==input$variables2) %>% filter(Banner==input$plotbanners) %>% group_by(Nature.of.product)
    } else if(input$typeofdivision=='Region' & input$plotbanners!='All' & input$variables2=='All'){
      data %>% filter(Banner==input$plotbanners) %>% group_by(Nature.of.product)
    }
  })
  
  output$plot1 <- renderPlot({
    g <- ggplot(plot1(), aes(x = Nature.of.product, y = Qty.of.9L.cases.sold ,fill = Description)) + xlab("Category") + ylab("9 liter equivalent cases sold") + ggtitle("Cases Sold (Mosaiq Inc. vs. Category) ")
    g <- g + geom_bar(stat = "identity",position='stack') +  theme_gdocs() + scale_fill_gdocs(name = 'Products') + theme(plot.title = element_text(hjust = 0.5))
    g
  })
  
  output$plot2 <- renderPlot({
    g <- ggplot(plot2(), aes(x = Nature.of.product, y = Amount/1000000 ,fill = Description)) + xlab("Category") + ylab("Sales in millions ($CAD)") + ggtitle("Sales (Mosaiq Inc. vs. Category)")
    g <- g + geom_bar(stat = "identity",position='stack') +  theme_gdocs() + scale_fill_gdocs(name = 'Products') + theme(plot.title = element_text(hjust = 0.5))
    g
  })    
  
  output$selected_text1 <- renderText({
    paste("Here is an overview of Mosaiq Inc. products for the selected banner(s) ", 
          if(input$typeofdivision=='City' & input$variables2!='All'){
            paste('and the city of',input$variables2)
          } else if (input$typeofdivision=='Region' & input$variables2!='All'){
            paste('and the region of',input$variables2)
          } else if (input$variables2=='All'){
            cat('')
          }, 
          ",")
  })
  
  #Define data based on selections
  datatextparam <- reactive({
    if(input$typeofdivision=='City' & input$plotbanners=='All' & input$variables2=='All'){
      dftext = data 
    } else if(input$typeofdivision=='City' & input$plotbanners=='All' & input$variables2!='All'){
      dftext = data %>% filter(City==input$variables2) 
    } else if(input$typeofdivision=='City' & input$plotbanners!='All' & input$variables2!='All'){
      dftext = data %>% filter(City==input$variables2) %>% filter(Banner==input$plotbanners)
    } else if(input$typeofdivision=='City' & input$plotbanners!='All' & input$variables2=='All'){
      dftext = data %>% filter(Banner==input$plotbanners)
    } else if(input$typeofdivision=='Region' & input$plotbanners=='All' & input$variables2=='All'){
      dftext = data 
    } else if(input$typeofdivision=='Region' & input$plotbanners=='All' & input$variables2!='All'){
      dftext = data %>% filter(Name.of.region==input$variables2)
    } else if(input$typeofdivision=='Region' & input$plotbanners!='All' & input$variables2!='All'){
      dftext = data %>% filter(Name.of.region==input$variables2) %>% filter(Banner==input$plotbanners)
    } else if(input$typeofdivision=='Region' & input$plotbanners!='All' & input$variables2=='All'){
      dftext = data %>% filter(Banner==input$plotbanners) 
    }
    
    return(dftext)
  }) 
  
  
  output$selected_text2 <- renderText({
    paste("     - Chemineaud Fine Brandy represents",
          round(100*
                  (datatextparam() %>% filter(Description=='Chemineaud') %>% 
                     summarise(nbcaseschemineaud=sum(Qty.of.9L.cases.sold)))/
                  (datatextparam() %>% filter(Nature.of.product=='Brandy') %>% summarise(nbcasesmarket=sum(Qty.of.9L.cases.sold))),2), 
          "% of the market for brandy in terms of 9L cases sold and",
          round(100*
                  (datatextparam() %>% filter(Description=='Chemineaud') %>% 
                     summarise(totalsaleschemineaud=sum(Amount)))/
                  (datatextparam() %>% filter(Nature.of.product=='Brandy') %>% summarise(totalsalesmarket=sum(Amount))),2), 
          "% in terms of total sales.")
  })
  
  output$selected_text3 <- renderText({
    paste("     - St-Leger represents",
          round(100*
                  (datatextparam() %>% filter(Description=='St-Leger') %>% 
                     summarise(nbcasesstleger=sum(Qty.of.9L.cases.sold)))/
                  (datatextparam() %>% filter(Nature.of.product=='Scotch') %>% summarise(nbcasesmarket=sum(Qty.of.9L.cases.sold))),2), 
          "% of the market for scotch in terms of 9L cases sold and",
          round(100*
                  (datatextparam() %>% filter(Description=='St-Leger') %>% 
                     summarise(totalsalesstleger=sum(Amount)))/
                  (datatextparam() %>% filter(Nature.of.product=='Scotch') %>% summarise(totalsalesmarket=sum(Amount))),2), 
          "% in terms of total sales.")
  })
  
  output$selected_text4 <- renderText({
    paste("     - Carolans represents",
          round(100*
                  (datatextparam() %>% filter(Description=='Carolans') %>% 
                     summarise(nbcasescarolans=sum(Qty.of.9L.cases.sold)))/
                  (datatextparam() %>% filter(Nature.of.product=='Irish cream liqueur') %>% summarise(nbcasesmarket=sum(Qty.of.9L.cases.sold))),2), 
          "% of the market for Irish cream liqueur in terms of 9L cases sold and",
          round(100*
                  (datatextparam() %>% filter(Description=='Carolans') %>% 
                     summarise(totalsalescarolans=sum(Amount)))/
                  (datatextparam() %>% filter(Nature.of.product=='Irish cream liqueur') %>% summarise(totalsalesmarket=sum(Amount))),2), 
          "% in terms of total sales.")
  })
  
  output$selected_text5 <- renderText({
    paste("     - Nicolas Feuillatte represents",
          round(100*
                  (datatextparam() %>% filter(Description=='Nicolas Feuillatte') %>% 
                     summarise(nbcasesnicolasfeuillatte=sum(Qty.of.9L.cases.sold)))/
                  (datatextparam() %>% filter(Nature.of.product=='Champagne') %>% summarise(nbcasesmarket=sum(Qty.of.9L.cases.sold))),2), 
          "% of the market for champagne in terms of 9L cases sold and",
          round(100*
                  (datatextparam() %>% filter(Description=='Nicolas Feuillatte') %>% 
                     summarise(totalsalesnicolasfeuillatte=sum(Amount)))/
                  (datatextparam() %>% filter(Nature.of.product=='Champagne') %>% summarise(totalsalesmarket=sum(Amount))),2), 
          "% in terms of total sales.")
  })  
  
  
  
  # Filter data based on selections
  output$dTable <- DT::renderDataTable(DT::datatable({
    data1 = select(data,-new_col) 
    data1$Qty.of.9L.cases.sold=format(round(data1$Qty.of.9L.cases.sold,2), nsmall=2)
    if (input$typeofdivisiondata=='City' & input$variables3!= "All") {
      data1 <- data1[data1$City == input$variables3,]
    }
    if (input$typeofdivisiondata=='Region' & input$variables3!= "All") {
      data1 <- data1[data1$Name.of.region == input$variables3,]
    }   
    if (input$tablebanners != "All") {
      data1 <- data1[data1$Banner == input$tablebanners,]
    }
    if (input$tablecategory != "All") {
      data1 <- data1[data1$Nature.of.product == input$tablecategory,]
    }
    if (input$tableproduct != "All") {
      data1 <- data1[data1$Description == input$tableproduct,]
    }
    data1
  }))
  
  
  
}