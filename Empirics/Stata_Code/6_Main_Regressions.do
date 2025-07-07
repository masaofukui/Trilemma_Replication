cd "/Users/fukui/Dropbox (Personal)/Trilemma/Trilemma_Replication/Empirics"
clear
clear matrix
clear mata
set maxvar 30000
*capture log close
*log using mylog.log, replace
global fig_slide_folder "./Figures"
global fig_slide_folder "./Figures"
global fig_folder "./Figures"
***************************************************************************
*
* Baseline local projections 
*
***************************************************************************
global n_pre = -3
global n_post = 9
global robust = 0
global fig_save = 1
global recreate_local_projection = 0
global write_table = 1

*global max_spec = 11
global spec_list "1"
global weight noweight
global peg "USD"
* 1-2 is trade openess
*3-4 is capital account openess
global by_openess = 0
* by sample period
*1-2: 1 is the first half. 2 is the second half.
*3-4: 3 is USD deprecaition. 4 is USD appreciation.
global by_period = 0
global report_r2 = 0
global ncol = 2

global min_fig_list = 21
global max_fig_list = 21
do "./Stata_Code/subfile/sub_main_regression_loop.do"

copy "$fig_slide_folder/slide_1_USD_lnominal lreal RGDP_WB consumption_WB_nrow2_noncommony.pdf" "$fig_folder/Figure_3.pdf",replace
copy "$fig_slide_folder/slide_1_USD_investment_WB net_exports_WB exports_WB imports_WB_nrow2.pdf" "$fig_folder/Figure_4.pdf",replace	
copy "$fig_slide_folder/slide_1_USD_bloomberg_rate_all lCPI lTerms_of_trade_WB_nrow1_noncommony.pdf" "$fig_folder/Figure_5.pdf",replace	
copy "$fig_slide_folder/slide_1_USD_UIP_deviation_alone.pdf" "$fig_folder/Figure_6.pdf",replace
copy "$fig_slide_folder/slide_1_USD_manuf_gdp service_gdp agri_gdp construction_gdp_nrow2.pdf" "$fig_folder/Figure_7.pdf",replace
copy "$fig_slide_folder/slide_1_USD_lnominal lreal lexrate_to_USD_nrow2.pdf" "$fig_folder/Figure_A5.pdf",replace
copy "$fig_slide_folder/slide_1_USD_lexport_price_WB limport_price_WB_nrow1.pdf" "$fig_folder/Figure_A6.pdf",replace
copy "$fig_slide_folder/slide_1_USD_bloomberg_rate_all lCPI real_rate_all_bloomberg_nrow2_noncommony.pdf" "$fig_folder/Figure_A7.pdf",replace
copy "$fig_slide_folder/slide_1_USD_ltourists_inflow ltourists_outflow_nrow1.pdf" "$fig_folder/Figure_A23.pdf",replace
copy "$fig_slide_folder/slide_1_USD_government_expenditure_alone.pdf" "$fig_folder/Figure_A24.pdf",replace


/***************** by openess ******************* */

forval i = 1/4{
	global by_openess = `i'
	global min_fig_list = 2
	global max_fig_list = 2
	do "./Stata_Code/subfile/sub_main_regression_loop.do"
}


global by_openess = 0
forval i = 1/2{
	global by_period = `i'
	global min_fig_list = 2
	global max_fig_list = 2
	do "./Stata_Code/subfile/sub_main_regression_loop.do"
}

do "./Stata_Code/subfile/sub_heterogenous_response.do"
copy "$fig_slide_folder/slide_1_by_kaopeness.pdf" "$fig_folder/Figure_8.pdf",replace
copy "$fig_slide_folder/slide_1_by_openess.pdf" "$fig_folder/Figure_A8.pdf",replace
copy "$fig_slide_folder/slide_1_by_period.pdf" "$fig_folder/Figure_A9.pdf",replace


/***************** Robustness ******************* */

global by_period = 0
global by_openess = 0
global min_fig_list = 1
global max_fig_list = 1
global robust = 1
global spec_list "1 9 20 22 3 2 8 7 14 13 19 21 24 15"
do "./Stata_Code/subfile/sub_main_regression_loop.do"

copy "$fig_slide_folder/robust_by_9.pdf" "$fig_folder/Figure_A10.pdf",replace
copy "$fig_slide_folder/robust_by_20.pdf" "$fig_folder/Figure_A11.pdf",replace
copy "$fig_slide_folder/robust_by_22.pdf" "$fig_folder/Figure_A12.pdf",replace
copy "$fig_slide_folder/robust_by_3.pdf" "$fig_folder/Figure_A13.pdf",replace
copy "$fig_slide_folder/robust_by_2.pdf" "$fig_folder/Figure_A14.pdf",replace
copy "$fig_slide_folder/robust_by_8.pdf" "$fig_folder/Figure_A15.pdf",replace
copy "$fig_slide_folder/robust_by_7.pdf" "$fig_folder/Figure_A16.pdf",replace
copy "$fig_slide_folder/robust_by_14.pdf" "$fig_folder/Figure_A17.pdf",replace
copy "$fig_slide_folder/robust_by_13.pdf" "$fig_folder/Figure_A18.pdf",replace
copy "$fig_slide_folder/robust_by_19.pdf" "$fig_folder/Figure_A19.pdf",replace
copy "$fig_slide_folder/robust_by_21.pdf" "$fig_folder/Figure_A20.pdf",replace
copy "$fig_slide_folder/robust_by_24.pdf" "$fig_folder/Figure_A21.pdf",replace
copy "$fig_slide_folder/robust_by_15.pdf" "$fig_folder/Figure_A22.pdf",replace

/***************** R2 ******************* */
global robust = 0 
global min_fig_list = 1
global max_fig_list = 1
global report_r2 = 1
global spec_list "1"
global weight noweight
global peg "USD"
global n_pre = -3
global n_post = 9
do "./Stata_Code/subfile/sub_main_regression_loop.do"
do "./Stata_Code/subfile/sub_write_R2_table.do"
