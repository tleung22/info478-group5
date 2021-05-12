library(tidyr)
library(dplyr)
library(ggplot2)
library(MASS)

# State Data
### read in data
insurance_data <- read.csv("./data/insurance_no_coverage.csv")
mde_data <- read.csv("./data/youths_with_at_least_one_mde.csv")
no_treatment_data <- read.csv("./data/no_treatment.csv")
substance_use_data <- read.csv("./data/substance_use_disorders.csv")
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

child_patient_data <- rbind(child_patient_female_data, child_patient_male_data)


### male vs female distribution
male_vs_female_count <- ggplot(child_patient_data) +
  geom_col(mapping = aes(x = Sex, y = n, fill = Sex)) +
  labs(title = "Comparison of Male Mental Illness Patients to Female Patients
       under 17 years old in 2015",
       x = "Sex",
       y = "Number of Mental Illness Patients"
  )

### relationship graph

substance_use_ranking <- state_data %>% 
  arrange(state_data, percent_substance_use) %>% 
  top_n(10, percent_substance_use)
  
  
substance_use_ranking_chart<- ggplot(substance_use_ranking) +
  geom_col(mapping = aes(x = State, y = percent_substance_use)) +
  labs(title = "Top 10 States with Highest Percentage of Substance Use for
       Mental Illnesses in 2021",
       x = "State",
       y = "Percentage of Youths Who Use Substances") +
  scale_x_discrete(guide = guide_axis(n.dodge = 2))

### graphic

### distribution of variables graphic

sd(state_data$percent_mde) # 1.512508

mde_distribution <- boxplot(state_data$percent_mde,
        main = "Percent of Youths with > 1 MDE",
        xlab = "Percent of Youths",
        horizontal = TRUE)



### relationship graphic

#### Number no treatment vs Number no coverage
coverage_vs_treatment <- ggplot(state_data) +
  geom_point(mapping = aes(x = number_no_coverage, y = number_no_treatment)) +
  labs(title = "No Coverage vs No Treatment",
       x = "Number of Youths without Coverage",
       y = "Number of Youths Who Receive No Treatment") +
  xlim(0, 130000) + 
  ylim(0, 300000)
coverage_treatment_corr <- cor(state_data$number_no_coverage, state_data$number_no_treatment) # 0.9989021
## As the number of youths increases in states, the total number of youths
## who do not receive treatment also increases.





library(tidyr)
library(dplyr)
library(ggplot2)

# State Data
### read in data
insurance_data <- read.csv("./data/insurance_no_coverage.csv")
mde_data <- read.csv("./data/youths_with_at_least_one_mde.csv")
no_treatment_data <- read.csv("./data/no_treatment.csv")
substance_use_data <- read.csv("./data/substance_use_disorders.csv")
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

child_patient_data <- rbind(child_patient_female_data, child_patient_male_data)


### male vs female distribution
male_vs_female_count <- ggplot(child_patient_data) +
  geom_col(mapping = aes(x = Sex, y = n, fill = Sex)) +
  labs(title = "Comparison of Male Mental Illness Patients to Female Patients
       under 17 years old in 2015",
       x = "Sex",
       y = "Number of Mental Illness Patients"
  )

### relationship graph

substance_use_ranking <- state_data %>% 
  arrange(state_data, percent_substance_use) %>% 
  top_n(10, percent_substance_use)


substance_use_ranking_chart<- ggplot(substance_use_ranking) +
  geom_col(mapping = aes(x = State, y = percent_substance_use)) +
  labs(title = "Top 10 States with Highest Percentage of Substance Use for
       Mental Illnesses in 2021",
       x = "State",
       y = "Percentage of Youths Who Use Substances") +
  scale_x_discrete(guide = guide_axis(n.dodge = 2))

### graphic
#### Number no treatment vs Number no coverage
coverage_vs_treatment <- ggplot(state_data) +
  geom_point(mapping = aes(x = number_no_coverage, y = number_no_treatment)) +
  labs(title = "No Coverage vs No Treatment",
       x = "Number of Youths without Coverage",
       y = "Number of Youths Who Receive No Treatment") +
  xlim(0, 130000) + 
  ylim(0, 300000)
coverage_treatment_corr <- cor(state_data$number_no_coverage, state_data$number_no_treatment) # 0.9989021
## As the number of youths increases in states, the total number of youths
## who do not receive treatment also increases.


