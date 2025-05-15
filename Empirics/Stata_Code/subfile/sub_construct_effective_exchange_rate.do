


/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
* GDP weighted USD exchange rate
use ./WorkingData/Cleaned/Dataset.dta,clear
bysort Country_Code (Time_Period): gen dlex_usd = log(1/Exrate_per_USD) - log(1/Exrate_per_USD[_n-1])
bysort Country_Code (Time_Period): gen lag_gdp = RGDP_WB[_n-1]
bysort Country_Code: egen m_gdp = mean(RGDP_WB)

drop if Country_Code == 111
drop if inlist(Exrate_Regime,14,15)
*drop if abs(dlex_usd) > 0.5
*keep if inlist(ISO_Code,"JPN","MEX","BEL","AUS","AUT","CAN","DNK","FIN","FRA") ///
*	| inlist(ISO_Code,"DEU","GRC","HKG","IRL","ITA","KOR","NLD","NZL","NOR") ///
*	| inlist(ISO_Code,"PRT","SGP","ESP","SWE","GBR","CHE")

collapse (mean) dl_GDPw_USD = dlex_usd dlog_USA_BIS_Nominal [aw = lag_gdp],by(Time_Period)

save ./WorkingData/Cleaned/GDPweighted_USD,replace

 
/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 

use ./WorkingData/Cleaned/Dataset_add.dta,clear
keep Country_Code Time_Period Exrate_per_USD CPI
save ./WorkingData/Cleaned/Exrate_temp,replace
rename Country_Code Counterpart_Code
rename Exrate_per_USD  Counter_Exrate_per_USD
rename CPI Counter_CPI
save ./WorkingData/Cleaned/Exrate_temp_counter,replace



/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
import delimited using "OriginalData/IMF_DOT/DOT_01-31-2022 08-09-55-51_panel.csv",clear
drop if floor(counterpartcountrycode/100)==0
rename countrycode Country_Code
rename timeperiod Time_Period
bysort Country_Code Time_Period:  egen tot_export = sum(goodsvalueofexportsfreeonboardfo)
bysort Country_Code Time_Period:  egen tot_import = sum(goodsvalueofimportscostinsurance)
keep if inlist(counterpartcountryname,"United States")
gen usa_export_share = goodsvalueofexportsfreeonboardfo/tot_export
gen usa_import_share = goodsvalueofimportscostinsurance/tot_import
keep Country_Code Time_Period usa_export_share usa_import_share
save ./WorkingData/Cleaned/usa_share.dta,replace


*/
/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 


import delimited using "./OriginalData/IMF_DOT/DOT_01-31-2022 08-12-20-34_panel/DOT_01-31-2022 08-12-20-34_panel.csv",clear


rename countrycode Country_Code
rename timeperiod Time_Period
rename counterpartcountrycode Counterpart_Code
merge m:1 Country_Code Time_Period using ./WorkingData/Cleaned/Exrate_temp, nogen keep(3)
merge m:1 Counterpart_Code Time_Period using ./WorkingData/Cleaned/Exrate_temp_counter, nogen keep(3)
keep if Country_Code == 111

global mexico = 1
if $mexico == 1{
	keep if inlist(counterpartcountryname,"Australia","Austria","Belgium","Canada","Denmark","Finland","France","Germany","Greece") ///
	| inlist(counterpartcountryname,"Ireland","Italy","Japan","Korea","Netherlands","New Zealand","Norway") ///
	| inlist(counterpartcountryname,"Portugal","Singapore","Spain","Sweden","Switzerland","United Kingdom","United States") ///
	| inlist(counterpartcountryname,"China, P.R.: Hong Kong","Taiwan Province of China","Mexico")
}
else{
	keep if inlist(counterpartcountryname,"Australia","Austria","Belgium","Canada","Denmark","Finland","France","Germany","Greece") ///
	| inlist(counterpartcountryname,"Ireland","Italy","Japan","Korea","Netherlands","New Zealand","Norway") ///
	| inlist(counterpartcountryname,"Portugal","Singapore","Spain","Sweden","Switzerland","United Kingdom","United States") ///
	| inlist(counterpartcountryname,"China, P.R.: Hong Kong","Taiwan Province of China")
}
/*
| inlist(counterpartcountryname,"Algeria","Argentina","Brazil","Bulgaria","Chile","China, P.R.: Mainland") ///
| inlist(counterpartcountryname,"Colombia","Croatia","Cyprus","Czech Republic","Estonia") ///
| inlist(counterpartcountryname,"Hungary","Iceland","India","Indonesia","Israel") ///
| inlist(counterpartcountryname,"Latvia","Lithuania","Luxembourg","Malaysia","Malta") ///
| inlist(counterpartcountryname,"Peru","Philippines","Poland","Romania","Russia") ///
| inlist(counterpartcountryname,"Saudi Arabia","Slovakia","Slovenia","South Africa","Thailand") ///
| inlist(counterpartcountryname,"Turkey","United Arab Emirates")
*/
gen cc2 = Country_Code*1000 + Counterpart_Code
tsset cc2 Time_Period
tsfill
replace Country_Code = floor(cc2/1000)
replace Counterpart_Code = mod(cc2,1000)



gen bilateral_nominal_exrate = Exrate_per_USD/Counter_Exrate_per_USD
gen bilateral_real_exrate = bilateral_nominal_exrate /CPI*Counter_CPI


keep if bilateral_real_exrate != . & bilateral_nominal_exrate !=.
bysort Country_Code Time_Period:  egen tot_export = sum(goodsvalueofexportsfreeonboardfo)
bysort Country_Code Time_Period:  egen tot_import = sum(goodsvalueofimportscostinsurance)
gen export_share = goodsvalueofexportsfreeonboardfo/tot_export
gen import_share = goodsvalueofimportscostinsurance/tot_import
*replace export_share = import_share if export_share ==. & import_share != .
*replace import_share = export_share if export_share !=. & import_share == .

gen bilateral_share = (export_share + import_share)/2

gen effective_nominal_exrate = bilateral_nominal_exrate*bilateral_share
gen effective_real_exrate = bilateral_real_exrate*bilateral_share
*bysort Country_Code Counterpart_Code (Time_Period): replace bilateral_share = bilateral_share[_n-1] if missing(bilateral_share)
*bysort Country_Code Counterpart_Code (Time_Period): replace bilateral_share = bilateral_share[_n+1] if missing(bilateral_share)

bysort Country_Code Counterpart_Code (Time_Period): gen lag_share = (  bilateral_share[_n-1] + bilateral_share[_n-2] +bilateral_share[_n-3] )
/*
gen bilateral_exp_imp = goodsvalueofexportsfreeonboardfo + goodsvalueofimportscostinsurance
gen tot_exp_imp = tot_export + tot_import

bysort Country_Code Counterpart_Code (Time_Period): gen lag_share = ///
(bilateral_exp_imp[_n-1] + bilateral_exp_imp[_n-2] + bilateral_exp_imp[_n-3])/ ///
( tot_exp_imp[_n-1] + tot_exp_imp[_n-2] + tot_exp_imp[_n-3] )



bysort Country_Code Counterpart_Code (Time_Period): gen lag_effective_nominal_exrate = bilateral_nominal_exrate*lag_share
bysort Country_Code Counterpart_Code (Time_Period): gen lag_effective_real_exrate = bilateral_real_exrate*lag_share


*/

replace lag_share = 0 if lag_share ==.
bysort Country_Code Counterpart_Code (Time_Period): replace bilateral_nominal_exrate = bilateral_nominal_exrate
bysort Country_Code Counterpart_Code (Time_Period): replace bilateral_real_exrate = bilateral_real_exrate


sort Country_Code Time_Period Counterpart_Code

collapse (mean) lag_effective_nominal_exrate = bilateral_nominal_exrate lag_effective_real_exrate = bilateral_real_exrate [aw = lag_share],by(Country_Code Time_Period)

keep lag_effective_nominal_exrate lag_effective_real_exrate Country_Code Time_Period
rename lag_effective_nominal_exrate c_effective_nominal_exrate$mexico 
rename lag_effective_real_exrate c_effective_real_exrate$mexico 

save ./WorkingData/Cleaned/Effective_constructed$mexico.dta,replace








/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 

foreach yr in 65 170{
	foreach er in REER NEER{
		import excel using "./OriginalData/REER/REER_database_ver7Jan2022.xls", sheet("`er'_ANNUAL_`yr'") clear first
		destring Updated,replace
		drop if Update ==.
		reshape long `er'_`yr'_, i(Updated) j(iso2) string
		kountry iso2, from(iso2c) to(iso3c)
		drop if _ISO3C == ""
		rename _ISO3C ISO_Code
		rename Updated Time_Period
		rename `er'_`yr'_ `er'_`yr'
		keep Time_Period ISO_Code `er'_`yr'
		replace `er'_`yr' = 1000/`er'_`yr'
		save ./WorkingData/Cleaned/`er'_effective_constructed_database_`yr'.dta,replace
	}
}


foreach yr in 51 120{
	foreach er in REER NEER{
		import excel using "./OriginalData/REER/REER_database_ver7Jan2022.xls", sheet("`er'_MONTHLY_`yr'") clear first
		gen year = substr(Updated,1,4)
		destring year,replace
		collapse (mean) `er'_*,by(year)
		drop if year == .
		reshape long `er'_`yr'_, i(year) j(iso2) string
		kountry iso2, from(iso2c) to(iso3c)
		drop if _ISO3C == ""
		rename _ISO3C ISO_Code
		rename year Time_Period
		rename `er'_`yr'_ `er'_`yr'
		keep Time_Period ISO_Code `er'_`yr'
		replace `er'_`yr' = 1000/`er'_`yr'
		save ./WorkingData/Cleaned/`er'_effective_constructed_database_`yr'.dta,replace
	}
}

use ./WorkingData/Cleaned/REER_Effective_constructed_database_65.dta,replace
foreach yr in 51 120 170{
	foreach er in REER NEER{
		merge m:1 Time_Period ISO_Code using ./WorkingData/Cleaned/`er'_effective_constructed_database_`yr'.dta, nogen
	}
}
merge m:1 Time_Period ISO_Code using ./WorkingData/Cleaned/NEER_effective_constructed_database_65.dta, nogen
save ./WorkingData/Cleaned/Effective_constructed_database.dta,replace




/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
*montly data
foreach yr in 51{
	foreach er in REER NEER{
		import excel using "./OriginalData/REER/REER_database_ver7Jan2022.xls", sheet("`er'_MONTHLY_`yr'") clear first
		gen year = substr(Updated,1,4)
		gen month = substr(Updated,6,7)
		destring year month,replace
		gen ym = ym(year,month)
		format ym %tm
		collapse (mean) `er'_*,by(ym)
		drop if ym == .
		reshape long `er'_`yr'_, i(ym) j(iso2) string
		kountry iso2, from(iso2c) to(iso3c)
		drop if _ISO3C == ""
		rename _ISO3C ISO_Code
		rename `er'_`yr'_ `er'_`yr'
		keep ym ISO_Code `er'_`yr'
		replace `er'_`yr' = 1000/`er'_`yr'
		save ./WorkingData/Cleaned/`er'_monthly_effective_constructed_database_`yr'.dta,replace
	}
}
