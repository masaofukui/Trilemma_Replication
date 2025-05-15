
local var RGDP_WB
global varlist lnominal lreal RGDP_WB consumption_WB
global varlist2 lreal RGDP_WB 
global varlist3 RGDP_WB 
global n_pre = -3
global n_post = 9
global spec = 1


/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 

foreach var in $varlist{
	use  ./Stored_Result/IRF_coef/IRF_${spec}_`var'_byopeness_1,clear
	foreach v of varlist *_spec{
		rename `v' `v'_open
	}
	qui merge m:1 horizon using ./Stored_Result/IRF_coef/IRF_${spec}_`var'_byopeness_2,nogen

	if "`var'" == "lnominal"{
		local lab "Noimnal Effective Exchange Rate"
	}
	else if "`var'" == "lreal"{
		local lab "Real Effective Exchange Rate"
	}
	else if "`var'" == "RGDP_WB"{
		local lab "GDP"
	}
	else if "`var'" == "consumption_WB"{
		local lab "Consumption"
	}



		
	gen zeroline = 0
	tw (rarea up95_spec low95_spec horizon, bcolor(navy%25) clw(medthin medthin)) ///
	(line zeroline horizon, lp(dash) lc(maroon) ) (scatter bh_spec horizon, c(l) clp(l) ms(5) clc(navy) mc(navy) clw(thick)) ///
	(rarea up95_spec_open low95_spec_open horizon, bcolor(maroon%25)) ///
	(scatter bh_spec_open horizon, c(l) clp(l) ms(5) msymbol(S) clc(maroon) mc(maroon) clw(thick)), ///
	graphregion(color(white)) xlabel($n_pre(1)$n_post) ///
	title("`lab'") ytitle("") xtitle("Years")  name(`var',replace) ///
	 legend(order(3 "Trade Openess < Median" 5 " > Median")  position(6) rows(1)) ///
	 xlab(,nogrid)

}


graph combine $varlist, rows(2) xsize(12) ysize(8) iscale(0.5) graphregion(color(white))

graph export "$fig_slide_folder/slide_${spec}_by_openess.pdf",replace

graph combine $varlist2, rows(1) xsize(12) ysize(5) iscale(1) graphregion(color(white))

graph export "$fig_slide_folder/slide_${spec}_by_openess.pdf",replace



/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 

foreach var in $varlist{
	use  ./Stored_Result/IRF_coef/IRF_${spec}_`var'_byopeness_3,clear
	foreach v of varlist *_spec{
		rename `v' `v'_open
	}
	qui merge m:1 horizon using ./Stored_Result/IRF_coef/IRF_${spec}_`var'_byopeness_4,nogen

	if "`var'" == "lnominal"{
		local lab "Noimnal Effective Exchange Rate"
	}
	else if "`var'" == "lreal"{
		local lab "Real Effective Exchange Rate"
	}
	else if "`var'" == "RGDP_WB"{
		local lab "GDP"
	}
	else if "`var'" == "consumption_WB"{
		local lab "Consumption"
	}



		
	gen zeroline = 0
	tw (rarea up95_spec low95_spec horizon, bcolor(navy%25) clw(medthin medthin)) ///
	(line zeroline horizon, lp(dash) lc(maroon) ) (scatter bh_spec horizon, c(l) clp(l) ms(5) clc(navy) mc(navy) clw(thick)) ///
	(rarea up95_spec_open low95_spec_open horizon, bcolor(maroon%25)) ///
	(scatter bh_spec_open horizon, c(l) clp(l) ms(5) msymbol(S) clc(maroon) mc(maroon) clw(thick)), ///
	graphregion(color(white)) xlabel($n_pre(1)$n_post) ///
	title("`lab'") ytitle("") xtitle("Years")  name(`var',replace) ///
	legend(order(3 "Capital Account Openess < Median" 5 " > Median") position(6) rows(1)) ///
	xlab(,nogrid)

}


graph combine $varlist, rows(2) xsize(12) ysize(8) iscale(0.5) graphregion(color(white))

graph export "$fig_slide_folder/slide_${spec}_by_kaopeness.pdf",replace



graph combine $varlist2, rows(1) xsize(12) ysize(5) iscale(1) graphregion(color(white))

graph export "$fig_slide_folder/slide_${spec}_by_kaopeness.pdf",replace



/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
* by sample period: first and second halves
foreach var in $varlist{
	use  ./Stored_Result/IRF_coef/IRF_${spec}_`var'_byperiod_2,clear
	foreach v of varlist *_spec{
		rename `v' `v'_later
	}
	qui merge m:1 horizon using ./Stored_Result/IRF_coef/IRF_${spec}_`var'_byperiod_1,nogen

	if "`var'" == "lnominal"{
		local lab "Noimnal Effective Exchange Rate"
	}
	else if "`var'" == "lreal"{
		local lab "Real Effective Exchange Rate"
	}
	else if "`var'" == "RGDP_WB"{
		local lab "GDP"
	}
	else if "`var'" == "consumption_WB"{
		local lab "Consumption"
	}



		
	gen zeroline = 0
	tw (rarea up95_spec low95_spec horizon, bcolor(navy%25) clw(medthin medthin)) ///
	(line zeroline horizon, lp(dash) lc(maroon) ) (scatter bh_spec horizon, c(l) clp(l) ms(5) clc(navy) mc(navy) clw(thick)) ///
	(rarea up95_spec_later low95_spec_later horizon, bcolor(maroon%25)) ///
	(scatter bh_spec_later horizon, c(l) clp(l) ms(5) msymbol(S) clc(maroon) mc(maroon) clw(thick)), ///
	graphregion(color(white)) xlabel($n_pre(1)$n_post) ///
	title("`lab'") ytitle("") xtitle("Years")  name(`var',replace) ///
	legend(order(3 "1973-1995" 5 "1996-2019")  position(6) rows(1)) ///
	xlab(,nogrid)
}


graph combine $varlist, rows(2) xsize(12) ysize(8) iscale(0.5) graphregion(color(white))

graph export "$fig_slide_folder/slide_${spec}_by_period.pdf",replace



graph combine $varlist2, rows(1) xsize(12) ysize(5) iscale(1) graphregion(color(white))

graph export "$fig_slide_folder/slide_${spec}_by_period.pdf",replace

