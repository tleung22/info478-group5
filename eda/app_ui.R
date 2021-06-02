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

coverage_input <- radioButtons(inputId = "trendline_choice",
                               label = "Trendline",
                               choices = list("With Trendline" = "Y",
                                              "Without Trendline" = "N"))

state_input <- checkboxGroupInput("State",
                                  label = h3("State"),
                                  choices = substance_use_ranking$State,
                                  selected = "Washington")
# Define Widgets (shiny widget library here)

#drop down menu   


# Define structure of tabs (aka pages) -- must make 2 tabs
intro_panel <- tabPanel( 
  title = "Introduction",
  titlePanel("INFO 478 Final Deliverable: Mental Health In Children"),
  h4("Created by Chloe Lee, Angela Pak, Trevor Leung, Daniel Miau"),
  
  # Introduction of our app 
  p(
    "The purpose of our research project is to conceptualize a digital resource for helping 
    teenagers struggling with mental health problems and concerns navigate through the confusing 
    mental health care system to find help that is most suited to their needs. To supply this resource, 
    we are investigating the problem areas associated with this topic by finding correlations between 
    youth mental health and other factors such as school and social demographics. We plan to highlight 
    problem areas through visualizations that reveal patterns and assist in gaining knowledge of how to 
    properly address mental health problems in youth."
  ), 
  
  # hyperlink for research 
    p(
      "Our research background was found on ", 
      a(
        href = "https://journals.sagepub.com/doi/pdf/10.1177/2158244015581019", "SAGE,"
      ), 
      a(
        href = "https://www.frontiersin.org/articles/10.3389/fpsyt.2019.00595/full", "Frontiers in Psychiatry,"),
        "and,",
      a(
        href = "https://www.statnews.com/2020/06/17/cliff-teens-mental-health-transition-adulthood/", "STAT"
      )
  ),
  
  
  p(
    "After reviewing these three articles about the mental health situation in youth, the articles
    described many of the same concerns for the worsening mental health for youth in the U.S. 
    Although the U.S mental health system for youth has been transitioning to more early intervention
    programs and accessible technology resources, the system does not prepare teenagers and young adults 
    for navigating mental health care in the future. In response, the articles explore suggested solutions 
    by teenagers and young adults. Many of the responders emphasized that they would like digital tools for
    mental health that are personalized for their needs and not necessarily in a one-size-fits-all format. 
    Also, in the SAGE research article, teenage participants preferred mental health solutions that can be 
    done on their phone and do not involve any social media relationship between themselves and their mental 
    health clinician."
  ), 
  

  p(
    "In the Frontiers article, a digital mental health platform that was described is the Innowell Platform. 
    The Platform assists with the assessment, feedback, management, and monitoring of their mental ill health 
    and maintenance of well-being by collecting personal and health information from a young person, their clinician(s), 
    and supportive others. This information is stored, scored, and reported back to the young person, their clinicians, 
    and the service provider to promote genuine collaborative care. The clinical content is determined by the health service 
    who invites the young person to use the Platform. The Innowell Platform does not provide stand-alone medical or health advice,
    risk assessment, clinical diagnosis, or treatment. Instead, it guides and supports (but does not direct) young people and their
    clinicians to decide what may be suitable care options. Importantly, all care aligns with the existing clinical governance 
    (e.g., policies and procedures) of the service provider."
  ),
  
  p("The Platform facilitates personalized and measurement-based care within a mental health service by enhancing key processes, 
    which themselves may not be new, but their combined use and integration with face-to-face services is."),
    
    # hyperlink for dataset 
    p(
      "Our Patient Characteristics Survey dataset was found on ", 
      a(
        href = "https://catalog.data.gov/dataset/patient-characteristics-survey-pcs-2015", "Data.gov."),
      
    p(
      "Our Youth Data 2021 dataset was found on",
      a(
        href = "https://mhanational.org/issues/2021/mental-health-america-youth-data#eight", "MHA",
      ))))

page_one <- tabPanel(
  "Page 1",             #title of the page, what will appear as the tab name
  sidebarLayout(             
    sidebarPanel(
      p("Select your viewing options!"),
      coverage_input
      ),
    mainPanel(
      plotlyOutput(outputId = "coverage_data"),# typically where you place your plots + texts
      # insert chart and/or text here -- the variable name NOT the code
      br(),
      br(),
      p("The number of male mental illness patients under 17 is higher than 
        females by a significant amount. This can lead to a further discussion 
        of factors leading to higher mental health illness patients in males.")
    )
  )
)


page_two <- tabPanel(
  "Page 2",
  sidebarLayout(
    sidebarPanel(
      p("Top 10 States"),
      state_input
      ),
    mainPanel(
      plotlyOutput(outputId = "state_data"),
      p("In this graph, we compared the percentage of substance use in the top 10
      states with the highest percentage of substance use in youths 
      (under age 17). The highest percentage of substance use is from Vermont, 
      while the lowest of the top 10 states is Wyoming.")
    )
  )
)

# Define the UI and what pages/tabs go into it
ui <- fluidPage(theme = shinytheme("cerulean"),
  h3("INFO 478 Final Deliverable: Mental Health In Children"),
  h3("Created by Chloe Lee, Angela Pak, Trevor Leung, Daniel Miau"),
  navbarPage(
    inverse = TRUE,
    "",
    intro_panel, 
    page_one,
    page_two
  #insert other pages here
  )
)

