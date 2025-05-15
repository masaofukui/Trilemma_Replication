

local i = 0
foreach f in "./OriginalData/GFD/interest_rate/Masao_Fukui_2_10_2022_12_21_43_PM913_csv.csv" ///
"./OriginalData/GFD/interest_rate/Masao_Fukui_2_10_2022_12_22_47_PM465_csv.csv" ///
"./OriginalData/GFD/interest_rate/Masao_Fukui_2_10_2022_12_23_28_PM78_csv.csv"{
	local i = `i' + 1
	import delimited `f',clear
	keep if periodicity != ""
	compress ticker
	save ./WorkingData/GFD/temp,replace
	import delimited `f',clear
	keep if periodicity == ""
	rename ticker date
	rename name ticker
	rename sector value
	drop if _n == 1
	keep date ticker value
	destring value,replace force
	compress ticker
	merge m:1 ticker using ./WorkingData/GFD/temp,nogen keep(1 3)
	gen date2 = date(date,"MDY")
	format date2 %td
	drop date
	rename date2 date
	save ./WorkingData/GFD/gfd`i',replace
}
clear
forval i = 1/3{
	append using  ./WorkingData/GFD/gfd`i'
}
keep if seriestype == "Treasury Bill Yields"
gen year = year(date)
collapse (mean) value, by(year country)
rename value Tbill_gfd,replace
kountry country,from(other) stuck
rename _ISO3N iso3n
kountry iso3n,from(iso3n) to(iso3c)
keep _ISO3C year Tbill_gfd
rename _ISO3C ISO_Code
rename year Time_Period
drop if ISO_Code == ""
save ./WorkingData/TBill_gfd,replace

clear
forval i = 1/3{
	append using  ./WorkingData/GFD/gfd`i'
}
keep if seriestype == "Interbank Interest Rates"
gen year = year(date)
collapse (mean) value, by(year country)
rename value interbank_gfd,replace
kountry country,from(other) stuck
rename _ISO3N iso3n
kountry iso3n,from(iso3n) to(iso3c)
keep _ISO3C year interbank_gfd
rename _ISO3C ISO_Code
rename year Time_Period
drop if ISO_Code == ""
save ./WorkingData/interbank_gfd,replace



use ./WorkingData/TBill_gfd,clear
merge m:1 ISO_Code Time_Period using ./WorkingData/interbank_gfd, nogen
save ./WorkingData/gdf_interest_rate,replace





/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
* stock price
/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 


local i = 0
foreach file in "Masao_Fukui_2_13_2022_10_06_40_PM106_csv.csv" ///
"Masao_Fukui_2_13_2022_10_09_16_PM502_csv.csv" ///
"Masao_Fukui_2_13_2022_10_11_35_PM141_csv.csv" ///
"Masao_Fukui_2_13_2022_10_23_08_PM775_csv.csv" ///
"Masao_Fukui_2_13_2022_10_29_52_PM310_csv.csv" ///
"Masao_Fukui_2_13_2022_10_31_54_PM259_csv.csv" ///
"Masao_Fukui_2_13_2022_10_32_47_PM333_csv.csv" ///
"Masao_Fukui_2_13_2022_10_33_45_PM480_csv.csv" ///
"Masao_Fukui_2_13_2022_10_35_23_PM106_csv.csv" ///
"Masao_Fukui_2_13_2022_10_36_55_PM301_csv.csv"{
	local i = `i' + 1
	local file  "Masao_Fukui_2_13_2022_10_36_55_PM301_csv.csv"
	insheet using "./OriginalData/GFD/stock_price_index/`file'", comma clear
	keep if periodicity != ""
	compress ticker
	save ./WorkingData/GFD/temp,replace
	insheet using "./OriginalData/GFD/stock_price_index/`file'", comma clear
	keep if periodicity == ""
	rename ticker date
	rename name ticker
	rename sector value
	drop if _n == 1
	keep date ticker value
	destring value,replace force
	compress ticker
	merge m:1 ticker using ./WorkingData/GFD/temp,nogen keep(1 3)
	gen date2 = date(date,"MDY")
	format date2 %td
	drop date
	rename date2 date
	save ./WorkingData/GFD/gfd_stock`i',replace
}
clear
forval i = 1/10{
	append using  ./WorkingData/GFD/gfd_stock`i'
}
save ./WorkingData/GFD/gfd_stock_all,replace

use ./WorkingData/GFD/gfd_stock_all,clear
duplicates drop country, force
keep ticker
save ./WorkingData/GFD/ticker_list,replace

use ./WorkingData/GFD/gfd_stock_all,clear
merge m:1 ticker using ./WorkingData/GFD/ticker_list, keep(3)
gen year = year(date)
collapse (mean) value ,by(year ticker country currency)
rename value stock_price_gfd,replace
rename currency currency_stock_gfd
drop ticker
kountry country,from(other) stuck
rename _ISO3N iso3n
kountry iso3n,from(iso3n) to(iso3c)
keep _ISO3C year stock_price_gfd currency_stock_gfd
rename _ISO3C ISO_Code
rename year Time_Period
drop if ISO_Code == ""
save ./WorkingData/GFD/stock_price_gfd,replace





