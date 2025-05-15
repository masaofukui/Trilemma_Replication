cd "/Users/fukui/Dropbox (Personal)/Trilemma/Trilemma_Replication/Empirics"
use ./WorkingData/Cleaned/Dataset_regresson.dta,clear
drop if inlist(ISO_Code,"JPN","BEL","AUS","AUT","CAN","DNK","FIN","FRA")
drop if inlist(ISO_Code,"DEU","GRC","HKG","IRL","ITA","KOR","NLD","NZL","NOR")
drop if inlist(ISO_Code,"PRT","SGP","ESP","SWE","GBR","CHE")
drop if inrange(Exrate_Regime,14,15)
keep if Time_Period >= 1973


global fig_slide_folder "./Figures"
global fig_slide_folder "./Figures"
global fig_save = 1
global fine = 1

if $fine == 1{
	gen Regime_USD = Exrate_Regime if anchor_USD == 1
	*replace Regime_USD = 9 if anchor_USD == 1 & inrange(Exrate_Regime,9,12)
	replace Regime_USD = 13 if inrange(Exrate_Regime,13,13)
	replace Regime_USD = 14 if anchor_USD == 0 & inrange(Exrate_Regime,1,4)
	replace Regime_USD = 15 if anchor_USD == 0 & inrange(Exrate_Regime,5,8)
	replace Regime_USD = 16 if anchor_USD == 0 & inrange(Exrate_Regime,9,12)
	*replace Regime_USD = 17 if anchor_USD == 0 & peg_peg_USD == 1



	xi i.Regime_USD,noomit
	drop _IRegime_US_13


	global outlier_low = 0.5
	global outlier_high = 99.5
	qui centile(dlog0_lexrate_to_USD), centile(${outlier_low}, ${outlier_high})
	local low `r(c_1)'
	local high `r(c_2)'
	qui replace dlog0_lexrate_to_USD = . if ( dlog0_lexrate_to_USD <= `low'  | dlog0_lexrate_to_USD >= `high' )

	
	reghdfe dlog0_lexrate_to_USD i._IRegime_US*##c.dlog_USA_Nominal_Rate , a(i.region#i.Time_Period i.Country_Code) cluster(Time_Period Country_Code)
	gen b = .
	gen se = .

	gen bx = _n if _n <= 16
	forval i = 1/16{
		if `i' != 13{
			replace b = _b[1._IRegime_US_`i'#c.dlog_USA_Nominal_Rate] if bx == `i'
			replace se = _se[1._IRegime_US_`i'#c.dlog_USA_Nominal_Rate] if bx == `i'
		}
	}

	gen up95 = b + 1.96*se
	gen low95 = b - 1.96*se

	replace b = 0 if bx == 13

	twoway (scatter b bx , msymbol(o) msize(3)) ///
	(rcapsym up95 low95 bx , msymbol(none)  color(navy) lw(0.5)), ///
	legend(off) graphregion(color(white)) yline(0,lp(dash) lc(forest_green)) ///
	xlabel(1(1)16 14 "13.1" 15 "13.2" 16 "13.3" , angle(45)) ///
	 xtitle("") xsize(6) ysize(4) ///
	xline(8.5,lp(solid) lc(gs10)) xline(12.5,lp(solid) lc(gs10)) ylabel(-1.5(0.5)1.5)
	if $fig_save == 1{
		graph export  "$fig_slide_folder/Figure_2.pdf",replace
	}

}
else{
	gen Regime_USD = 4 if inrange(Exrate_Regime,13,13)
	replace Regime_USD = 1 if anchor_USD == 1 & inrange(Exrate_Regime,1,4)
	replace Regime_USD = 2 if anchor_USD == 1 & inrange(Exrate_Regime,5,8)
	replace Regime_USD = 3 if anchor_USD == 1 & inrange(Exrate_Regime,9,12)

	replace Regime_USD = 5 if anchor_USD == 0 & inrange(Exrate_Regime,1,4)
	replace Regime_USD = 6 if anchor_USD == 0 & inrange(Exrate_Regime,5,8)
	replace Regime_USD = 7 if anchor_USD == 0 & inrange(Exrate_Regime,9,12)

	xi i.Regime_USD,noomit
	drop _IRegime_US_4


	global outlier_low = 0.5
	global outlier_high = 99.5
	qui centile(dlog0_lexrate_to_USD), centile(${outlier_low}, ${outlier_high})
	local low `r(c_1)'
	local high `r(c_2)'
	qui replace dlog0_lexrate_to_USD = . if ( dlog0_lexrate_to_USD <= `low'  | dlog0_lexrate_to_USD >= `high' )

	
	reghdfe dlog0_lexrate_to_USD i._IRegime_US*##c.dlog_USA_Nominal_Rate , a(i.region#i.Time_Period i.Country_Code) cluster(Time_Period Country_Code)
	gen b = .
	gen se = .

	gen bx = _n if _n <= 7
	forval i = 1/7{
		if `i' !=4 {
			replace b = _b[1._IRegime_US_`i'#c.dlog_USA_Nominal_Rate] if bx == `i'
			replace se = _se[1._IRegime_US_`i'#c.dlog_USA_Nominal_Rate] if bx == `i'
		}
	}

	gen up95 = b + 1.96*se
	gen low95 = b - 1.96*se

	replace b = 0 if bx == 4

	twoway (scatter b bx , msymbol(o) msize(3)) ///
	(rcapsym up95 low95 bx , msymbol(none)  color(navy) lw(0.5)), ///
	legend(off) graphregion(color(white)) yline(0,lp(dash) lc(forest_green)) ///
	xlabel(1(1)3 4 "4" 5 "4.1" 6 "4.2" 7 "4.3", angle(45)) xtitle("") ///
	xline(2.5,lp(solid) lc(gs10)) xline(3.5,lp(solid) lc(gs10))
	if $fig_save == 1{
		graph export  "$fig_slide_folder/USDexposure_coarse.pdf",replace
	}


}



/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 

use ./WorkingData/Cleaned/Dataset_regresson.dta,clear
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/anchor_currency.dta,nogen keep(1 3)
drop if inlist(ISO_Code,"JPN","BEL","AUS","AUT","CAN","DNK","FIN","FRA")
drop if inlist(ISO_Code,"DEU","GRC","HKG","IRL","ITA","KOR","NLD","NZL","NOR")
drop if inlist(ISO_Code,"PRT","SGP","ESP","SWE","GBR","CHE")
drop if inrange(Exrate_Regime,14,15)
keep if Time_Period >= 1973

if $fine == 1{
	gen Regime_USD = Exrate_Regime if anchor_USD == 1
	*replace Regime_USD = 9 if anchor_USD == 1 & inrange(Exrate_Regime,9,12)
	replace Regime_USD = 13 if inrange(Exrate_Regime,13,13)
	replace Regime_USD = 14 if anchor_USD == 0 & inrange(Exrate_Regime,1,4)
	replace Regime_USD = 15 if anchor_USD == 0 & inrange(Exrate_Regime,5,8)
	replace Regime_USD = 16 if anchor_USD == 0 & inrange(Exrate_Regime,9,12)
	replace Regime_USD = 17 if inlist(anchor_currency,"ZAR","INR","SGD")
	replace Regime_USD = 18 if inlist(anchor_currency,"USD-EUR","USD-AUD")



	xi i.Regime_USD,noomit
	drop _IRegime_US_13


	global outlier_low = 0.5
	global outlier_high = 99.5
	qui centile(dlog0_lexrate_to_USD), centile(${outlier_low}, ${outlier_high})
	local low `r(c_1)'
	local high `r(c_2)'
	qui replace dlog0_lexrate_to_USD = . if ( dlog0_lexrate_to_USD <= `low'  | dlog0_lexrate_to_USD >= `high' )

	
	reghdfe dlog0_lexrate_to_USD i._IRegime_US*##c.dlog_USA_Nominal_Rate , a(i.region#i.Time_Period i.Country_Code) cluster(Time_Period Country_Code)
	gen b = .
	gen se = .

	gen bx = _n if _n <= 18
	forval i = 1/18{
		if `i' != 13{
			replace b = _b[1._IRegime_US_`i'#c.dlog_USA_Nominal_Rate] if bx == `i'
			replace se = _se[1._IRegime_US_`i'#c.dlog_USA_Nominal_Rate] if bx == `i'
		}
	}

	gen up95 = b + 1.96*se
	gen low95 = b - 1.96*se

	replace b = 0 if bx == 13

	twoway (scatter b bx , msymbol(o) msize(3) color(navy)) ///
	(rcapsym up95 low95 bx , msymbol(none)  color(navy) lw(0.5)), ///
	legend(off) graphregion(color(white)) yline(0,lp(dash) lc(forest_green)) ///
	xlabel(1(1)17 14 "13.1" 15 "13.2" 16 "13.3" 17 "ZAR, INR, SGD" 18 "USD-EUR, USD-AUD", angle(45)) ///
	 xtitle("") xsize(6) ysize(4) ///
	xline(8.5,lp(solid) lc(gs10)) xline(12.5,lp(solid) lc(gs10)) ylabel(-1.5(0.5)1.5)
	if $fig_save == 1{
		graph export  "${fig_slide_folder}/Figure_A1.pdf",replace
	}

}



