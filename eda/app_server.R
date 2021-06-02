library(tidyr)
library(dplyr)
library(ggplot2)
library(MASS)

# read in data
### state data
insurance_data <- read.csv("./data/insurance_no_coverage.csv")
mde_data <- read.csv("./data/youths_with_at_least_one_mde.csv")
no_treatment_data <- read.csv("./data/no_treatment.csv")
substance_use_data <- read.csv("./data/substance_use_disorders.csv")
### patient data
patient_data <- read.csv("./data/patient_char_survey_2015.csv")

### change column names
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

proportion_data <- patient_data %>% 
  filter(Age.Group == "CHILD") %>% 
  nrow()
#35865 

### Chart 1: male vs female distribution
male_vs_female_proportion <- ggplot(child_patient_data) +
  geom_col(mapping = aes(x = Sex, y = proportion, fill = Sex)) +
  labs(title = "Comparison of Male Mental Illness Patients to Female Patients
       under 17 years old in 2015",
       x = "Sex",
       y = "Proportion of Mental Illness Patients")


### Chart 2: relationship graph substance use
substance_use_ranking <- state_data %>% 
  arrange(state_data, percent_substance_use) %>% 
  top_n(10, percent_substance_use)

substance_use_ranking_chart<- ggplot(substance_use_ranking) +
  geom_col(mapping = aes(x = reorder(State, -percent_substance_use), y = percent_substance_use)) +
  labs(title = "Top 10 States with Highest Percentage of Substance Use in Youths for
       Mental Illnesses in 2021",
       x = "State",
       y = "Percentage of Substance Use") +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1, size = 7)) 

### Chart 3: relationship graph coverage vs treatment
coverage_vs_treatment <- ggplot(state_data) +
  geom_point(mapping = aes(x = number_no_coverage, y = number_no_treatment)) +
  geom_smooth(aes(x =number_no_coverage, y = number_no_treatment),method='lm') +
  labs(title = "No Coverage vs No Treatment",
       x = "Number of Youths without Coverage",
       y = "Number of Youths Who Receive No Treatment") +
  xlim(0, 130000) + 
  ylim(0, 300000) 


coverage_treatment_corr <- cor(state_data$number_no_coverage, state_data$number_no_treatment) # 0.9989021
## As the number of youths increases in states, the total number of youths
## who do not receive treatment also increases.

# Define the server
server <- function(input, output) {
  output$coverage_data <- renderPlotly({
    with_trendline <- input$trendline_choice
    
    if (with_trendline == "N") {
      chart1 <- ggplot(state_data) +
        geom_point(mapping = aes(x = number_no_coverage, y = number_no_treatment)) +
        labs(title = "No Coverage vs No Treatment",
             x = "Number of Youths without Coverage",
             y = "Number of Youths Who Receive No Treatment") +
        xlim(0, 130000) + 
        ylim(0, 300000)
    }

    else {
      chart1_with_tl <- ggplot(state_data) +
        geom_point(mapping = aes(x = number_no_coverage, y = number_no_treatment)) +
        geom_smooth(mapping = aes(x =number_no_coverage, y = number_no_treatment), method='lm') +
        labs(title = "No Coverage vs No Treatment",
             x = "Number of Youths without Coverage",
             y = "Number of Youths Who Receive No Treatment") +
        xlim(0, 130000) + 
        ylim(0, 300000)
    }
  })
  
  output$state_data <- renderPlotly({
    state_data_updated <- substance_use_ranking %>%
      filter(is.element(substance_use_ranking$State, input$State))
    
    chart2 <- ggplot(state_data_updated) +
      geom_col(mapping = aes(x = reorder(State, -percent_substance_use),
                             y = percent_substance_use, fill = State)) +
      scale_color_brewer(palette = "Set3") +
      scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
      labs(title = " Highest Percentage of Substance Use in Youths for Mental 
           Illnesses in 2021",
           x = "State",
           y = "Percentage of Substance Use",
           color = "State") +
      theme(axis.text.x = element_text(angle = 45, vjust = 0.5,
                                       hjust=1, size = 7))
  })
  
  
  
  # further clean and/or manipulate the data based on the input from the widgets
  # any code that has input$ or output$ (ex. Your chart or a dataframe that will updated based on user input 
  # insert code for chart here        
  
}
