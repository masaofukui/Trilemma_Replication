cd "/Users/fukui/Dropbox (Personal)/Trilemma/Trilemma_Replication/Empirics"
global fig_table_folder "./Tables"

use ./WorkingData/Cleaned/Dataset_regresson.dta,clear
drop if inlist(ISO_Code,"JPN","BEL","AUS","AUT","CAN","DNK","FIN","FRA")
drop if inlist(ISO_Code,"DEU","GRC","HKG","IRL","ITA","KOR","NLD","NZL","NOR")
drop if inlist(ISO_Code,"PRT","SGP","ESP","SWE","GBR","CHE","MEX")
drop if Exrate_Regime == 14 | Exrate_Regime == 15
keep if inrange(Time_Period,1973,2019)
drop if anchor_USD == 1 & inrange(Exrate_Regime,9,12) 
keep if peg_dlogUS !=. 
br if peg_USD == 0
capture file close fh
file open fh using "$fig_table_folder/Table_A3.tex", write replace

bysort Country_Code (Time_Period): gen tid = _n

local v lnominal
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Nominal effective exchange rate & Darvas (2021) & `obs' & `cobs' \\" _n

local v lreal
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Real effective exchange rate & Darvas (2021) & `obs' & `cobs' \\" _n


local v xr
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Exchange rate to USD & IFS & `obs' & `cobs' \\" _n

local v RGDP_WB
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "GDP & WDI & `obs' & `cobs' \\" _n

local v consumption_WB
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Consumption & WDI & `obs' & `cobs' \\" _n

local v investment_WB
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Investment & WDI & `obs' & `cobs' \\" _n


local v exports_WB
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Export & WDI & `obs' & `cobs' \\" _n

local v imports_WB
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Import & WDI & `obs' & `cobs' \\" _n


local v net_exports_WB
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Net Exports & Constructed & `obs' & `cobs' \\" _n


local v bloomberg_rate_all
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Nominal Interest Rate & IFS & `obs' & `cobs' \\" _n


local v lCPI
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "CPI & IFS & `obs' & `cobs' \\" _n



local v real_rate_all_bloomberg
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Ex-post Real Interest Rate & Constructed & `obs' & `cobs' \\" _n


local v lexport_price_WB
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Export Unit Value & UNCTAD & `obs' & `cobs' \\" _n


local v limport_price_WB
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Import Unit Value & UNCTAD & `obs' & `cobs' \\" _n


local v lTerms_of_trade_WB
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Terms of Trade & Constructed & `obs' & `cobs' \\" _n


local v manuf_gdp
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Manufacturing GDP & WDI & `obs' & `cobs' \\" _n

local v service_gdp
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Service GDP & WDI & `obs' & `cobs' \\" _n

local v agri_gdp
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Agriculture GDP & WDI & `obs' & `cobs' \\" _n

local v construction_gdp
sum `v'
local obs = `r(N)'
bysort Country_Code: egen m`v' = mean(`v')
sum m`v' if tid == 1
local cobs = `r(N)'
file write fh "Mining, Construction, Energy GDP & WDI & `obs' & `cobs' \\ \hline" _n


file close fh


