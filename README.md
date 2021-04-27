# INFO 478 - Group 5 Project Proposal

## Project Description  
### Purpose:  
The purpose of our research project is to conceptualize a digital resource for helping teenagers struggling with mental health problems and concerns navigate through the confusing mental health care system to find help that is most suited to their needs. To supply this resource, we are investigating the problem areas associated with this topic by finding correlations between youth mental health and other factors such as school and social demographics. We plan to highlight problem areas through visualizations that reveal patterns and assist in gaining knowledge of how to properly address mental health problems in youth.  

### Research Area:  
- [SAGE: Putting Technology Into Youth Mental Health Practice: Young People's Perspectives](https://journals.sagepub.com/doi/pdf/10.1177/2158244015581019)  
- [Frontiers in Psychiatry: A Digital Platform Designed for Youth Mental Health Services to Deliver Personalized and Measurement-Based Care](https://www.frontiersin.org/articles/10.3389/fpsyt.2019.00595/full)  
- [STAT: Facing a broken mental health system, many U.S. teens fall off a dangerous 'cliff' in their care](https://www.statnews.com/2020/06/17/cliff-teens-mental-health-transition-adulthood/)  

After reviewing these three articles about the mental health situation in youth, the articles described many of the same concerns for the worsening mental health for youth in the U.S. Although the U.S mental health system for youth has been transitioning to more early intervention programs and accessible technology resources, the system does not prepare teenagers and young adults for navigating mental health care in the future. In response, the articles explore suggested solutions by teenagers and young adults. Many of the responders emphasized that they would like digital tools for mental health that are personalized for their needs and not necessarily in a one-size-fits-all format. Also, in the SAGE research article, teenage participants preferred mental health solutions that can be done on their phone and do not involve any social media relationship between themselves and their mental health clinician. 
  
In the Frontiers article, a digital mental health platform that was described is the Innowell Platform. The Platform assists with the assessment, feedback, management, and monitoring of their mental ill health and maintenance of well-being by collecting personal and health information from a young person, their clinician(s), and supportive others. This information is stored, scored, and reported back to the young person, their clinicians, and the service provider to promote genuine collaborative care. The clinical content is determined by the health service who invites the young person to use the Platform. The Innowell Platform does not provide stand-alone medical or health advice, risk assessment, clinical diagnosis, or treatment. Instead, it guides and supports (but does not direct) young people and their clinicians to decide what may be suitable care options. Importantly, all care aligns with the existing clinical governance (e.g., policies and procedures) of the service provider. 
  
The Platform facilitates personalized and measurement-based care within a mental health service by enhancing key processes, which themselves may not be new, but their combined use and integration with face-to-face services is.

### Datasets:  

- [Patient Characteristics Survey](https://catalog.data.gov/dataset/patient-characteristics-survey-pcs-2015)  
This dataset from Data.gov is collected by the New York State, and shows demographics and other medical conditions in relation to mental illness diagnoses of children (under 17) and adults (over 17).
- [MHA: Youth Data 2021](https://mhanational.org/issues/2021/mental-health-america-youth-data#eight)  
This site contains multiple datasets related to youth mental health by state such as the percentage of youth with at least one major depressive episode and youth who did not receive mental health treatment.

### Target Audience:  
High school students (ages 14-18) would be the main audience since we are providing a database of mental health related topics for people around their age. Parents could also be an audience since students would need a parent/guardian for health related things.

### Specific Questions:  
- How can we create safe, user-friendly, and rehabilitative spaces for youth struggling with mental health? How can we make our resources accessible for all youth, taking into consideration the limitations of under-age individuals?  
- What are the most prevalent mental health disorders that our youth face today? What are the main causes and factors leading up to these disorders?
- What are the main barriers and obstacles that keep the youth from seeking out help?  
- From our datasets, what can we observe about the frequency of youth utilizing mental health services? How effective are the treatments being distributed? And how can we increase the retention and consistency of these services being used?  

## Technical Description  
The format of our final product will be a compiled .Rmd file that will be outputted as an HTML page. To build this, we will need technical skills in R and R Markdown such as knowledge of ggplot for creating visualizations and dplyr for data wrangling. One potential specific data collection challenge includes finding datasets that can be joined or merged together. Since our project addresses youth mental health, we may not find one exact dataset that covers all the data we want to analyze, so we will probably need to find multiple datasets that can be joined together. Other potential major challenges include making complex visualizations about our datasets, finding patterns across different datasets, and adding interactivity to our visualizations that help improve understanding of the patterns we are trying to convey.
