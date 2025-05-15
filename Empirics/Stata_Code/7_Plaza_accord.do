cd "/Users/fukui/Dropbox (Personal)/Trilemma/Trilemma_Replication/Empirics"
global fig_slide_folder "./Figures"

use ./WorkingData/Cleaned/Dataset_regresson.dta,clear

global tpre = 3
global tpost = 5

global year_shock = 1985
global ystart = $year_shock - $tpre
global yend = $year_shock + $tpost

global tpre_p1 = $tpre + 1

keep if Time_Period >= $ystart
gen peg_USD_1985 = (anchor_USD == 1 & inrange(Exrate_Regime,1,8) & Time_Period == $year_shock)
gen drop_country = (anchor_USD == 1 & inrange(Exrate_Regime,9,12) & Time_Period == $year_shock)

bysort Country_Code: egen mpeg_USD_1985 = sum(peg_USD_1985)
bysort Country_Code: egen mdrop_country = sum(drop_country)


bysort Country_Code (Time_Period): gen dlexrate = log(Exrate_per_USA/CPI)- log(Exrate_per_USA[${tpre_p1}]/CPI[${tpre_p1}])
bysort Country_Code (Time_Period): gen dlgdp = lRGDP_WB - lRGDP_WB[${tpre_p1}]
bysort Country_Code (Time_Period): gen dlpvd = (exports_WB-imports_WB)/RGDP_WB - (exports_WB[${tpre_p1}] - imports_WB[${tpre_p1}])/RGDP_WB[${tpre_p1}]

drop if Exrate_Regime == 14 | Exrate_Regime == 15
drop if inlist(ISO_Code, "JPN","USA","GBR","FRA","DEU")

/*
drop if inlist(ISO_Code,"JPN","BEL","AUS","AUT","CAN","DNK","FIN","FRA")
drop if inlist(ISO_Code,"DEU","GRC","HKG","IRL","ITA","KOR","NLD","NZL","NOR")
drop if inlist(ISO_Code,"PRT","SGP","ESP","SWE","GBR","CHE","MEX")
drop if inlist(ISO_Code, "JPN","USA","GBR","FRA","DEU")
drop if mdrop_country == 1

*/
/*
foreach var of varlist dlexrate dlgdp{
	forval yr = $ystart/$yend{
		if `yr' != $year_shock{
			centile(`var') if Time_Period == `yr', centile(0.5,99.5)
			local low `r(c_1)'
			local high `r(c_2)'
			replace `var' = . if ( `var' <= `low'  | `var' >= `high' ) & Time_Period == `yr'
		}
	}
}
*/
/*
tw (hist dlgdp if mpeg_USD_1985 == 1 & Time_Period == 1990, color(red%10) bin(20))  ///
 (hist dlgdp if mpeg_USD_1985 == 0 & Time_Period == 1990, color(blue%10) bin(20)) ///
 , graphregion(color(white)) legend(order(1 "Peg" 2 "Float")) title("GDP growth 1985-1990")
*/

reg dlexrate mpeg_USD_1985 if Time_Period == 1986, robust
reg dlgdp mpeg_USD_1985 if Time_Period == 1990, robust


collapse (mean) dlexrate dlgdp dlpvd (sd) sd_dlexrate = dlexrate (sd) sd_dlgdp = dlgdp, by(mpeg_USD_1985 Time_Period)



foreach pv of varlist dlgdp dlexrate dlpvd{
	/*
	gen up95_`pv' = `pv' + 1.96*sd_`pv'
	gen low95_`pv' = `pv' - 1.96*sd_`pv'
	*/

	if "`pv'" == "dlexrate"{
		global title_label "Log Real Exchange Rate to USD"
		global text_loc -0.37
	}
	else if "`pv'" == "dlgdp"{
		global title_label "Log GDP"
		global text_loc -0.07
	}
	if $year_shock == 1985{
		global text_label text($text_loc $year_shock  "Plaza accord", place(e) color(forest_green) size(5)) 
	}
	else{
		global text_label 
	}
	tw ( scatter `pv' Time_Period if mpeg_USD_1985 == 0,c(l) lw(0.5) msize(2)) ///
	( scatter `pv' Time_Period if mpeg_USD_1985 == 1,c(l) msymbol(S) lw(0.5) color(maroon) msize(2))  ///
	if inrange(Time_Period,$ystart,$yend), graphregion(color(white)) xline($year_shock, lp(dash) lc(forest_green)) ///
	legend(order(1 "Float vs. USD" 2 "Peg to USD")) ///
	ytitle("") $text_label ///
	xtitle("Year") xlabel($ystart(1)$yend) ///
	title("$title_label") name(`pv',replace)

	}


graph combine dlexrate dlgdp, graphregion(color(white)) xsize(10) ysize(4) iscale(1)
graph export "$fig_slide_folder/Figure_9.pdf",replace


