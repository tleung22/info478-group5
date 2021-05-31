# load your libraries
# read in the data set 

# Define Widgets (shiny widget library here)

# Define structure of tabs (aka pages) -- must make 2 tabs
page_one <- tabPanel(
  "Page 1",             #title of the page, what will appear as the tab name
  sidebarLayout(             
    sidebarPanel( 
      # left side of the page 
      # insert widgets or text here -- their variable name(s), NOT the raw code
    ),           
    mainPanel(                # typically where you place your plots + texts
      # insert chart and/or text here -- the variable name NOT the code
    )))


# Define the UI and what pages/tabs go into it
ui <- navbarPage(
  "Title",
  page_one
  #insert other pages here
  