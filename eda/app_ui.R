library(shiny)
library(tidyverse)
library(plotly)
library(lintr)
library(styler)
library(RColorBrewer)
library(shinythemes)
# read in the data set 

insurance_data <- read.csv("./data/insurance_no_coverage.csv")
mde_data <- read.csv("./data/youths_with_at_least_one_mde.csv")
no_treatment_data <- read.csv("./data/no_treatment.csv")
substance_use_data <- read.csv("./data/substance_use_disorders.csv")
### patient data
patient_data <- read.csv("./data/patient_char_survey_2015.csv")

insurance_data <- rename(insurance_data, rank_no_coverage = Rank,
                         percent_no_coverage = Percentage,
                         number_no_coverage = Number)
mde_data <- rename(mde_data, rank_mde = Rank,
                   percent_mde = Percentage,
                   number_mde = Number)
no_treatment_data <- rename(no_treatment_data, rank_no_treatment = Rank,
                            percent_no_treatment = Percentage,
                            number_no_treatment = Number)
substance_use_data <- rename(substance_use_data,
                             rank_substance_use = Rank,
                             percent_substance_use = Percentage,
                             number_substance_use = Number)

### join data
state_data <- insurance_data %>%
  full_join(mde_data, "State") %>%
  full_join(no_treatment_data, "State") %>%
  full_join(substance_use_data, "State")


### filter patient data
child_patient_female_data <- patient_data %>% 
  group_by(Age.Group, Sex, Serious.Mental.Illness) %>%
  filter(Age.Group == "CHILD") %>%
  filter(Serious.Mental.Illness == "YES") %>% 
  filter(Sex == "FEMALE") %>% 
  summarise(Serious.Mental.Illness) %>% 
  count(Serious.Mental.Illness)

child_patient_male_data <- patient_data %>% 
  group_by(Age.Group, Sex, Serious.Mental.Illness) %>%
  filter(Age.Group == "CHILD") %>%
  filter(Serious.Mental.Illness == "YES") %>% 
  filter(Sex == "MALE") %>% 
  summarise(Serious.Mental.Illness) %>% 
  count(Serious.Mental.Illness)

child_patient_data <- rbind(child_patient_female_data, child_patient_male_data) %>% 
  mutate(proportion = n/35865)

# Define Widgets (shiny widget library here)

# Define structure of tabs (aka pages) -- must make 2 tabs

page_one <- tabPanel(
  "Page 1",             #title of the page, what will appear as the tab name
  sidebarLayout(             
    sidebarPanel(
      p("Select your viewing options!"),
      selectInput("Sex",
                  label = h3("Sex"),
                  choices = child_patient_data$Sex,
                  selected = "Male"
      ),
      selectInput("color_id",
                  label = h3("Color"),
                  choices = brewer.pal(8, "Set2")
      )
      # left side of the page 
      # insert widgets or text here -- their variable name(s), NOT the raw code
    ),           
    mainPanel(
      plotlyOutput(outputId = "child_patient_data"),# typically where you place your plots + texts
      # insert chart and/or text here -- the variable name NOT the code
    )
  )
)

page_two <- tabPanel(
  "Page 2",
  sidebarLayout(
    sidebarPanel(
      p("Select your viewing options!"),
      selectInput("State",
                  label = h3("State"),
                  choices = state_data$State,
                  selected = "Washington"
      ),
      selectInput("color_id2",
                  label = h3("Color"),
                  choices = brewer.pal(8, "Set2")
      )
    ),
    mainPanel(
      plotlyOutput(outputId = "state_data")
    )
  )
)



# Define the UI and what pages/tabs go into it
ui <- fluidPage(theme = shinytheme("cerulean"),
  h3("INFO 478 Final Deliverable: Mental Health In Children"),
  h3("Created by Chloe Lee, Angela Pak, Trevor Leung, Daniel Miau"),
  navbarPage(
    inverse = TRUE,
    "Title",
    page_one,
    page_two
  #insert other pages here
  )
)