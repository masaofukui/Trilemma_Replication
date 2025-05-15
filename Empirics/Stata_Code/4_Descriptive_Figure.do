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

global msize = 2
twoway (scatter USA_BIS_Nominal Time_Period  if ISO_Code == "JPN",connect(l) msize($msize)) /*
*/(scatter FRA_BIS_Nominal Time_Period  if ISO_Code == "JPN",connect(l) msize($msize) msymbol(S)) /*
*/ (scatter GBR_BIS_Nominal Time_Period  if ISO_Code == "JPN",connect(l) msize($msize) msymbol(x)) /*
*/ (scatter DEU_BIS_Nominal Time_Period  if ISO_Code == "JPN",connect(l) msize($msize) msymbol(T)) /*
*/ if Time_Period >= 1973, xlabel(1980(10)2020) graphregion(color(white)) title("Nominal Effective Exchange Rate") /*
*/ legend(order(1 "US Dollar" 2 "French Franc" 3 "British Pound" 4 "German Mark/Euro")) xtitle("Year")
graph export $fig_folder/nominal_ex_rate_overtime.pdf,replace

twoway (scatter USA_BIS_Real Time_Period  if ISO_Code == "JPN",connect(l) msize($msize)) /*
*/(scatter FRA_BIS_Real Time_Period  if ISO_Code == "JPN",connect(l) msize($msize) msymbol(S)) /*
*/ (scatter GBR_BIS_Real Time_Period  if ISO_Code == "JPN",connect(l) msize($msize) msymbol(x)) /*
*/ (scatter DEU_BIS_Real Time_Period  if ISO_Code == "JPN",connect(l) msize($msize) msymbol(T)) /*
*/ if Time_Period >= 1973, xlabel(1980(10)2020)  graphregion(color(white)) title("Real Effective Exchange Rate") /*
*/ legend(order(1 "US Dollar" 2 "French Franc" 3 "British Pound" 4 "German Mark/Euro")) xtitle("Year")
graph export $fig_folder/real_ex_rate_overtime.pdf,replace



twoway (line USA_BIS_Nominal Time_Period  if ISO_Code == "JPN",lw(1)) /*
*/ if Time_Period >= 1973, xlabel(1980(10)2020)  graphregion(color(white)) title("") /*
*/ legend(order(1 "US Dollar" 2 "French Franc" 3 "British Pound" 4 "German Mark/Euro")) xtitle("Year") ///
ytitle("") xsize(9) ysize(6)
graph export $fig_slide_folder/Figure_1.pdf,replace





use ./WorkingData/Cleaned/Dataset_regresson.dta,clear
keep if ISO_Code == "JPN"
keep if Time_Period >= 1973
tw (line USA_BIS_Nominal Time_Period, yaxis(1) lw(0.8)) (line bloomberg_Commodity_Price Time_Period, yaxis(2) lp(dash) lw(0.8)), ///
graphregion(color(white)) legend(order(1 "US Dollar Trade-Weighted Exchange Rate (left axis)" 2 "Bloomberg Commodity Price Index (right axis)") rows(2)) ///
ytitle("",axis(1)) ytitle("",axis(2)) xlabel(1980(10)2020) xtitle("Year")
corr dlog_Commodity dlog_USA_BIS_Nominal if Time_Period  2000
graph export "$fig_slide_folder/Figure_A25.pdf",replace

/*
bysort Time_Period: egen frac_pegUSD = mean(peg*peg_USD)
bysort Time_Period: egen frac_pegGBP = mean(peg*peg_GBP)
bysort Time_Period: egen frac_pegFRA = mean(peg*peg_FRF)
bysort Time_Period: egen frac_pegEUR = mean(peg*peg_EUR)
bysort Time_Period: egen frac_pegDEM = mean(peg*peg_DEM)
gen frac_pegDEM_EUR = frac_pegDEM + frac_pegEUR
gen floaters = 1 - frac_pegGBP - frac_pegUSD -frac_pegFRA-frac_pegEUR-frac_pegDEM



local fig twoway (scatter floaters Time_Period  if ISO_Code == "JPN",connect(l) msize($msize)) /*
*/ (scatter frac_pegUSD Time_Period  if ISO_Code == "JPN",connect(l) msize($msize) msymbol(S)) /*
*/(scatter frac_pegGBP Time_Period  if ISO_Code == "JPN",connect(l) msize($msize)  msymbol(D)) /*
*/ (scatter frac_pegFRA Time_Period  if ISO_Code == "JPN",connect(l) msize($msize) msymbol(x)) /*
*/ (scatter frac_pegDEM_EUR Time_Period  if ISO_Code == "JPN",connect(l) msize($msize) msymbol(T)) /*
*/ if Time_Period >= 1973,  xlabel(1980(10)2020) graphregion(color(white)) legend(row(2)) title("Exchange Rate Regime Share") /*
*/ legend(order(1 "Float" 2 "US Dollar" 3 "British Pound" 4 "French Franc" 5 "German Mark/Euro")) xtitle("Year")

`fig' xsize(8)
graph export  $fig_folder/exrate_regime_share.pdf,replace

`fig' xsize(6) ysize(4) title("")

graph export  $fig_slide_folder/exrate_regime_share_slide.pdf,replace


gen floaters_USD = 1 - frac_pegUSD

twoway (line floaters_USD Time_Period  if ISO_Code == "JPN",lw(1)) /*
*/ (line frac_pegUSD Time_Period  if ISO_Code == "JPN",lw(1) lp(dash)) /*
*/ if Time_Period >= 1973,  xlabel(1980(10)2020) graphregion(color(white)) legend(row(2)) title("Exchange Rate Regime Share") /*
*/ legend(order(1 "Floaters vs. USD" 2 "Pegs to USD") rows(1)) xtitle("Year") xsize(6) ysize(4) title("") ///
ylabel(0(0.2)0.8)
graph export  $fig_slide_folder/exrate_regime_USDshare_slide.pdf,replace



gen pegpeg_USD = peg*peg_USD
bysort Time_Period pegpeg_USD: egen gdp_growth_by_pegUSD = mean(dlog_RGDP)
twoway (scatter gdp_growth_by_pegUSD Time_Period  if pegpeg_USD == 1,connect(l) msize($msize)) /*
*/(scatter gdp_growth_by_pegUSD Time_Period  if pegpeg_USD == 0,connect(l) msize($msize) msymbol(S)) /*
*/(scatter USA_BIS_Nominal Time_Period  if pegpeg_USD == 0,connect(l) msize($msize) msymbol(S) yaxis(2)) /*
*/ if Time_Period >= 1973,  xlabel(1980(10)2020) graphregion(color(white)) legend(order(1 "Pegging to USD" 2 "Not Pegging to USD" 3 "Nominal Effective USD"))/*
*/  title("GDP growth by pegging to USD") 
graph export ./result/figures/gdp_growth_by_pegUSD.pdf,replace


ttest dlog0_lRGDP_percapita, by(peg_to_any4currency)
*/



/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
use ./WorkingData/Cleaned/Dataset_regresson.dta,clear
drop if Exrate_Regime == 14 | Exrate_Regime == 15
drop if inlist(ISO_Code,"JPN","BEL","AUS","AUT","CAN","DNK","FIN","FRA")
drop if inlist(ISO_Code,"DEU","GRC","HKG","IRL","ITA","KOR","NLD","NZL","NOR")
drop if inlist(ISO_Code,"PRT","SGP","ESP","SWE","GBR","CHE","MEX")
drop if anchor_USD == 1 & inrange(Exrate_Regime,9,12) 
keep if RGDP_WB !=.
gen peg_USD_peg = peg*peg_USD
collapse (mean) frac_pegUSD = peg_USD_peg, by(Time_Period)
gen floaters_USD = 1 - frac_pegUSD

twoway (line floaters_USD Time_Period ,lw(1) lc(navy)) /*
*/ (line frac_pegUSD Time_Period ,lw(1) lp(dash) lc(maroon)) /*
*/ if Time_Period >= 1973,  xlabel(1980(10)2020) graphregion(color(white)) legend(row(2)) title("Exchange Rate Regime Share") /*
*/ legend(order(1 "Floats vs. USD" 2 "Pegs to USD") rows(1) position(6)) xtitle("Year") xsize(6) ysize(4) title("") ///
ylabel(0(0.2)1.0)
graph export  "$fig_slide_folder/Figure_A3.pdf",replace


/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 

use ./WorkingData/Cleaned/Dataset_regresson.dta,clear
drop if Exrate_Regime == 14 | Exrate_Regime == 15
drop if inlist(ISO_Code,"JPN","BEL","AUS","AUT","CAN","DNK","FIN","FRA")
drop if inlist(ISO_Code,"DEU","GRC","HKG","IRL","ITA","KOR","NLD","NZL","NOR")
drop if inlist(ISO_Code,"PRT","SGP","ESP","SWE","GBR","CHE","MEX")
drop if anchor_USD == 1 & inrange(Exrate_Regime,9,12) 
keep if Time_Period >= 1973
keep if RGDP_WB !=.
gen N =1
collapse (sum) N,by(Time_Period region peg_USD)
reshape wide N, i(Time_Period peg_USD) j(region)
forval i = 1/4{
	replace N`i' = 0 if N`i' == .
}

twoway (line N1 Time_Period if  peg_USD ==0, lw(1) lc(navy)) (line N1 Time_Period if peg_USD ==1, lw(1) lp(dash) lc(maroon)), ///
graphregion(color(white)) title("Africa") name(Africa,replace) legend(order(1 "Floats vs. USD" 2 "Pegs to USD") position(6) rows(1)) ylabel(0(10)40) ytitle("") ///
xtitle("")
twoway (line N2 Time_Period if peg_USD ==0, lw(1) lc(navy)) (line N2 Time_Period if  peg_USD ==1,  lw(1) lp(dash) lc(maroon)), /// 
graphregion(color(white)) title("Americas") name(America,replace) legend(order(1 "Floats vs. USD" 2 "Pegs to USD") position(6) rows(1)) ylabel(0(10)40) ytitle("") ///
xtitle("")
twoway (line N3 Time_Period if peg_USD ==0, lw(1) lc(navy)) (line N3 Time_Period if  peg_USD ==1,  lw(1)lp(dash) lc(maroon)) , ///
graphregion(color(white)) title("Asia/Oceania") name(Asia,replace) legend(order(1 "Floats vs. USD" 2 "Pegs to USD") position(6) rows(1) ) ylabel(0(10)40) ytitle("") ///
xtitle("")
twoway (line N4 Time_Period if  peg_USD ==0,lw(1) lc(navy)) (line N4 Time_Period if peg_USD ==1, lw(1) lp(dash) lc(maroon)), ///
graphregion(color(white)) title("Europe") name(Europe,replace) legend(order(1 "Floats vs. USD" 2 "Pegs to USD") position(6) rows(1)) ylabel(0(10)40) ytitle("") ///
xtitle("")
graph combine Africa America Asia Europe,rows(2) iscale(0.6) title("") graphregion(color(white)) name(new1,replace)

graph export  "$fig_slide_folder/Figure_A4.pdf",replace


/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
use ./WorkingData/Cleaned/Dataset_regresson.dta,clear
drop if inlist(ISO_Code,"JPN","BEL","AUS","AUT","CAN","DNK","FIN","FRA")
drop if inlist(ISO_Code,"DEU","GRC","HKG","IRL","ITA","KOR","NLD","NZL","NOR")
drop if inlist(ISO_Code,"PRT","SGP","ESP","SWE","GBR","CHE","MEX")
drop if Exrate_Regime == 14 | Exrate_Regime == 15
keep if inrange(Time_Period,1973,2019)
drop if anchor_USD == 1 & inrange(Exrate_Regime,9,12) 
global only_true_floats = 0
if ${only_true_floats} == 1{
	drop if anchor_USD == 0 & inrange(Exrate_Regime,1,12) 
	global text_only "_only_true_floats"
}
else{
	global text_only ""
}


capture file close myfile
file open myfile using "$fig_table_folder/Table_2.txt", write replace
label var lRGDP_WB "Log real GDP"
label var lpop "Log Population"
label var lRGDP_percapita "Log Real GDP Per Capita"
label var real_rate_Tbill "Real interest rate (p.p.)"
label var TBill_rate "TBill Rate (p.p.)"
label var inflation_WB "Inflation Rate (p.p.)"
label var nfagdp "NFA to GDP"
label var usa_export_share "Export Share to the US"
label var usa_import_share "Import Share to the US"
label var commodity_export_to_gdp "Commodity Exports to GDP"
label var commodity_import_to_gdp "Commodity Imports to GDP"
label var ka_open "Capital Account Openness"

replace imports_share_WB = imports_share_WB/100
replace exports_share_WB = exports_share_WB/100
replace TBill_rate = TBill_rate*100
replace real_rate_Tbill = real_rate_Tbill*100
replace inflation_WB = inflation_WB*100

foreach var of varlist lpop lRGDP_percapita /// 
exports_share_WB imports_share_WB usa_export_share usa_import_share nfagdp inflation_WB TBill_rate  commodity_export_to_gdp commodity_import_to_gdp ka_open{
	reghdfe `var' peg_USD, noa cluster(Country_Code)
	local b_nocon = string(_b[peg_USD], "%9.2f")
	local se_nocon = string(_se[peg_USD], "%9.2f")
	local zscore = abs(_b[peg_USD]/_se[peg_USD])
	if inrange(`zscore',1.645,1.960){
		local star_nocon "*"
	}
	else if inrange(`zscore',1.960,2.576){
		local star_nocon "**"
	}
	else if inrange(`zscore',2.576,1000){
		local star_nocon "***"
	}
	else{
		local star_nocon ""
	}


	reghdfe `var' peg_USD, a(i.Time_Period) cluster(Country_Code)
	local b_con = string(_b[peg_USD], "%9.2f")
	local se_con = string(_se[peg_USD], "%9.2f")
	local zscore = abs(_b[peg_USD]/_se[peg_USD])
	if inrange(`zscore',1.645,1.960){
		local star_con "*"
	}
	else if inrange(`zscore',1.960,2.576){
		local star_con "**"
	}
	else if inrange(`zscore',2.576,1000){
		local star_con "***"
	}
	else{
		local star_con ""
	}

	reghdfe `var' peg_USD, a(i.region#i.Time_Period) cluster(Country_Code)
	local b_con2 = string(_b[peg_USD], "%9.2f")
	local se_con2 = string(_se[peg_USD], "%9.2f")
	local zscore2 = abs(_b[peg_USD]/_se[peg_USD])
	if inrange(`zscore2',1.645,1.960){
		local star_con2 "*"
	}
	else if inrange(`zscore2',1.960,2.576){
		local star_con2 "**"
	}
	else if inrange(`zscore2',2.576,1000){
		local star_con2 "***"
	}
	else{
		local star_con2 ""
	}


	local lab: variable label `var'
	file write myfile "`lab' & `b_nocon'`star_nocon' & `b_con'`star_con' & `b_con2'`star_con2' \\" _n
	if "`var'" ==  "ka_open"{
		file write myfile " & (`se_nocon') & (`se_con')  & (`se_con2') \\\hline" _n
		*file write myfile " * p < 0.1, ** p<0.05, **** p<0.01" _n

	}
	else{
		file write myfile " & (`se_nocon') & (`se_con') & (`se_con2') \\" _n
	}
}
file close myfile




/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 


use ./WorkingData/Cleaned/Dataset_regresson.dta,clear
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/anchor_currency.dta,nogen keep(1 3)
drop if Exrate_Regime == 14 | Exrate_Regime == 15
drop if inlist(ISO_Code,"JPN","BEL","AUS","AUT","CAN","DNK","FIN","FRA")
drop if inlist(ISO_Code,"DEU","GRC","HKG","IRL","ITA","KOR","NLD","NZL","NOR")
drop if inlist(ISO_Code,"PRT","SGP","ESP","SWE","GBR","CHE","MEX")
drop if anchor_USD == 1 & inrange(Exrate_Regime,9,12) 
keep if Time_Period >= 1973
gen N = 1
keep if RGDP_WB !=. 
*replace anchor_currency = "n.a." if anchor_currency == "Freely_falling"
drop if peg_USD == .
replace anchor_currency = "n.a." if anchor_currency == "Freely_falling"
collapse (sum) N, by(anchor_currency peg_USD)
drop if peg_USD == 1
drop peg_USD
texsave using "${fig_table_folder}/Table_A1.tex",replace valuelabels dataonly
