cd "/Users/fukui/Dropbox (Personal)/Trilemma/Trilemma_Replication/Empirics"
global fig_folder "./Figures"
global fig_slide_folder "./Figures"
global fig_slide_folder "./Figures"
global fig_table_folder "./Tables"
set scheme s2color, permanently
**********************************
*********************************
* Figure for exchange rate
*********************************
*********************************
use ./WorkingData/Cleaned/Dataset_regresson.dta,clear
do ./Stata_Code/subfile/sub_sample_selection.do
keep if RGDP_WB !=.
gen float_USD = 1 if peg_USD == 0 
collapse (sum) peg_USD float_USD , by(countryname)

local NN = floor(_N/3)

capture file close latexout
file open latexout using "${fig_table_folder}/Table_1.txt", write replace
* Loop over all observations
quietly {
    forvalues i = 1/`NN' {
        local v1 = countryname[`i']
        local v2 = peg_USD[`i']
        local v3 = float_USD[`i']

        local v4 = countryname[`i' + `NN']
        local v5 = peg_USD[`i' + `NN']
        local v6 = float_USD[`i' + `NN']


        local v7 = countryname[`i' + 2*`NN']
        local v8 = peg_USD[`i' + 2*`NN']
        local v9 = float_USD[`i' + 2*`NN']


        * Write to LaTeX table
        file write latexout "`v1' & `v2' & `v3' && `v4' & `v5' & `v6'  && `v7' & `v8' & `v9' \\" _n
    }
}

file write latexout "\hline" _n
file close latexout