# Replication Files for "The Macroeconomic Consequences of Exchange Rate Depreciations"

This replication package is divided into two parts:
* Empirics: Replication files for all the empirical analysis
* Theory: Replication files for the theoretical analysis in the main text

## Empircis
### Data
Data is too large to be stored on GitHub. The data can be downloaded from [here](https://www.dropbox.com/scl/fi/k8487v6oaaeurqtnj24om/Trilemma_Replication_Data_Files.zip?rlkey=mssvlv7xu2zph92mvb9htes7f&dl=1). Place both "Original_Data" and "Working_Data" folders under "Empirics". 
### Codes 
The code should be run in the following orders:
 * [./Empirics/R_Code/0_Clearning_R.R](./Empirics/R_Code/0_Cleaning_R.R)
   This is the first half of the data cleaning procedure.
 * [./Empirics/Stata_Code/1_Ceaning_Stata.do](./Empirics/Stata_Code/1_Ceaning_Stata.do)
   This is the second half of the data cleaning procedure.
 * [./Empirics/Stata_Code/2_List_of_countries.do](./Empirics/Stata_Code/2_List_of_countries.do)
   This will produce Table 1 in the paper.
 * [./Empirics/Stata_Code/3_Variable_description.do](./Empirics/Stata_Code/3_Variable_description.do)
   This will produce Table A3 in the paper.
 * [./Empirics/Stata_Code/4_Descriptive_Figure.do](./Empirics/Stata_Code/4_Descriptive_Figure.do)
   This will produce Figure 1, A25, A3, A4, and Table 2 and A1 in the paper.
 * [./Empirics/Stata_Code/5_Sensitivity_Regressions.do](./Empirics/Stata_Code/5_Sensitivity_Regressions.do)
   This will produce Figure 1, A25, A3, A4, and Table 2 and A1 in the paper.
 * [./Empirics/Stata_Code/6_Main_Regressions.do](./Empirics/Stata_Code/6_Main_Regressions.do)
   This will produce Figure 3-8, A5-A22, and A23-A24, and Table A4 in the paper.
 * [./Empirics/Stata_Code/7_Plaza_accord.do](./Empirics/Stata_Code/7_Plaza_accord.do)
   This will produce Figure 9 in the paper.
 * [./Empirics/Stata_Code/8_Business_cycle_moment.do](./Empirics/Stata_Code/8_Business_cycle_moment.do)
   This will produce Table 4 in the paper. 
### Required packages
* For Stata, it requires "reghdfe", "texsave", "ivreghdfe".
* For R, it requires "foreign", "sandwich","ggplot2", "boot", "zoo", 
                     "quantreg", "dummies", "stargazer", "lmtest", "expm","coefplot",
                     "OpenMx","Matrix","foreign","MASS","reshape2","AER",
                     "plyr","systemfit","ivpack","quantmod","xtable","boot","mFilter",
                     "dynlm","vars","nleqslv","vars","dplyr","forecast","fUnitRoots","tidyr","plm",
                     "WDI","conflicted","data.table","readxl","stringr","countrycode","modeest"
### Computation Time
Computation time is approximately 1-2 hours using a MacBook Pro 2021 with an Apple M1 Max chip and 64GB of memory. 


## Theory

### Codes
* [./Theory/Julia/Toplevel.jl](./Theory/Julia/Toplevel.jl)
  This will produce Figure 11 and 12 in the paper.
### Required packages
  "Debugger", "SparseArrays", "Plots", "DelimitedFiles", "DataFrames", "LinearAlgebra", "JLD2", "Optim", "NLsolve", "Statistics", "Printf", "LaTeXStrings", "Plots.PlotMeasures", "ForwardDiff", "CSV", "StatFiles", "Query",   "DataFramesMeta", "Parameters", "NLsolve", "DiscreteMarkovChains", "Infiltrator", "BenchmarkTools", "Polynomials", "NaNStatistics", "Latexify"
### Computation Time
 This should run within a few seconds.

