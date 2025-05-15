cd "/Users/fukui/Dropbox (Personal)/Trilemma/Trilemma_Replication/Empirics"
global fig_table_folder "./Tables"
capture file close fh 

local std_lnominal "std($\Delta  NER$)"
local std_lreal "std($\Delta  RER$)"
local std_lRGDP_WB "std($\Delta  GDP$)"
local std_lconsumption_WB "std($\Delta  C$)"
local std_nx_gdp "std($\Delta NX$)"
local std_bloomberg_rate_all "std($\Delta (1+i)$)"
local std_linvestment_WB "std($\Delta I$)"

local autocorr_lreal "$\rho$($\Delta RER$)"
local autocorr_lnominal "$\rho$($\Delta NER$)"
local autocorr_lRGDP_WB "$\rho$($\Delta GDP$)"
local autocorr_lconsumption_WB "$\rho$($\Delta C$)"
local autocorr_linvestment_WB "$\rho$($\Delta I$)"
local autocorr_nx_gdp "$\rho$($\Delta NX)"
local autocorr_bloomberg_rate_all "$\rho$($\Delta (1+i)$)"

local corr_lnominal "corr($\Delta  RER,\Delta  NER$)"
local corr_lRGDP_WB "corr($\Delta  RER,\Delta  GDP$)"
local corr_lconsumption_WB "corr($\Delta  RER,\Delta C$)"
local corr_nx_gdp "corr($\Delta  RER,\Delta NX$)"
local corr_bloomberg_rate_all "corr($\Delta  RER,\Delta (1+i)$)"

local corrY_linvestment_WB "corr($\Delta  GDP,\Delta  I$)"
local corrY_lconsumption_WB "corr($\Delta  GDP,\Delta C$)"
local corrY_nx_gdp "corr($\Delta  GDP,\Delta NX$)"
local corrY_bloomberg_rate_all "corr($\Delta  GDP,\Delta (1+i)$)"


global outlier_low = 0.5
global outlier_high = 99.5
global write_table = 1

forval i = 1/2{
	use ./WorkingData/Cleaned/Dataset_regresson_includingUS.dta,clear

	gen nx_gdp = (exports_WB - imports_WB)/RGDP_WB
	gen dlog0_nx_gdp = nx_gdp - L.nx_gdp
	drop if Exrate_Regime == 14 | Exrate_Regime == 15
	bysort Country_Code (Time_Period): gen horizon = _n - 1 if _n <= 1

	if `i' == 2{
		gen sample_period = Time_Period < 1973
		local splitsample sample_period
	}
	else{
		keep if  Time_Period >= 1973
		gen peg_one = inrange(Exrate_Regime,1,8)
		local splitsample peg_one
	}
	


	foreach v in lnominal lreal lRGDP_WB lconsumption_WB nx_gdp bloomberg_rate_all lexrate_to_USD linvestment_WB {
		qui gen out_`v' = 0
		
		qui centile(dlog0_`v'), centile(${outlier_low}, ${outlier_high})
		local low `r(c_1)'
		local high `r(c_2)'
		qui replace out_`v' = 1 if ( dlog0_`v' < `low'  | dlog0_`v' > `high' )



		sum dlog0_`v' if `splitsample' == 1  & out_`v' == 0 
		local std = string(`r(sd)', "%9.3f")
		local std_`v' "`std_`v'' &&  `std'"

		sum dlog0_`v' if `splitsample' == 0  & out_`v' == 0 
		local std = string(`r(sd)', "%9.3f")
		local std_`v' "`std_`v'' &  `std'"
	}
	foreach v in lreal lnominal lRGDP_WB lconsumption_WB nx_gdp bloomberg_rate_all linvestment_WB {
		corr lreal L.dlog0_`v' if `splitsample' == 1 & out_`v' == 0 
		local autoc = string(`r(rho)', "%9.3f")
		local autocorr_`v' "`autocorr_`v'' &&  `autoc'"

		corr lreal L.dlog0_`v' if `splitsample' == 0 & out_`v' == 0 
		local autoc = string(`r(rho)', "%9.3f")
		local autocorr_`v' "`autocorr_`v'' &  `autoc'"
	}

	foreach v in lnominal lRGDP_WB lconsumption_WB nx_gdp bloomberg_rate_all linvestment_WB{
		corr dlog0_lreal dlog0_`v' if `splitsample' == 1 & out_`v' == 0 
		local corrstat = string(`r(rho)' , "%9.3f")
		local corr_`v' "`corr_`v'' &&  `corrstat'"
		corr dlog0_lreal dlog0_`v' if `splitsample' == 0 & out_`v' == 0 
		local corrstat = string(`r(rho)' , "%9.3f")
		local corr_`v' "`corr_`v'' &  `corrstat'"

		corr dlog0_lRGDP_WB dlog0_`v' if `splitsample' == 1 & out_`v' == 0 
		local corrstat = string(`r(rho)' , "%9.3f")
		local corrY_`v' "`corrY_`v'' &&  `corrstat'"
		corr dlog0_lRGDP_WB dlog0_`v' if `splitsample' == 0 & out_`v' == 0 
		local corrstat = string(`r(rho)' , "%9.3f")
		local corrY_`v' "`corrY_`v'' &  `corrstat'"
	}

}
if $write_table == 1{
	file open fh using "$fig_table_folder/Table_4.tex", write replace
	file write fh "\textbf{A. Volatility} \\ " _n
	file write fh "\quad `std_lnominal' \\ " _n
	file write fh "\quad `std_lreal' \\" _n
	file write fh "\quad `std_lRGDP_WB' \\" _n
	file write fh "\quad `std_lconsumption_WB' \\" _n
	file write fh "\quad `std_nx_gdp' \\" _n
	file write fh "\quad `std_bloomberg_rate_all' \\" _n
	file write fh "\quad \\" _n

	file write fh "\textbf{B. Correlation} \\ " _n
	*file write fh "\quad `autocorr_rer' \\" _n
	file write fh "\quad `corr_lnominal' \\" _n
	file write fh "\quad `corr_lRGDP_WB' \\" _n
	file write fh "\quad `corr_lconsumption_WB' \\" _n
	file write fh "\quad `corr_nx_gdp' \\ " _n
	file write fh "\quad `corr_bloomberg_rate_all' \\ \hline" _n

	file close fh


	file open fh using "$fig_table_folder/Business_cycle_moments_others.tex", write replace
	*file write fh "\textbf{A. Volatility} \\ " _n
	file write fh "\quad `std_linvestment_WB' \\ " _n
	*file write fh "\textbf{B. Correlation} \\ " _n
	*file write fh "\quad `autocorr_rer' \\" _n
	file write fh "\quad `corrY_lconsumption_WB' \\" _n
	file write fh "\quad `corrY_linvestment_WB' \\" _n
	file write fh "\quad `corrY_nx_gdp' \\" _n
	file write fh "\quad `corrY_bloomberg_rate_all' \\ " _n

	file write fh "\quad `autocorr_lreal' \\" _n
	file write fh "\quad `autocorr_lnominal' \\" _n
	file write fh "\quad `autocorr_lRGDP_WB' \\" _n
	file write fh "\quad `autocorr_lconsumption_WB' \\" _n
	file write fh "\quad `autocorr_linvestment_WB' \\ " _n
	file write fh "\quad `autocorr_nx_gdp' \\ " _n
	file write fh "\quad `autocorr_bloomberg_rate_all' \\ " _n

	file close fh
}

di "`std_lnominal'"
di "`std_lexrate_to_USD'"





