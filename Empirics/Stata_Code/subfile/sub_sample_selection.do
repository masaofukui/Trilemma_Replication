drop if inlist(ISO_Code,"JPN","BEL","AUS","AUT","CAN","DNK","FIN","FRA")
drop if inlist(ISO_Code,"DEU","GRC","HKG","IRL","ITA","KOR","NLD","NZL","NOR")
drop if inlist(ISO_Code,"PRT","SGP","ESP","SWE","GBR","CHE","MEX")
drop if inlist(ISO_Code,"USA")
drop if Exrate_Regime == 14 | Exrate_Regime == 15
keep if inrange(Time_Period,1973,2019)
drop if anchor_USD == 1 & inrange(Exrate_Regime,9,12) 
keep if peg_dlogUS !=. 
drop if (peg_change == 1) | (L.peg_change == 1) 

