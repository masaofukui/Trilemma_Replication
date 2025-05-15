cd "/Users/fukui/Dropbox (Personal)/Trilemma/Trilemma_Replication/Empirics"
global load_WB = 0


* Clean interest rate data from bloomberg
do ./Stata_Code/subfile/sub_clean_iterest_rate_bloomberg.do

* Clean the effective exchange rate data
do ./Stata_Code/subfile/sub_construct_effective_exchange_rate.do

* Clean the GFD data
do ./Stata_Code/subfile/sub_clean_GFD.do


* Clean the colonial origin data
use ./OriginalData/Colonial_Origin/qogdata_07_11_2024.dta,clear
rename ccodealp ISO_Code
rename year Time_Period
keep ISO_Code Time_Period ht_colonial
gen colonized_or_not = ht_colonial > 0
gen colonized_by_UK = ht_colonial == 5
gen colonized_by_France = ht_colonial == 6
gen colonized_by_Spain = ht_colonial == 2
gen colonized_by_others = (ht_colonial > 0 & colonized_by_UK == 0 & colonized_by_France == 0 & colonized_by_Spain==0)
save ./WorkingData/Cleaned/colonial_origin,replace


* Clean the currency exposure data
import excel using ./OriginalData/Currency_Exposure/BLSJIE2015data.xls,clear sheet("data") first
gen usd_exposure_bls = FA_GDP*w_A_USD - FL_GDP*w_L_USD
rename ifs_code Country_Code
rename year Time_Period
keep Country_Code Time_Period usd_exposure_bls w_A_USD w_L_USD FXAGG FA_GDP FL_GDP
save ./WorkingData/Cleaned/usd_exposure_bls.dta,replace 


import excel using "./OriginalData/Currency_Exposure/CurrencyDataDec2019LJrevised.xlsx",clear sheet("data") first
gen usd_exposure_lj = A_GDP*w_A_USD - L_GDP*w_L_USD
rename ifs_code Country_Code
rename year Time_Period
rename w_A_USD w_A_USD_lj
rename w_L_USD w_L_USD_lj
rename FXAGG fxagg_lj
keep Country_Code Time_Period usd_exposure_lj w_A_USD_lj w_L_USD_lj fxagg_lj A_GDP L_GDP w_A_FC w_L_FC
drop if Country_Code ==.
save ./WorkingData/Cleaned/usd_exposure_lj.dta,replace


/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
* Johonson Noguera
use "./OriginalData/Johnson Noguera Replication Materials/data/VAdataset.dta",clear
collapse (sum) exports finalexports intermedexports, by(icode year)
rename exports imports_jn
rename final final_imports_jn
rename inter intermed_imports_jn
rename icode ISO_Code
rename year Time_Periodc
save ./WorkingData/Cleaned/JhonsonNoguera.dta,replace

if ${load_WB} == 1{
    wbopendata, language(en - English) indicator(FP.CPI.TOTL) long clear country(USA)
    rename year Time_Period
    gen convert_real = 100/fp_cpi_totl
    keep Time_Period convert_real
    save ./WorkingData/Cleaned/real_convert.dta,replace

    wbopendata, language(en - English) indicator(NY.GDP.MKTP.CD) long clear
    rename countrycode ISO_Code
    rename year Time_Periodconvert_real
    rename ny_gdp_mkt_cd nominal_gdp
    keep ISO_Code Time_Period nominal_gdp
    save ./WorkingData/Cleaned/nominal_gdp.dta,replace


    wbopendata, language(en - English) indicator(NV.AGR.TOTL.KD; NV.SRV.TOTL.KN; NV.IND.TOTL.KD; ///
    FM.AST.NFRG.CN;NY.GDP.MKTP.CN; FR.INR.LEND; TX.QTY.MRCH.XD.WD; PA.NUS.FCRF; TX.QTY.MRCH.XD.WD; ///
     TM.QTY.MRCH.XD.WD; BN.CAB.XOKA.CD;  BN.KLT.DINV.CD;  BN.KLT.PTXL.CD;DT.DOD.DECT.CD; FI.RES.TOTL.CD; ///
     CM.MKT.TRAD.CD;  CM.MKT.LCAP.GD.ZS; NE.CON.GOVT.KD;  CM.MKT.TRAD.GD.ZS;  CM.MKT.LCAP.CD; ///
     FS.AST.DOMS.GD.ZS;FP.CPI.TOTL; ST.INT.ARVL; FM.LBL.BMNY.CN; BX.KLT.DINV.WD.GD.ZS; BN.CAB.XOKA.GD.ZS; ///
     NE.RSB.GNFS.ZS;  BN.TRF.KOGT.CD;FM.LBL.BMNY.GD.ZS; NE.EXP.GNFS.CD; NE.IMP.GNFS.CD; BN.GSR.GNFS.CD; ///
     BN.FIN.TOTL.CD; BN.KAC.EOMS.CD;BX.GSR.GNFS.CD ;BM.GSR.GNFS.CD; GC.DOD.TOTL.GD.ZS) long clear
    rename year Time_Period
    rename countrycode ISO_Code
    rename nv_agr_totl_kd agri_gdp
    rename nv_srv_totl_kn service_gdp_lcu
    rename nv_ind_totl_kd industry_gdp
    rename fr_inr_lend lending_rate
    rename tx_qty_mrch_xd_wd export_quantity
    rename pa_nus_fcrf ex_rate_usd
    rename bn_cab_xoka_cd current_account
    rename bn_cab_xoka_gd_zs current_account_gdp
    rename ne_rsb_gnfs_zs net_export_gdp
    rename bn_trf_kogt_cd capital_account
    rename bn_klt_dinv_cd net_fdi
    rename bx_klt_dinv_wd_gd_zs net_fdi_gdp
    rename tm_qty_mrch_xd_wd import_quantity
    rename bn_klt_ptxl_cd portfolio_inv
    rename dt_dod_dect_cd debt_stock
    rename fi_res_totl_cd reserve
    rename cm_mkt_trad_cd stock_cusd
    rename fs_ast_doms_gd_zs domestic_credit
    rename fp_cpi_totl CPI_WB
    rename cm_mkt_trad_gd_zs stock_gdp
    rename cm_mkt_lcap_gd_zs market_cap_gdp
    rename cm_mkt_lcap_cd market_cap
    rename ne_con_govt_kd government_expenditure
    rename st_int_arvl tourists_inflow
    rename fm_lbl_bmny_cn broad_money
    rename fm_lbl_bmny_gd_zs broad_money_gdp
    rename ne_exp_gnfs_cd exports_WB_cd
    rename ne_imp_gnfs_cd imports_WB_cd
    rename bn_fin_totl_cd net_financial_acc
    rename bn_gsr_gnfs_cd net_trade_cd
    rename bn_kac_eoms_cd net_error_cd
    rename bx_gsr_gnfs_cd export_bop_cd
    rename bm_gsr_gnfs_cd import_bop_cd
    rename gc_dod_totl_gd_zs debt_to_gdp

    gen nfa_to_gdp = fm_ast_nfrg_cn/ny_gdp_mktp_cn
    drop countryname - lendingtypen
    save  ./WorkingData/Cleaned/addWB.dta,replace



    wbopendata, language(en - English) indicator(ST.INT.DPRT) long clear
    rename year Time_Period
    rename countrycode ISO_Code
    rename st_int_dprt tourists_outflow
    drop countryname - lendingtypen
    save  ./WorkingData/Cleaned/addWB_tourists_outflow.dta,replace




    *commodity
    wbopendata, language(en - English) indicator(NY.GDP.MKTP.CN;NE.EXP.GNFS.CN; NE.IMP.GNFS.CN; TX.VAL.MRCH.CD.WT;  TX.VAL.MANF.ZS.UN; NY.GDP.MKTP.CD; TM.VAL.MRCH.CD.WT; TM.VAL.MANF.ZS.UN) long clear
    rename year Time_Period
    rename countrycode ISO_Code
    gen commodity_export_to_gdp = tx_val_mrch_cd_wt * (1- tx_val_manf_zs_un/100) / ny_gdp_mktp_cd 
    gen commodity_import_to_gdp = tm_val_mrch_cd_wt * (1-tm_val_manf_zs_un/100) / ny_gdp_mktp_cd 

    rename ne_exp_gnfs_cn exports_local_cd 
    rename ne_imp_gnfs_cn imports_local_cd 
    rename ny_gdp_mktp_cn gdp_local_cd
    save  ./WorkingData/Cleaned/commodity_data.dta,replace
}

import excel using ./OriginalData/Commodity_Price_index/Masao_Fukui_4_21_2022_3_39_41_PM833_excel2007.xlsx,clear sheet("Price Data") first
rename Open GS_Commodity_Price
destring GS_Commodity_Price,replace
gen date = date(Date,"MDY")
format date %td
gen Time_Period = year(date)
collapse (mean) GS_Commodity_Price, by(Time_Period)
save  ./WorkingData/Cleaned/commodity_price_index.dta,replace


import excel using ./OriginalData/Commodity_Price_index/Masao_Fukui_5_25_2022_2_11_42_PM654_excel2007.xlsx,clear sheet("Price Data") first
rename Open bloomberg_Commodity_Price
destring bloomberg_Commodity_Price,replace
gen date = date(Date,"MDY")
format date %td
gen Time_Period = year(date)
collapse (mean) bloomberg_Commodity_Price, by(Time_Period)
save  ./WorkingData/Cleaned/bloomberg_Commodity_Price_index.dta,replace



clear matrix
clear mata
clear
set maxvar 20000

use "./OriginalData/PennWorldTable/pwt100.dta",clear
rename countrycode ISO_Code
rename year Time_Period
save ./WorkingData/Cleaned/pwt.dta,replace


import excel using "./OriginalData/External Wealth (Lane and Milesi-Ferretti, 2007)/EWN-dataset_12-21-2021.xlsx",clear sheet("Dataset") first
rename IFS_Code Country_Code
rename Year Time_Period
save ./WorkingData/Cleaned/ewn_2021.dta,replace

insheet using "./OriginalData/Credit_BIS/WEBSTATS_TOTAL_CREDIT_DATAFLOW_csv_col.csv",clear
kountry borrowers_cty, from(iso2c) to(iso3c)
rename _ISO3C ISO_Code
keep if tc_borrowers == "C"
keep if unittype == "Percentage of GDP"
keep ISO_Code v23-v338
drop if ISO_Code == ""
reshape long v,i(ISO_Code) j(Time_Period)
replace Time_Period = floor(1942 + (Time_Period-23)/4)
collapse (mean) v, by(ISO_Code Time_Period)
rename v credit_to_gdp_BIS
save ./WorkingData/Cleaned/credit_to_gdp_BIS,replace

use ./WorkingData/Cleaned/Dataset.dta,clear
keep if ISO_Code == "USA"
twoway (line BIS_Real_Effective Time_) ( line BIS_Nominal_Effective Time_) ///
 if inrange(Time_,1973,2019), graphregion(color(white)) graphregion(color(white)) legend(order(1 "US NER" 2 "US RER")) ///


keep Time_Period inflation_CPI TBill_rate RGDP_WB CPI
rename inflation_CPI inflation_CPI_US 
rename TBill_rate TBill_rate_US
rename RGDP_WB US_RGDP_WB
rename CPI CPI_US
save ./WorkingData/Cleaned/USvariable,replace


use ./WorkingData/Cleaned/Effective_constructed_database.dta,clear
keep if ISO_Code == "USA"
keep Time_Period NEER_65 
rename NEER_65 NEER_65_US
save ./WorkingData/Cleaned/US_NEER65,replace

insheet using "./OriginalData/OECD/DP_LIVE_07012022091221954.csv",clear
keep if frequency == "A"
rename location ISO_Code
rename value stock_oecd
rename time Time_Period
keep ISO_Code Time_Period stock_oecd
destring Time_Period,replace force
save ./WorkingData/Cleaned/stock_oecd,replace

insheet using "./OriginalData/OECD/DP_LIVE_07012022121019757.csv",clear
keep if subject == "REAL"
keep if frequency == "A"
rename location ISO_Code
rename value houseprice_oecd
rename time Time_Period
keep ISO_Code Time_Period houseprice_oecd
destring Time_Period,replace force
save ./WorkingData/Cleaned/houseprice_oecd,replace


insheet using "./OriginalData/OECD/DP_LIVE_07012022121501476.csv",clear
keep if subject == "TOT"
keep if frequency == "A"
keep if measure == "AGRWTH"
rename location ISO_Code
rename value inflation_oecd
replace inflation_oecd = inflation_oecd/100
rename time Time_Period
keep ISO_Code Time_Period inflation_oecd
destring Time_Period,replace force
save ./WorkingData/Cleaned/inflation_oecd,replace

insheet using "./OriginalData/OECD/DP_LIVE_07012022121533100.csv",clear
keep if subject == "TOT"
keep if frequency == "A"
rename location ISO_Code
rename value shortrate_oecd
replace shortrate_oecd = shortrate_oecd/100
rename time Time_Period
keep ISO_Code Time_Period shortrate_oecd
destring Time_Period,replace force
save ./WorkingData/Cleaned/shortrate_oecd,replace


insheet using "./OriginalData/FRB_Effective_Exrate/Exrate_FRB.csv",clear
keep major broad time
gen year = substr(time,5,9)
destring year,replace
drop time
collapse (mean) major broad,by(year)
rename major US_NEER_FRB_major
rename broad US_NEER_FRB_broad
rename year Time_Period
replace US_NEER_FRB_major = 1/US_NEER_FRB_major
replace US_NEER_FRB_broad = 1/US_NEER_FRB_broad
save ./WorkingData/Cleaned/FRB_NEER,replace


* compute share of US and peggers and floaters
use ./WorkingData/Cleaned/Dataset.dta,clear
keep if Time_Period >= 1973
drop if Exrate_Regime == 14 | Exrate_Regime == 15
replace peg_USD = -1 if ISO_Code == "USA"
drop if peg_USD == .
collapse (sum) RGDP_WB, by(Time_Period peg_USD)
bysort Time_Period: egen sgdp = sum(RGDP_WB)
gen share = RGDP_WB/sgdp
bysort peg_USD: egen mshare = mean(share)



/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
use "./OriginalData/Chin_Ito_Index_(Capital_Account_Openess)/kaopen_2019.dta", clear
rename cn Country_Code
rename year Time_Period
keep Time_Period ka* Country_Code
save ./WorkingData/Cleaned/kaopen,replace



/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
import excel using "./OriginalData/Exchange_rate_classification/Anchor_monthly_1946-2019.xlsx", sheet("Master") clear
foreach var of varlist B - GQ{
    local ii =`var'[6]
    rename `var' v`ii'
}
drop GR - HL
drop if _n <= 10
reshape long v, i(A) j(ISO_Code) string
split A, p("M")
destring A1 A2,replace
rename A1 Time_Period
rename A2 month
gen peg_INR = v == "INR"
collapse (mean) peg_INR, by(ISO_Code Time_Period)
replace peg_INR = peg_INR >= 0.5
save ./WorkingData/Cleaned/peg_INR,replace


/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
use "./OriginalData/IMF_GDD/Global Debt Database_Dec 2022.dta",clear
rename ifscode Country_Code
drop country
rename year Time_Period
save ./WorkingData/Cleaned/GDD,replace

/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
use ./WorkingData/Cleaned/Dataset.dta,clear
keep ISO_Code peg_USD Time_Period Exrate_Regime
rename ISO_Code peg_ISO_Code
gen peg_peg_USD = (peg_USD == 1)*inrange(Exrate_Regime,1,8)
keep peg_ISO_Code Time_Period peg_peg_USD
save ./WorkingData/Cleaned/peg_peg_USD.dta,replace


/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
import excel using "./OriginalData/Global_Financial_Cycle/291587444_67186463733_GFCFactorUpdated2019.xlsx", sheet("Standardized") clear first
gen Time_Period = substr(B,1,4)
destring Time_Period,replace
rename GlobalFactor19802019New GFC
collapse (mean) GFC, by(Time_Period)
tsset Time_Period
gen d_GFC = GFC - L.GFC
save ./WorkingData/Cleaned/GFC_Rey.dta,replace


/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 


/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
import excel using "./OriginalData/Exchange_rate_classification/Anchor_monthly_1946-2019.xlsx", sheet("Master") clear
foreach var of varlist B - GQ{
    local ii =`var'[6]
    rename `var' v`ii'
}
drop GR - HL
drop if _n <= 10
reshape long v, i(A) j(ISO_Code) string
split A, p("M")
destring A1 A2,replace
rename A1 Time_Period
rename A2 month
gen peg_ISO_Code = ""
replace peg_ISO_Code = "AUS" if v == "AUD"
replace peg_ISO_Code = "BEL" if v == "BEF"
replace peg_ISO_Code = "BRA" if v == "BRL"
replace peg_ISO_Code = "CAN" if v == "CAD"
replace peg_ISO_Code = "CHE" if v == "CHF"
replace peg_ISO_Code = "EGY" if v == "EGP"
replace peg_ISO_Code = "ESP" if v == "ESP"
replace peg_ISO_Code = "IND" if v == "INR"
replace peg_ISO_Code = "ITA" if v == "ITL"
replace peg_ISO_Code = "JPN" if v == "JPY"
replace peg_ISO_Code = "MEX" if v == "MEX"
replace peg_ISO_Code = "NLD" if v == "NLG"
replace peg_ISO_Code = "PRT" if v == "PTE"
replace peg_ISO_Code = "RUS" if v == "RUB"
replace peg_ISO_Code = "SGP" if v == "SGD"
replace peg_ISO_Code = "TUR" if v == "TRL"
replace peg_ISO_Code = "ZAF" if v == "ZAR"
drop if peg_ISO_Code == ISO_Code
drop if peg_ISO_Code == ""
keep if month == 12
merge m:1 peg_ISO_Code Time_Period using  ./WorkingData/Cleaned/peg_peg_USD.dta, nogen keep(1 3)
keep ISO_Code Time_Period peg_peg_USD
save ./WorkingData/Cleaned/peg_peg_USD_merge.dta,replace


/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
use "./OriginalData/MullerVerner/MV_credit_data.dta",clear
rename Total MV_Credit_Total
rename iso3c ISO_Code
rename year Time_Period
keep ISO_Code Time_Period MV_Credit_Total
save ./WorkingData/Cleaned/MV_Credit,replace
*/
/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 

use ./WorkingData/Cleaned/Dataset.dta,clear
*drop if inlist(Exrate_Regime,14,15)
set matsize 11000
bysort ISO_Code: egen mpop = mean(pop)
global descriptive = 0
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/JhonsonNoguera.dta, keep(1 3) nogen
merge m:1 Time_Period using ./WorkingData/Cleaned/real_convert.dta, keep(1 3 ) nogen
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/nominal_gdp.dta, keep(1 3 ) nogen
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/pwt.dta, keep(1 3 ) nogen
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/addWB.dta, nogen keep(1 3)
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/addWB_tourists_outflow.dta, nogen keep(1 3)

merge m:1 Country_Code Time_Period using ./WorkingData/Cleaned/ewn_2021.dta, nogen keep(1 3)
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/credit_to_gdp_BIS.dta, nogen keep(1 3)
merge m:1 Time_Period using ./WorkingData/Cleaned/USvariable.dta, nogen keep(1 3)
merge m:1 Time_Period using ./WorkingData/Cleaned/US_NEER65.dta, nogen keep(1 3)
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/stock_oecd.dta, nogen keep(1 3)
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/houseprice_oecd.dta, nogen keep(1 3)
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/inflation_oecd.dta, nogen keep(1 3)
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/shortrate_oecd.dta, nogen keep(1 3)
merge m:1 Country_Code Time_Period using ./WorkingData/Cleaned/Effective_constructed.dta, nogen keep(1 3)
merge m:1 Country_Code Time_Period using ./WorkingData/Cleaned/usa_share.dta, nogen keep(1 3)
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/Effective_constructed_database.dta, nogen keep(1 3)
merge m:1 ISO_Code Time_Period using  ./WorkingData/gdf_interest_rate,nogen keep(1 3)
merge m:1 ISO_Code Time_Period using  ./WorkingData/GFD/stock_price_gfd,nogen keep(1 3)
merge m:1 Time_Period using ./WorkingData/Cleaned/FRB_NEER, keep(1 3) nogen 
merge m:1 Time_Period using ./WorkingData/Cleaned/GDPweighted_USD, keep(1 3) nogen 
merge m:1 ISO_Code Time_Period using  ./OriginalData/Bloomberg_interest_rate/cleaned/bloomberg_rate_all.dta,nogen keep(1 3)
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/commodity_data.dta, keep(1 3) nogen
merge m:1 Time_Period using ./WorkingData/Cleaned/commodity_price_index.dta, keep(1 3) nogen
merge m:1 Time_Period using ./WorkingData/Cleaned/bloomberg_commodity_price_index.dta, keep(1 3) nogen
merge m:1 Country_Code Time_Period using ./WorkingData/Cleaned/kaopen.dta, keep(1 3) nogen
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/peg_INR.dta, keep(1 3) nogen
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/peg_peg_USD_merge.dta, keep(1 3) nogen
merge m:1 Country_Code Time_Period using ./WorkingData/Cleaned/GDD.dta, keep(1 3) nogen
merge m:1 Time_Period using ./WorkingData/Cleaned/GFC_Rey.dta, keep(1 3) nogen
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/colonial_origin.dta, keep(1 3) nogen
merge m:1 ISO_Code Time_Period using ./WorkingData/Cleaned/MV_Credit, keep(1 3) nogen
merge m:1 Country_Code Time_Period using ./WorkingData/Cleaned/usd_exposure_lj, keep(1 3) nogen
merge m:1 Country_Code Time_Period using ./WorkingData/Cleaned/usd_exposure_bls, keep(1 3) nogen
save ./WorkingData/Cleaned/Dataset_add.dta,replace 


use ./WorkingData/Cleaned/Dataset_add.dta,clear 

*********************************
*
* Generating helper variables
*
*********************************



global log_var_list lnominal lreal lRGDP_WB lCPI lRGDP_percapita lexports_WB limports_WB unemp_ILO inflation_WB TBill_rate/*
*/  lexport_price_WB limport_price_WB lexport_price_IFS limport_price_IFS lTerms_of_trade_WB lTerms_of_trade_IFS lcons real_rate lstock lcredit l_imports_jn lf_imports_jn li_imports_jn ///
 lexports_WTO limports_WTO lexports_DOT limports_DOT lexports_IFS limports_IFS lservice_gdp lmanuf_gdp lservice_exp lservice_imp lagri_gdp lindustry_gdp limports_WB_share lexports_WB_share lending_rate lex_q ///
 limp_q lrgdpo lrgdpe lpl_x lpl_m lrconna lavh lemp lrnna llabsh lrwtfpna lxr lrtfpna lpl_c ///
 lpop lhc lcsh_x limports_unit_IFS lexports_unit_IFS limports_q_IFS lexports_q_IFS inflation_IFS ///
 real_rate_Tbill irr lrgdpna ltot_unit_IFS real_rate_lending lhours_pwt lcapital_pwt credit_to_gdp_BIS ///
 lexrate_to_USD UIP_deviation monetary_policy real_rate_mp nfagdp assets_gdp_ewn debts_gdp_ewn ///
 assets_to_debts stock_gdp market_cap_gdp nfa_to_gdp lmarket_cap domestic_credit lstock_oecd ///
 lhouseprice_oecd inflation_oecd shortrate_oecd nominal_interest_rate real_rate_ni nominal_interest_rate_gfd ///
 real_rate_gfd lstock_gfd ltourists_inflow ltourists_outflow lexport_price_WB_local limport_price_WB_local bloomberg_rate ///
 real_rate_bloomberg lreal_exrate_to_USD lmoney lreal_money ltot_pwt lcsh_i lcsh_c lcsh_r lcsh_g csh_m csh_x ///
 lcgdpo current_account_gdp net_export_gdp lGDPUS lnominal_gdp broad_money_gdp csh_i linvestment_WB ///
 csh_x_m tradebalance_gdp csh_g csh_c csh_r lcsh_m trade_balance_dot lexports_WB_cd limports_WB_cd ltot_WB_cd ///
 lconsumption_WB net_financial_acc_gdp capital_account_gdp net_trade_cd_gdp usa_export_share usa_import_share ///
 net_error_cd_gdp lctfp labsh ltrade_balance_DOT ltrade_balance_WTO tb_share lexport_bop_cd limport_bop_cd ///
 tradebalance_wto blm_Tbill_policy_money blm_Tbill_policy bloomberg_rate_all lRGDP_sum real_rate_all_bloomberg ///
 pvd_all pvd_ls hh_all hh_ls nfc_all nfc_ls lMV_Credit_Total
 global gdp_var_list curr_acc net_exports_WB reserve exports_WB imports_WB investment_WB ///
consumption_WB RGDP_WB government_expenditure manuf_gdp construction_gdp service_gdp agri_gdp ///
exports_WB_conLCU RGDP_sum 
 global gdp_cd_var_list exports_WB_cd imports_WB_cd net_exports_WB_cd
  global gdp_local_cd_var_list exports_local_cd imports_local_cd net_exports_local_cd MV_Credit_Total

 global gdp_pwt_var_list investment_pwt consumption_pwt
 global gdp_ewn_var_list nfa_ewn assets_ewn debts_ewn Capitalaccount 
global level_var_list curracc_gdp_ewn net_fdi_gdp portfolio_gdp fdi
* When a country switches to a different arrangement in the middle of the year, it will be listed
* as "pegged" to two different currencies. Admittedly, I do not understand the logic behind these
* particular screens.

/*
gen peg_check		= peg_GBP + peg_USD + peg_FRF + peg_DEM_EUR
replace peg_DEM		= 0 if peg_check > 1 & peg_check != . & peg_USD == 0
replace peg_USD		= 0 if peg_check > 1 & peg_check != .
replace peg_check	= 1 if peg_check > 1
*/
gen anchor_USD = peg_USD
*replace  anchor_USD = 1 if Time_Period >= 1980 & peg_INR == 1
drop peg_USD



tsset Country_Code Time_Period

gen net_exports_WB_cd = exports_WB_cd - imports_WB_cd
gen net_exports_local_cd = exports_local_cd - imports_local_cd

gen lexport_bop_cd = log(export_bop_cd)
gen limport_bop_cd = log(import_bop_cd)

gen lmarket_cap = log(market_cap)
gen lGDPUS = log(GDPUS)
gen lcgdpo = log(cgdpo)
gen lnominal_gdp = log(nominal_gdp)
replace broad_money_gdp = broad_money/nominal_gdp
gen lCPI = log(CPI)
gen lRGDP_WB = log(RGDP_WB)
gen lrgdpe = log(rgdpe)
gen lpl_x = log(pl_x)
gen lpl_m = log(pl_m)
gen ltot_pwt = log(pl_x/pl_m)
gen lrconna = log(rconna)
gen lavh = log(avh)
gen lemp = log(emp)
gen lrnna = log(rnna)
gen lrtfpna = log(rtfpna)
gen llabsh = log(labsh)
gen lrwtfpna = log(rwtfpna)
gen lrgdpo = log(rgdpo)
gen lxr = log(xr)
gen lpl_c = log(pl_c)
gen lcsh_r = log(csh_r)
gen lservice_gdp = log(service_gdp)
gen lpop = log(pop)
gen lhc = log(hc)
gen lcsh_x = log(csh_x*cgdpo)
gen lcsh_i = log(csh_i*cgdpo)
gen lcsh_c = log(csh_c*cgdpo)
gen lcsh_m = log(-csh_m*cgdpo)
gen lcsh_g = log(csh_g*cgdpo)
gen csh_x_m = csh_x + csh_m
gen investment_pwt = F.rnn - (1-delta)*rnna
gen lrgdpna = log(rgdpna)
gen lctfp = log(ctfp)
gen lMV_Credit_Total = log(MV_Credit_Total)
replace MV_Credit_Total = MV_Credit_Total*1000000

gen lhours_pwt = log(avh*emp)
gen lcapital_pwt = log(rnna)
gen trade_balance_dot =  (exports_DOT -  imports_DOT)/nominal_gdp
gen lexports_WB_cd = log(exports_WB_cd)
gen limports_WB_cd = log(imports_WB_cd)
gen ltot_WB_cd = log(exports_WB_cd/imports_WB_cd)
gen net_financial_acc_gdp  = net_financial_acc/nominal_gdp
gen capital_account_gdp  = capital_account/nominal_gdp
gen net_trade_cd_gdp = net_trade_cd/nominal_gdp
gen net_error_cd_gdp = net_error_cd/nominal_gdp
gen lmoney = log(broad_money)
gen lreal_money = log(broad_money/CPI)

gen lhouseprice_oecd = log(houseprice_oecd)

gen nfagdp = netIIPexclgoldGDPdomestic 
gen curracc_gdp_ewn = Currentaccountbalance/GDPUS 
gen capitalacc_gdp_ewn = Capitalaccount/GDPUS
gen assets_gdp_ewn = Totalassetsexclgold/GDPUS 
gen debts_gdp_ewn = Totalliabilities/GDPUS
gen assets_to_debts = log(Totalassetsexclgold/Totalliabilities)

gen consumption_pwt = rconna
gen consumption_WB = RealC
gen investment_WB = investment
gen linvestment_WB = log(investment_WB)
gen lconsumption_WB = log(consumption_WB)

gen limports_unit_IFS = log(imports_unit_value_IFS)
gen lexports_unit_IFS = log(exports_unit_value_IFS)
gen ltot_unit_IFS = log(exports_unit_value_IFS) - log(imports_unit_value_IFS)
gen limports_q_IFS = log(imports_quantity_IFS)
gen lexports_q_IFS = log(exports_quantity_IFS)

gen ltourists_inflow = log(tourists_inflow)
gen ltourists_outflow = log(tourists_outflow)

*replace lservice_gdp = log(service_share*RGDP_WB) if lservice_gdp == .
*gen lservice_gdp = log(service_share*RGDP_WB) 

gen lmanuf_gdp = log(manuf_gdp)
*replace lmanuf_gdp = log(manuf_share*RGDP_WB) if lmanuf_gdp == .
*gen lmanuf_gdp = log(manuf_share*RGDP_WB) 

gen lreal_exrate_to_USD = log(Exrate_per_USD*CPI_US/CPI)
gen lagri_gdp = log(agri_gdp)
*gen lagri_gdp = log(agri_share*RGDP_WB) 

gen lindustry_gdp = log(industry_gdp) - log(manuf_gdp)
gen construction_gdp  = industry_gdp - manuf_gdp

gen lservice_exp = log(service_export)
gen lservice_imp = log(service_import)


gen lRGDP_percapita = log(GDP_per_capita)
gen lcons		= log(RealC)
gen curr_acc = current_account
gen tradebalance_gdp = exports_share_WB - imports_share_WB
*gen curr_acc = current_account/nominal_gdp

gen fdi = net_fdi/nominal_gdp
gen portfolio_gdp = portfolio_inv/nominal_gdp


* WB = World Bank
gen lexports_WB = log(exports_WB)
gen temp_exports = log(exports_WB)
gen lex_q = log(export_quantity)
gen limp_q = log(import_quantity)

gen lexports_WB_share = log(exports_share_WB)
gen limports_WB_share = log(imports_share_WB)




*replace exports = log(exports_share_WB*RGDP_WB) if exports==.
gen lexports_WTO = log(exports_WTO) 
gen ltrade_balance_WTO = log(exports_WTO/imports_WTO) 
gen limports_WB			= log(imports_WB)

gen tradebalance_wto = (exports_WTO - imports_WTO)/nominal_gdp
*replace imports = log(imports_share_WB*RGDP_WB) if imports==.

gen limports_WTO = log(imports_WTO) 
gen tb_share = (exports_WTO - imports_WTO)/nominal_gdp

gen lexports_DOT = log(exports_DOT) 
gen limports_DOT = log(imports_DOT) 
gen ltrade_balance_DOT = log(exports_DOT/imports_DOT) 

gen lexports_IFS = log(Exports_nominal_USD) 
gen limports_IFS = log(Imports_nominal_USD) 

gen l_imports_jn			= log(imports_jn)
gen lf_imports_jn			= log(final_imports_jn)
gen li_imports_jn			= log(intermed_imports_jn)

*gen imports	= log(imports_WTO)
gen net_exports_WB		= ( exports_WB -imports_WB)
gen lexport_price_WB	= log(exports_price_WB)
gen limport_price_WB	= log(imports_price_WB)
gen lexport_price_WB_local    = log(exports_price_WB*Exrate_per_USD)
gen limport_price_WB_local    = log(imports_price_WB*Exrate_per_USD)
gen lexport_price_IFS	= log(Export_price)
gen limport_price_IFS	= log(Import_price)
gen lTerms_of_trade_WB	= log(exports_price_WB/imports_price_WB)
*gen lTerms_of_trade_WB = lexport_price_WB - limport_price_WB
gen lTerms_of_trade_IFS	= log(Import_price/Export_price)


gen RGDP_sum = consumption_WB + investment_WB + net_exports_WB + government_expenditure
gen lRGDP_sum = log(RGDP_sum)
gen inflation_WB = inflation_CPI/100
gen inflation_IFS = D.lCPI
replace TBill_rate = TBill_rate/100
replace lending_rate = lending_rate/100
replace TBill_rate_US = TBill_rate_US/100
replace monetary_policy = monetary_policy/100
replace Tbill_gfd = Tbill_gfd/100 
replace interbank_gfd = interbank_gfd/100 


gen nominal_interest_rate = TBill_rate

*by Country_Code: egen country_missing_Tbill = mean(TBill_rate)
*replace nominal_interest_rate = monetary_policy if country_missing_Tbill == .

replace nominal_interest_rate = shortrate_oecd if nominal_interest_rate == .
replace nominal_interest_rate = Tbill_gfd if nominal_interest_rate == .
replace nominal_interest_rate = monetary_policy if nominal_interest_rate == .
replace nominal_interest_rate = interbank_gfd if nominal_interest_rate == .


gen nominal_interest_rate_gfd = Tbill_gfd
replace nominal_interest_rate_gfd = TBill_rate if nominal_interest_rate_gfd == .
replace nominal_interest_rate_gfd = shortrate_oecd if nominal_interest_rate_gfd == .
*replace nominal_interest_rate_gfd = monetary_policy if nominal_interest_rate_gfd==.
*replace nominal_interest_rate_gfd = interbank_gfd if nominal_interest_rate_gfd==.




gen lexrate_to_USD = log(Exrate_per_USD)
gen UIP_deviation = (L.bloomberg_rate_all - L.TBill_rate_US) - log(Exrate_per_USD) + log(L.Exrate_per_USD)

replace real_rate = real_rate/100
*replace real_rate = (TBill_rate - inflation)
gen real_rate_Tbill = (TBill_rate - inflation_WB)
gen real_rate_mp = (monetary_policy - inflation_WB)

gen real_rate_ni = nominal_interest_rate - inflation_WB
gen real_rate_gfd = nominal_interest_rate_gfd - inflation_WB
gen real_rate_bloomberg = bloomberg_rate - F1.inflation_WB
gen real_rate_all_bloomberg = bloomberg_rate_all - F1.inflation_WB

gen real_rate_lending = (lending_rate - inflation_WB)

gen lcredit = log(credit*RGDP_WB/100)
*gen lstock = log(stock_per_GDP*RGDP_WB/100)
gen lstock = log(market_cap*RGDP_WB/nominal_gdp)
gen lstock_oecd = log(stock_oecd*RGDP_WB/nominal_gdp)
replace lstock_oecd = lstock if lstock_oecd == .
replace lstock = lstock_oecd if lstock == .

*replace stock_price_gfd = stock_price_gfd/Exrate_per_USD if currency_stock_gfd != "United States Dollar"
gen lstock_gfd = log(stock_price_gfd )

* Defining some transformations
gen dlog_RGDP = D.lRGDP_WB
gen L_dlog_RGDP = L1.dlog_RGDP
gen L_inflation = L1.inflation_IFS
gen d_TBill = D.TBill_rate

* Exchange rate Regime
* Note: This will produce some observations where peg_check = 1 but peg = 0. This is for
* some regimes that are associated with some other currency, but that we are not classifying
* as "pegged". Some de facto crawling bands, for instance.
gen peg = inrange(Exrate_Regime,1,8)
*gen peg = inrange(Exrate_Regime,1,12)

*Define Exrate per Euro/DEU
gen Exrate_per_DEU = Exrate_per_USD/DEU_per_USD
gen DEU_per_local = 1/Exrate_per_DEU
gen USA_per_local = 1/Exrate_per_USD
gen log_DEU_per_local = log(DEU_per_local)
gen log_USA_per_local = log(1/Exrate_per_USD)

rename Exrate_per_USD Exrate_per_USA
gen log_Exrate_per_USA = log(Exrate_per_USA)
gen log_Exrate_per_DEU = log(Exrate_per_DEU)

gen log_USA_BIS_Nominal = log(USA_BIS_Nominal)
gen log_DEU_BIS_Nominal = log(DEU_BIS_Nominal)


gen nfa_ewn = NetIIPexclgold
gen assets_ewn = Totalassetsexclgold
gen debts_ewn = Totalliabilities



* define region code



*********************************
*
* Figure for exchange rate
*
*********************************
if $descriptive == 1{
	do ./Stata/Descriptive_Figure.do
}

*********************************
*
* Comparison between BIS and IFS
*
*********************************

/* do ./Stata/BIS_IFS_check.do */


*****************************
*
* Define peg and replace to BIS
*
*****************************
* This will make a jump at yaer 1964, but we will focus on post 1973, so will be fine
*replace Real_Effective = BIS_Real_Effective if BIS_Real_Effective !=.
*replace Nominal_Effective = BIS_Nominal_Effective if BIS_Real_Effective !=.
foreach c in  "USA"  "GBR" "FRA" "DEU"{
	gen dlog_`c'_Nominal_Rate = dlog_`c'_BIS_Nominal
	gen dlog_`c'_Real_Rate = dlog_`c'_BIS_Real
}

sort Country_Code Time_Period
gen lreal				= log(REER_65)
*gen lreal = log(Real_Effective)
*replace lreal = log(c_effective_real_exrate) if lreal == .
gen dlog_Real			= D.lreal
gen lnominal			= log(NEER_65)
gen dlog_Nominal		= D.lnominal
gen L_dlog_Nominal		= L.dlog_Nominal
gen dlog_Exrate_per_USA = D.log_Exrate_per_USA
gen dlog_Exrate_per_DEU = D.log_Exrate_per_DEU

replace inflation_CPI	= inflation_CPI/100
replace unemp_ILO		= unemp_national if unemp_ILO==.
replace unemp_ILO		= unemp_ILO/100

* Generate differences across wider timeframe. Note the indexing: The observation in time t for dlog2 is the difference between
* the observations 2 periods from now and t-1. These are our LHS variables for the local projections.
foreach var in $log_var_list {
	forval t = 0/15{
		qui gen dlog`t'_`var' = F`t'.`var' - L.`var'
	}
	forval t=1/9{
		qui gen dlogm`t'_`var' = L`t'.`var' - L.`var'
	}
}

foreach var in $gdp_var_list {
	forval t = 0/15{
		qui gen dlog`t'_`var' = ( F`t'.`var' - L.`var' )/L.RGDP_WB
	}
	forval t=1/9{
		qui gen dlogm`t'_`var' = ( L`t'.`var' - L.`var' )/L.RGDP_WB
	}
}


foreach var in $gdp_pwt_var_list {
	forval t = 0/15{
		qui gen dlog`t'_`var' = ( F`t'.`var' - L.`var' )/L.rgdpna
	}
	forval t=1/9{
		qui gen dlogm`t'_`var' = ( L`t'.`var' - L.`var' )/L.rgdpna
	}
}


foreach var in $gdp_ewn_var_list {
	forval t = 0/15{
		gen dlog`t'_`var' = ( F`t'.`var' - L.`var' )/L.GDPUS
	}
	forval t=1/9{
		gen dlogm`t'_`var' = ( L`t'.`var' - L.`var' )/L.GDPUS
	}
}


foreach var in $gdp_cd_var_list {
    forval t = 0/15{
        gen dlog`t'_`var' = ( F`t'.`var' - L.`var' )/L.nominal_gdp
    }
    forval t=1/9{
        gen dlogm`t'_`var' = ( L`t'.`var' - L.`var' )/L.nominal_gdp
    }
}

foreach var in $gdp_local_cd_var_list {
    forval t = 0/15{
        gen dlog`t'_`var' = ( F`t'.`var' - L.`var' )/L.gdp_local_cd
    }
    forval t=1/9{
        gen dlogm`t'_`var' = ( L`t'.`var' - L.`var' )/L.gdp_local_cd
    }
}

foreach var in $level_var_list {
    forval t = 0/15{
        gen dlog`t'_`var' = ( F`t'.`var' - L.`var' )
    }
    forval t=1/9{
        gen dlogm`t'_`var' = ( L`t'.`var' - L.`var' )
    }
}

*********************************
*
* Case Study
*
*********************************

* do ./Stata/CaseStudy.do

*****************************
*
* Sample selection
*
*****************************

*Produce dta file with one row per year, and columns corresponding to log difference in RGDP
* for each base country
preserve
keep if ISO_Code == "USA" | ISO_Code == "GBR"| ISO_Code == "FRA"| ISO_Code == "DEU"
keep ISO_Code Country_Code Time_Period lRGDP_WB
replace ISO_Code = "_base_" + ISO_Code

* Potentially confusing: lRGDP_WB is actually the log difference in RGDP
gen lRGDPd = D.lRGDP_WB
drop lRGDP_WB
rename lRGDPd lRGDP

drop Country_Code
reshape wide lRGDP,i(Time_Period) j(ISO_Code) string
save ./WorkingData/Cleaned/tempbase,replace
restore

* Merge in log difference in RGDP for each base country -- so now have those on each row
merge m:1 Time_Period using ./WorkingData/Cleaned/tempbase, nogen
sort Country_Code Time_Period

* Interaction of log difference in RGDP of each base and indicator for whether
* you are PEGGED to that base
replace lRGDP_base_USA = lRGDP_base_USA*anchor_USD
/*
replace lRGDP_base_GBR = lRGDP_base_GBR*peg_GBP
replace lRGDP_base_DEU = lRGDP_base_DEU*peg_EUR
replace lRGDP_base_FRA = lRGDP_base_FRA*peg_FRF
*/
* Drop base countries
*drop if ISO_Code == "USA" | ISO_Code == "GBR"| ISO_Code == "FRA"| ISO_Code == "DEU"

rename region region_name
gen region = .
replace region = 1 if region_name == "Africa"
replace region = 2 if region_name == "Americas"
replace region = 3 if region_name == "Asia"
replace region = 4 if region_name == "Europe"
replace region = 5 if region_name == "Oceania"

labmask region, values(region_name)

* Change Oceania to Asia
replace region = 3 if region == 5




***********************************
*
* Create peg
*
***********************************

* Change the peg_[base] variables to what we really want (i.e. only if it's a PEGGED regime)
gen peg_USD = anchor_USD*peg
/*
replace peg_GBP = peg_GBP*peg
replace peg_FRF = peg_FRF*peg
replace peg_DEM_EUR = peg_DEM_EUR*peg


foreach v of varlist peg_GBP  peg_USD peg_FRF peg_DEM_EUR{
	replace `v' = . if Time_Period <= 1972
	*replace `v' = 0 if Time_Period == 1972
}
gen peg_to_any4currency = peg_GBP + peg_USD + peg_FRF + peg_DEM_EUR
*/

gen dlog_USGDP = log(US_RGDP_WB) - log(L.US_RGDP_WB)
gen dlog_USTBill = (TBill_rate_US) - (L.TBill_rate_US)
gen dlog_USinflation = (inflation_CPI_US) - (L.inflation_CPI_US)

*gen dlog_USA_Nominal_Rate_alt = log(NEER_65_US) - log(L.NEER_65_US)

* Nominal rate
gen peg_dlogUS = peg_USD* dlog_USA_Nominal_Rate  
label var peg_dlogUS "peg X dlog(N.USD)"
gen peg_dlogUS_alt = peg_USD*dl_GDPw_USD
label var peg_dlogUS_alt "peg X dlog(N.USD) Alternative"

gen peg_dlogUS_GDP =  peg_USD* dlog_USGDP  
gen peg_dlogUS_TBill =  peg_USD* dlog_USTBill  
gen peg_dlogUS_inflation =  peg_USD* dlog_USinflation  

gen peg_dlogGFC =  peg_USD* d_GFC




gen peg_dlogGBR = peg_GBP*dlog_GBR_Nominal_Rate
label var peg_dlogGBR "peg X dlog(N.GBR)"
gen peg_dlogFRA = peg_FRF*dlog_FRA_Nominal_Rate
label var peg_dlogFRA "peg X dlog(N.FRA)"
gen peg_dlogEU = peg_DEM_EUR*dlog_DEU_Nominal_Rate
label var peg_dlogEU "peg X dlog(N.EU)"


gen dlog_Commodity = log(bloomberg_Commodity_Price) - log(L.bloomberg_Commodity_Price)
gen peg_dlog_Commodity = peg_USD*dlog_Commodity
label var peg_dlog_Commodity "peg X dlog(Commmodity Price)"


* I(Peg Regime) x ΔLog(e(Base, t)) -- where Base is whatever my peg's base is
gen peg_dlogAll = peg_dlogUS + peg_dlogGBR + peg_dlogFRA + peg_dlogEU
label var peg_dlogAll "peg X dlog(N.All)"

* Real rate
gen peg_R_dlogUS = peg_USD*dlog_USA_Real_Rate
label var peg_R_dlogUS "peg X dlog(R.USD)"
gen peg_R_dlogGBR = peg_GBP*dlog_GBR_Real_Rate
label var peg_R_dlogGBR "peg X dlog(R.GBR)"
gen peg_R_dlogFRA = peg_FRF*dlog_FRA_Real_Rate
label var peg_R_dlogFRA "peg X dlog(R.FRA)"
gen peg_R_dlogEU = peg_DEM_EUR*dlog_DEU_Real_Rate
label var peg_R_dlogEU "peg X dlog(R.EU)"

label var dlog_Nominal "dlog.N.Ex.Rate"
label var dlog_Real "dlog.R.Ex.Rate"

label var dlog_Exrate_per_USA "dlog_perUSA_N"
label var dlog_Exrate_per_DEU "dlog_perDEU_N"
# delimit ;
label define ex_rate_lbl 1 "No separate legal tender or currency union"
2 "Pre announced peg or currency board arrangement"
3 "Pre announced horizontal band that is narrower than or equal to +/-2%"
4 "De facto peg"
5 "Pre announced crawling peg; de facto moving band narrower than or equal to
+/-1%"
6 "Pre announced crawling band that is narrower than or equal to +/-2%
or de facto horizontal band that is narrower than or equal to +/-2%"
7" De facto crawling peg"
8 "De facto crawling band that is narrower than or equal to +/-2%"
9 "Pre announced crawling band that is wider than or equal to +/-2%"
10 "De facto crawling band that is narrower than or equal to +/-5%"
11 "Moving band that is narrower than or equal to +/-2% (i.e., allows for both appreciation and
depreciation over time)"
12 "De facto moving band +/-5%/ Managed floating"
13 "Freely floating"
14 "Freely falling"
15 "Dual market in which parallel market data is missing.", replace ;
# delimit cr
label values Exrate_Regime ex_rate_lbl

label var inflation_WB "Inflation"
label var lnominal "Nominal Effective Exchange Rate"
label var lreal "Real Effective Exchange Rate"
label var lRGDP_WB "GDP"
label var RGDP_WB "GDP"
label var lexports_WB "Exports"
label var limports_WB "Imports"
label var exports_WB "Exports"
label var imports_WB "Imports"
label var lexports_WB_share "Exports (WB, share based)"
label var limports_WB_share  "Imports (WB, share based)"
label var lexport_price_WB "Exports Unit Value (in USD)"
label var limport_price_WB "Imports Unit Value (in USD)"
label var lexport_price_IFS "Commodity Exports Price (IFS)"
label var limport_price_IFS "Commodity Imports Price (IFS)"
label var TBill_rate "T-Bill rate"
label var lending_rate "Lending rate"
label var lex_q "Export quantity"
label var limp_q "Import quantity"
label var MV_Credit_Total "Total Credit (normalized by initial GDP)"
label var lMV_Credit_Total "Log Total Credit"


label var lTerms_of_trade_WB "Terms of Trade"
label var lTerms_of_trade_IFS "Commodity Terms of Trade (IFS)"
label var lCPI "CPI"
label var consumption_WB "Consumption"
label var net_exports_WB "Net Exports"
label var net_exports_WB_cd "Net Exports (current USD)"
label var curr_acc "Current Account (% of initial GDP)"
label var investment_WB "Investment"
label var lstock "Stock Price"
label var lcredit "Private Credit"
label var l_imports_jn "Imports (JN)"
label var lf_imports_jn "Final Imports (JN)"
label var li_imports_jn "Intermediate Imports (JN)"
label var lexports_WTO "Exports (WTO)"
label var limports_WTO "Imports (WTO)"
label var lexports_DOT "Exports (IMF DOT)"
label var limports_DOT "Imports (IMF DOT)"

label var lexports_IFS "Exports (IMF IFS)"
label var limports_IFS "Imports (IMF IFS)"
label var lagri_gdp "Agri. GDP"
label var real_rate "Real Interest Rate"
label var lservice_gdp "Service GDP"
label var lmanuf_gdp "Manuf. GDP"
label var lservice_exp "Service Export"
label var lservice_imp "Service Import"
label var lindustry_gdp "Industry GDP"
label var nfagdp "NFA/GDP"
label var fdi "FDI Inflow / GDP"
label var portfolio_gdp "Portfolio Inflow / GDP"
label var lrgdpo "Real GDP (PWT)"
label var consumption_pwt "Consumption"
label var investment_pwt "Investment"
label var lexports_unit_IFS "Export Unit Value"
label var limports_unit_IFS "Import Unit Value"
label var ltot_unit_IFS "Terms of Trade"
label var real_rate_lending "Real Interest Rate (Lending)"
label var lhours_pwt "Hours"
label var lcapital_pwt "Capital Stock"
label var lrtfpna "TFP"
label var monetary_policy "Policy Rate"
label var real_rate_mp "Real Interest Rate (Policy)"

label var lexrate_to_USD "Nominal Exchange Rate to USD"
label var UIP_deviation "Ex-Post UIP Deviation"
label var real_rate_Tbill "Real Interest Rate (T-Bill)"
label var real_rate_ni "Real Interest Rate  (T-Bill + Policy)"
label var nominal_interest_rate "Nominal Interest Rate (T-Bill + Policy)"

label var curracc_gdp_ewn "Current Account to GDP"
label var assets_gdp_ewn "Asset to GDP"
label var debts_gdp_ewn "Debt to GDP"
label var assets_to_debts "Asset to Debt"
label var stock_gdp "Stock Value to GDP"
label var market_cap_gdp "Market Capitalization to GDP"

label var nfa_ewn "NFA (% of inital GDP)"
label var assets_ewn "Assets (% of inital GDP)"
label var debts_ewn "Debts (% of inital GDP)"
label var government_expenditure "Government Expenditure"
label var nfa_to_gdp "NFA to GDP"
label var domestic_credit "Domestic Credit"
label var lstock_oecd "Stock Price"
label var lhouseprice_oecd "House Price (OECD)"
label var manuf_gdp "Manufacturing GDP"
label var service_gdp "Service GDP"
label var construction_gdp "Mining, Construction, Energy GDP"
label var agri_gdp "Agriculture GDP"
label var tradebalance_gdp "Trade Balance to GDP"
label var imports_share_WB "Import to GDP"
label var exports_share_WB "Export to GDP"
label var bloomberg_rate "Nominal Interest Rate"
label var real_rate_bloomberg "Real Interest Rate"
label var real_rate_all_bloomberg "Real Interest Rate"
label var lreal_exrate_to_USD "Real Exchange Rate to USD"
label var ltourists_inflow "Tourist Inflows"
label var ltourists_outflow "Tourist Outflows"
label var net_fdi_gdp "Net FDI Inflow / GDP"

label var bloomberg_rate_all "Nominal Interest Rate"

/*
gen peg_change =  ( peg_cont < 1 & peg_cont > 0 ) & (peg_USD == 1 | L.peg_USD == 1)
replace peg_change = 1 if peg_cont != L.peg_cont & (peg_cont == 1 | peg_cont == 0) & (L.peg_cont == 1 | L.peg_cont == 0) & (peg_USD == 1 | L.peg_USD == 1)
gen peg_change_oneyear = (L.peg_change == 1)
*/

gen peg_change = peg_USD != L.peg_USD


save ./WorkingData/Cleaned/Dataset_regresson_includingUS.dta,replace

drop if ISO_Code == "USA"

save ./WorkingData/Cleaned/Dataset_regresson.dta,replace
