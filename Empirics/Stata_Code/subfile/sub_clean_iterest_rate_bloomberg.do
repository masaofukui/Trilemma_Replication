cd ./OriginalData/Bloomberg_interest_rate/


local files : dir "./Deposit" files "*.xlsx"
di `files'
foreach file in `files' {
	import excel using "./Deposit/`file'", clear
	rename B deposit_rate_bloomberg
	drop if _n == 1
	gen country_temp = "`file'"
	gen date = date(A,"MDY")
	format date %td
	destring deposit_rate_bloomberg,replace
	split country_temp,p(".x")
	rename country_temp1 country_name
	keep date deposit_rate_bloomberg country_name
	save "./cleaned/deposit/`file'.dta",replace
}

clear
foreach file in `files' {
	append using "./cleaned/deposit/`file'.dta"
}
gen year = year(date)
collapse (mean) deposit_rate_bloomberg, by(year country_name)
save ./cleaned/deposit_rate,replace


/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 

local files : dir "./MoneyMarket" files "*.xlsx"
di `files'
foreach file in `files' {
	import excel using "./MoneyMarket/`file'", clear
	rename B money_market_rate_bloomberg
	drop if _n == 1
	gen country_temp = "`file'"
	gen date = date(A,"MDY")
	format date %td
	destring money_market_rate_bloomberg,replace
	split country_temp,p(".x")
	rename country_temp1 country_name
	keep date money_market_rate_bloomberg country_name
	save "./cleaned/moneymarket/`file'.dta",replace
}

clear
foreach file in `files' {
	append using "./cleaned/moneymarket/`file'.dta"
}
gen year = year(date)
collapse (mean) money_market_rate_bloomberg, by(year country_name)

save ./cleaned/money_market,replace

/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 

local files : dir "./TBill" files "*.xlsx"
di `files'
foreach file in `files' {
	import excel using "./TBill/`file'", clear
	rename B TBill_rate_bloomberg
	drop if _n == 1
	gen country_temp = "`file'"
	gen date = date(A,"MDY")
	format date %td
	destring TBill_rate_bloomberg,replace
	split country_temp,p(".x")
	rename country_temp1 country_name
	keep date TBill_rate_bloomberg country_name
	save "./cleaned/TBill/`file'.dta",replace
}

clear
foreach file in `files' {
	append using "./cleaned/Tbill/`file'.dta"
}
gen year = year(date)
collapse (mean) TBill_rate_bloomberg, by(year country_name)

save ./cleaned/TBill,replace


/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 

local files : dir "./policy_rate" files "*.xlsx"
di `files'
foreach file in `files' {
	import excel using "./policy_rate/`file'", clear
	rename B policy_rate_bloomberg
	drop if _n == 1
	gen country_temp = "`file'"
	gen date = date(A,"MDY")
	format date %td
	destring policy_rate_bloomberg,replace
	split country_temp,p(".x")
	rename country_temp1 country_name
	keep date policy_rate_bloomberg country_name
	save "./cleaned/policy_rate/`file'.dta",replace
}

clear
foreach file in `files' {
	append using "./cleaned/policy_rate/`file'.dta"
}
gen year = year(date)
collapse (mean) policy_rate_bloomberg, by(year country_name)

save ./cleaned/policy_rate,replace



/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
import excel using ./country_list_i.xlsx,clear
keep A B
rename A ISO_Code
rename B country_name
save ./cleaned/country_list,replace

use ./cleaned/deposit_rate,clear
merge m:1 country_name year using ./cleaned/policy_rate,nogen
merge m:1 country_name year using ./cleaned/TBill,nogen
merge m:1 country_name year using ./cleaned/money_market,nogen
merge m:1 country_name using ./cleaned/country_list, nogen 


sort ISO_Code year
bysort ISO_Code: egen sumd = sum(!missing(deposit_rate)) if inrange(year,1973,2019)
bysort ISO_Code: egen summ = sum(!missing(money_market)) if inrange(year,1973,2019)
bysort ISO_Code: egen sumt = sum(!missing(TBill_rate))  if inrange(year,1973,2019)
bysort ISO_Code: egen sump = sum(!missing(policy_rate)) if inrange(year,1973,2019)

foreach var of varlist TBill_rate money_market policy_rate deposit_rate{
	replace `var' = `var'/100
}


gen bloomberg_rate = .
replace bloomberg_rate = TBill_rate if sumt >= sumd & sumt >= summ & sumt >= sump
replace bloomberg_rate = money_market if summ >= sumd & summ > sumt & summ >= sump
replace bloomberg_rate = policy_rate if sump >= sumd & sump > summ & sump > sumt
replace bloomberg_rate = deposit_rate if sumd > summ & sumd > sumt & sumd > sump

/*
gen bloomberg_rate_all = .
replace bloomberg_rate_all = TBill_rate if bloomberg_rate_all == . & sumt > 0 
replace bloomberg_rate_all = money_market if bloomberg_rate_all == . & sumt == 0 & summ > 0 
replace bloomberg_rate_all = policy_rate if bloomberg_rate_all == . & sumt == 0 & summ == 0 & sump > 0
*replace bloomberg_rate_all = policy_rate if bloomberg_rate_all == . & sumt == 0 & sump > 0
*replace bloomberg_rate_all = deposit_rate if bloomberg_rate_all == . & sumt == 0 & summ == 0  & sump == 0 & sumd > 0
*/

gen bloomberg_rate_all = .
replace bloomberg_rate_all = TBill_rate if bloomberg_rate_all == . & sumt >= summ & sumt >=sump
replace bloomberg_rate_all = money_market if bloomberg_rate_all == . & summ >= sumt & summ >=sump
replace bloomberg_rate_all = policy_rate if bloomberg_rate_all == . & sump >= sumt & sump >=summ

/*
gen bloomberg_rate_all = .
replace bloomberg_rate_all = TBill_rate if bloomberg_rate_all == .
replace bloomberg_rate_all = money_market if bloomberg_rate_all == .
replace bloomberg_rate_all = deposit_rate if bloomberg_rate_all == .
replace bloomberg_rate_all = policy_rate if bloomberg_rate_all == .
*/



gen blm_Tbill_policy = TBill_rate_bloomberg if sumt > 0
replace blm_Tbill_policy = policy_rate_bloomberg if blm_Tbill_policy ==. 

gen blm_Tbill_policy_money = TBill_rate_bloomberg if sumt > 0 
replace blm_Tbill_policy_money = policy_rate_bloomberg if blm_Tbill_policy_money ==.
replace blm_Tbill_policy_money = money_market_rate_bloomberg if blm_Tbill_policy_money ==.



br if bloomberg_rate ==. 
rename year Time_Period
drop country_name

save ./cleaned/bloomberg_rate_all,replace


cd ../..