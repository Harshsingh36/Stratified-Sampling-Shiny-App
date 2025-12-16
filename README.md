# Stratified Sampling – Estimation of Population Mean (R Shiny)

  Description
This R Shiny application demonstrates estimation of population mean using
Stratified Sampling under:

- Proportional Allocation  
- Neyman Allocation  
- Optimised Allocation (Cost & Time based)

The application determines the required sample size considering:
- Number of strata
- Sampling bias (allowable error)
- Cost and time of survey in each stratum

  Inputs
- Number of Strata: 3  
- Z-value (95% Confidence Level): 1.96  
- Allowable Error (Sampling Bias): 2  

  Output
- Sample allocation table for each stratum
- Experimental design plot comparing allocation methods

  How to Run
```r
library(shiny)
runApp("app.R")
