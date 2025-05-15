
forval fig_list = $min_fig_list/$max_fig_list {
	global fig_list `fig_list'
	if $fig_list == 1{
		global lhs_list lnominal lreal lexrate_to_USD 
		global nrow  = 2
	}
	else if $fig_list == 2{
		global lhs_list lnominal lreal RGDP_WB consumption_WB
		global nrow  = 2
	}
	else if $fig_list == 3{
		global lhs_list investment_WB net_exports_WB exports_WB imports_WB
		global nrow  = 2
	}
	else if $fig_list == 4{
		global lhs_list lexport_price_WB limport_price_WB
		global nrow  = 1
	}
	else if $fig_list == 5{
		*global lhs_list bloomberg_rate_all lCPI real_rate_all_bloomberg lTerms_of_trade_WB
		global lhs_list bloomberg_rate_all lCPI lTerms_of_trade_WB

		*lreal_exrate_to_USD
		*global lhs_list nominal_interest_rate real_rate_ni inflation_WB lstock

		global nrow  = 1
		global ncol = 3
	}
	else if $fig_list == 6{
		global lhs_list manuf_gdp service_gdp agri_gdp construction_gdp
		global nrow = 2
	}
	else if $fig_list == 7{
		global lhs_list lexport_price_WB_local limport_price_WB_local
		global nrow = 2
	}
	else if $fig_list == 8{
		global lhs_list bloomberg_rate
		global nrow = 1
	}
	else if $fig_list == 9{
		global lhs_list lTerms_of_trade_WB
		global nrow = 1
	}
	else if $fig_list == 10{
		global lhs_list  investment_WB net_exports_WB bloomberg_rate_all lCPI
		global nrow = 2
	}
	else if $fig_list == 11{
		global lhs_list  bloomberg_rate_all lCPI real_rate_all_bloomberg
		global nrow = 2
	}
	else if $fig_list == 12{
		global lhs_list lrgdpo
		global nrow = 1
	}
	else if $fig_list == 13{ 
		global lhs_list government_expenditure 
		global nrow = 1
	}
	else if $fig_list == 14{ 
		global lhs_list ltourists_inflow ltourists_outflow 
		global nrow = 1
	}
	else if $fig_list == 15{ 
		global lhs_list net_exports_WB bloomberg_rate_all
		global nrow = 1
	}
	else if $fig_list == 16{
		global lhs_list pvd_ls pvd_all hh_ls hh_all nfc_ls nfc_all
		global nrow = 2
	}
	else if $fig_list == 17{
		global lhs_list UIP_deviation
		global nrow = 1
	}
	else if $fig_list == 18{
		global lhs_list real_rate_all_bloomberg
		global nrow = 1
	}
	else if $fig_list == 19{
		global lhs_list MV_Credit_Total lMV_Credit_Total
		global nrow = 1
	}
	else if  $fig_list == 20{
		global lhs_list curracc_gdp_ewn portfolio_gdp net_fdi_gdp
		global nrow = 2
	}



	if $robust ==1 {
		global lhs_list ///
		lnominal lreal RGDP_WB consumption_WB investment_WB exports_WB imports_WB net_exports_WB ///
		lTerms_of_trade_WB bloomberg_rate lCPI

		global lhs_list ///
		lnominal lreal  RGDP_WB consumption_WB investment_WB net_exports_WB ///
		 bloomberg_rate_all lCPI lTerms_of_trade_WB
		 *lCPI lTerms_of_trade_WB
		*global lhs_list bloomberg_rate_all
		global nrow = 3
	}
	else if $robust ==2 {
		global lhs_list ///
		lnominal lreal RGDP_WB consumption_WB investment_WB exports_WB imports_WB net_exports_WB ///
		lTerms_of_trade_WB bloomberg_rate lCPI

		global lhs_list ///
		lnominal lreal  RGDP_WB consumption_WB investment_WB net_exports_WB ///
		 bloomberg_rate_all lCPI lTerms_of_trade_WB inflation_WB real_rate_all_bloomberg
		 *lCPI lTerms_of_trade_WB
		*global lhs_list bloomberg_rate_all
		global nrow = 4
	}
	else if $robust == 3{
		global lhs_list ///
		lnominal lreal  RGDP_WB consumption_WB investment_WB exports_WB imports_WB net_exports_WB
		 *lCPI lTerms_of_trade_WB
		*global lhs_list bloomberg_rate_all
		global nrow = 3
	} 

	foreach spec in $spec_list {
		clear all
		use ./WorkingData/Cleaned/Dataset_regresson.dta,clear
		global fig_title "Baseline. Region X Time & Country FE (ii) Controls: Lagged GDP Growth & Outcome, Pegged Dummy"

		if `spec' == 13{
			global fig_title "Change from Baseline: Classify 3 as Pegs."
			replace peg_USD = 1 if anchor_USD == 1 & inrange(Exrate_Regime,9,12) 
			replace peg_dlogUS = peg_USD*dlog_USA_Nominal_Rate
			replace peg_change = peg_USD != L.peg_USD
		}
		if `spec' == 19{
			global fig_title "Change from Baseline: GDP weighted U.S. Dollar Exchange Rate"
			replace peg_dlogUS = peg_dlogUS_alt
		}
		
		if `spec' != 14 & `spec' != 13 {
			*replace peg_dlogUS = . if peg_USD == 0 & inrange(Exrate_Regime,9,12) 
			replace peg_dlogUS = . if anchor_USD == 1 & inrange(Exrate_Regime,9,12) 
		}
		if `spec' == 14{
			global fig_title "Change from Baseline: Classify 3 as Floats."
		}


		gen lag1_peg_dlogUS = L.peg_dlogUS
		gen lag1_peg_USD = L.peg_USD
		gen lag2_peg_dlogUS = L2.peg_dlogUS
		gen lag2_peg_USD = L2.peg_USD


		*keep if exports_share_WB + imports_share_WB < 60
		global recreate_local_projection = 0
		drop if Exrate_Regime == 14 | Exrate_Regime == 15
		*replace peg_dlogUS = . if Exrate_Regime == 14 | Exrate_Regime == 15

		replace peg_dlogUS = . if RGDP_WB == .

		if `spec' != 21{
			drop if inlist(ISO_Code,"JPN","BEL","AUS","AUT","CAN","DNK","FIN","FRA")
			drop if inlist(ISO_Code,"DEU","GRC","HKG","IRL","ITA","KOR","NLD","NZL","NOR")
			drop if inlist(ISO_Code,"PRT","SGP","ESP","SWE","GBR","CHE","MEX")
		}
		if $by_openess == 1{
			gen openess = exports_share_WB + imports_share_WB if inrange(Time_Period,1973,2019)

		
			bysort Country_Code (Time_Period): egen mean_openess = mean(openess)
			egen mopeness = median(mean_openess)
			sort Country_Code Time_Period
			keep if mean_openess >= mopeness & mean_openess !=.

		/*
			 egen medan_openess = median(openess)
			keep if openess > medan_openess & openess !=.
			*/

			global recreate_local_projection = 0
		}
		else if $by_openess == 2{
			gen openess = exports_share_WB + imports_share_WB if inrange(Time_Period,1973,2019)
		
			bysort Country_Code (Time_Period): egen mean_openess = mean(openess) 
			egen mopeness = median(mean_openess)
			sort Country_Code Time_Period
			keep if mean_openess < mopeness & mean_openess !=.

			/*
			egen medan_openess = median(openess)
			keep if openess < medan_openess & openess !=.
			*/
			
			global recreate_local_projection = 0
		}
		sort Country_Code Time_Period

		if $by_openess == 3{
			/*
			sum kaopen,detail
			keep if kaopen > `r(p50)' & kaopen !=.
			*/
			replace kaopen = . if !inrange(Time_Period,1973,2019)
			bysort Country_Code (Time_Period): egen mean_kaopen = mean(kaopen) 
			egen mkaopen = median(mean_kaopen)
			sort Country_Code Time_Period


			/*
			gen high_kaopen = mean_kaopen > mkaopen & mean_kaopen !=.
			keep if Time_Period >= 1973
			label var high_kaopen "Whether the average capital account openness is above median"
			label var mkaopen "Median Capital account openness"
			label var kaopen "Capital account openness"
			label var mean_kaopen "Average capital account openness"
			label var peg_USD "Whether peg_USD or not"

			keep Time_Period *kaopen countryname region peg_USD
			
			save ./WorkingData/Cleaned/temp_kaopen,replace
			*/
			keep if mean_kaopen >= mkaopen & mean_kaopen !=.

			global recreate_local_projection = 0
		}
		else if $by_openess == 4{
			/*
			sum kaopen,detail
			keep if kaopen <= `r(p50)' & kaopen !=.
			*/
			replace kaopen = . if !inrange(Time_Period,1973,2019)
			bysort Country_Code (Time_Period): egen mean_kaopen = mean(kaopen)
			egen mkaopen = median(mean_kaopen)
			sort Country_Code Time_Period
			keep if mean_kaopen < mkaopen & mean_kaopen !=.

			global recreate_local_projection = 0
		}
		else if $by_openess == 5{
			
			replace kaopen = . if !inrange(Time_Period,1973,2019)
			
			egen mkaopen = median(kaopen)
			sort Country_Code Time_Period

			keep if kaopen >= mkaopen & kaopen !=.

			global recreate_local_projection = 0
		}
		else if $by_openess == 6{
			replace kaopen = . if !inrange(Time_Period,1973,2019)
			egen mkaopen = median(kaopen)
			sort Country_Code Time_Period
			keep if kaopen <= mkaopen & kaopen !=.

			global recreate_local_projection = 0
		}

		if $by_period == 1{
			global time_condition "& Time_Period < 1996"

			global recreate_local_projection = 0
		}
		else if $by_period == 2{
			global time_condition "& Time_Period >= 1996"
			global recreate_local_projection = 0
		}
		else if $by_period == 3{
			gen peg_dlogUS_app = (peg_dlogUS < 0)*peg_dlogUS
			replace  peg_dlogUS = (peg_dlogUS >= 0)*peg_dlogUS
			global recreate_local_projection = 0
		}
		else if $by_period == 4{
			gen peg_dlogUS_dep = (peg_dlogUS >= 0)*peg_dlogUS
			replace peg_dlogUS = (peg_dlogUS < 0)*peg_dlogUS
			global recreate_local_projection = 0
		}
		else{
			global time_condition ""
		}



		
		replace peg_dlogUS = . if (peg_change == 1) | (L.peg_change == 1) 
		*replace peg_dlogUS = . if (peg_change == 1) | (L.peg_change == 1)


		*gen RGDP_per = RGDP_WB/pop
		*bysort peg_to_any4currency Time_Period: egen medgdp = pctile(RGDP_per),p(25)
		*drop if peg_to_any4currency == 1 &  RGDP_per <= medgdp
		*sort Country_Code Time_Period
		gen noweight = 1
		gen ex_share = exports_WTO/nominal_gdp



		gen horizon = .
		gen bh = .
		gen up95 = .
		gen low95 = .
		gen seh = .

		gen bh_store = .
		gen seh_store = .

		gen bh_store_nopeg = .
		gen seh_store_nopeg = .

		gen bh_above = .
		gen up95_above = .
		gen low95_above = .


		if $report_r2 == 1{
			gen R2 = . 
			gen R2_adj = .
			gen R2_nopeg = .
			gen R2_nopeg_adj = .
		}



		gen zeroline = 0
		gen Nobs = .

		global no_control = 0
		global no_CountryFE = 0
		global TimeFE_only = 0
		global outlier_low = 0.5
		global outlier_high = 99.5
		global control_lags = 1
		*global controls_vars dlog_RGDP
		global controls_vars dlog_RGDP
		global controls_peg lag1_peg_dlogUS lag1_peg_USD


		if `spec' == 6{
			global fig_title "Change from Baseline: Drop top and bottom 2.5% of outcome."
			global outlier_low = 2.5
			global outlier_high = 97.5
		}
		else if `spec' == 7{
			global fig_title "Change from Baseline: Drop top and bottom 1% of outcome."
			global outlier_low = 1
			global outlier_high = 99
		}



		if $recreate_local_projection == 1{
			global log_var_list lnominal lreal lRGDP_WB lCPI lRGDP_percapita lexports_WB limports_WB unemp_ILO inflation_WB TBill_rate/*
			*/  lexport_price_WB limport_price_WB lexport_price_IFS limport_price_IFS lTerms_of_trade_WB lTerms_of_trade_IFS lcons real_rate lstock lcredit l_imports_jn lf_imports_jn li_imports_jn ///
			 lexports_WTO limports_WTO lexports_DOT limports_DOT lexports_IFS limports_IFS lservice_gdp lmanuf_gdp lservice_exp lservice_imp lagri_gdp lindustry_gdp limports_WB_share lexports_WB_share lending_rate lex_q ///
			 fdi limp_q portfolio_gdp lrgdpo lrgdpe lpl_x lpl_m lrconna lavh lemp lrnna llabsh lrwtfpna lxr lrtfpna lpl_c ///
			 lpop lhc lcsh_x limports_unit_IFS lexports_unit_IFS limports_q_IFS lexports_q_IFS inflation_IFS ///
			 real_rate_Tbill irr lrgdpna ltot_unit_IFS real_rate_lending lhours_pwt lcapital_pwt credit_to_gdp_BIS ///
			 lexrate_to_USD UIP_deviation monetary_policy real_rate_mp nfagdp assets_gdp_ewn debts_gdp_ewn ///
			 assets_to_debts stock_gdp market_cap_gdp nfa_to_gdp market_cap domestic_credit lstock_oecd ///
			 lhouseprice_oecd inflation_oecd shortrate_oecd nominal_interest_rate real_rate_ni
			 global gdp_var_list curr_acc net_exports_WB reserve exports_WB imports_WB investment_WB ///
			consumption_WB RGDP_WB government_expenditure manuf_gdp construction_gdp service_gdp agri_gdp
			foreach var in $log_var_list {
				forval t = 0/10{
					replace dlog`t'_`var' = F`t'.`var' - L.`var'
				}
				forval t=1/5{
					replace dlogm`t'_`var' = L`t'.`var' - L.`var'
				}
			}

			foreach var in $gdp_var_list {
				forval t = 0/10{
					replace dlog`t'_`var' = ( F`t'.`var' - L.`var' )/L.RGDP_WB
				}
				forval t=1/5{
					replace dlogm`t'_`var' = ( L`t'.`var' - L.`var' )/L.RGDP_WB
				}
			}
		}
		
		
		foreach var in $lhs_list{
			forval t = 0/10{
				qui gen out_`t'_`var' = 0
				
				qui centile(dlog`t'_`var'), centile(${outlier_low}, ${outlier_high})
				local low `r(c_1)'
				local high `r(c_2)'
				qui replace out_`t'_`var' = 1 if ( dlog`t'_`var' < `low'  | dlog`t'_`var' > `high' )
				
			}
			forval t = 1/5{
				qui gen out_m`t'_`var' = 0
				
				qui centile(dlogm`t'_`var'), centile(${outlier_low}, ${outlier_high})
				local low `r(c_1)'
				local high `r(c_2)'	
				if `t' != 1{
					qui replace out_m`t'_`var' = 1 if ( dlogm`t'_`var' < `low'  | dlogm`t'_`var' > `high')
				}
				
			}
		}
		
		

		if `spec' == 1{
			*global fig_title "Change from Baseline: Drop 24 large/rich countries."
			*drop if inlist(ISO_Code,"CHN")

		}
		else if `spec' == 2{
			global no_control = 1
			global fig_title "Change from Baseline: No Controls (but still FEs)."
		}
		else if `spec' == 3{
			global TimeFE_only = 1
			global fig_title "Change from Baseline: Time FE instead of Time X Region FE"
		}
		else if `spec' == 4{
			global no_CountryFE = 1
			global fig_title "Change from Baseline: Remove Country FE."
		}
		else if `spec' == 5{
			global fig_title "Change from Baseline: Drop observations with partial year in peg."
			replace peg_dlogUS = . if (peg_cont < 1 & peg_cont > 0 )
			replace peg_dlogUS = . if (peg_cont < 1 & peg_cont > 0 )

		}
		else if `spec' == 8{
			global fig_title "Change from Baseline: Two lags of controls, instead of one."
			global control_lags 2
			global controls_peg $controls_peg lag2_peg_dlogUS lag2_peg_USD
		}
		else if `spec' == 9{
			global fig_title "Change from Baseline: Control for Interaction btwn. US GDP, US T Bill, US inflation."
			global controls_peg $controls_peg peg_dlogUS_inflation peg_dlogUS_GDP peg_dlogUS_TBill
			global var_bh_store peg_dlogUS_GDP
		}
		else if `spec' == 10{
			*global fig_title "Change from Baseline: Anchor inlucdes everything (including Euro)."
			*global peg "All"
		}
		else if `spec' == 11{
			global fig_title "Change from Baseline: Only sample with Real Effective Exchange Rate Series."
			keep if Real_Effective_Exrate != .
		}
		else if `spec' == 12{
			global fig_title "Change from Baseline: Drop 24 large/rich countries."
			drop if inlist(ISO_Code,"JPN","BEL","AUS","AUT","CAN","DNK","FIN","FRA")
			drop if inlist(ISO_Code,"DEU","GRC","HKG","IRL","ITA","KOR","NLD","NZL","NOR")
			drop if inlist(ISO_Code,"PRT","SGP","ESP","SWE","GBR","CHE","MEX")

		}
		else if `spec' == 15{
			global fig_title "Change from Baseline: Non-missing for all variables"
			foreach v of varlist $lhs_list{
				di "`v'"
				*keep if `v' != .
				foreach v2 of varlist $lhs_list{
					forval t = 0/10{
						replace dlog`t'_`v2' = . if dlog`t'_`v' == .
					}
					forval t = 1/5{
						replace dlogm`t'_`v2' = . if dlogm`t'_`v' == .
					}
				}
			}

			global recreate_local_projection = 0
		}
		else if `spec' == 16{
			global fig_title "Change from Baseline: Non-missing except for interest rates & export/import prices"
			foreach v of varlist $lhs_list{
				if !inlist("`v'","nominal_interest_rate","real_rate_ni","lexport_price_WB","limport_price_WB"){
					*keep if `v' != .
					foreach v2 of varlist $lhs_list{
						forval t = 0/10{
							replace dlog`t'_`v2' = . if dlog`t'_`v' == .
						}
						forval t = 1/5{
							replace dlogm`t'_`v2' = . if dlogm`t'_`v' == .
						}
					}
				}
			}
			global recreate_local_projection = 0
		}
		else if `spec' == 17{
			global fig_title "Change from Baseline: Non-missing except for interest rates"
			foreach v of varlist $lhs_list{
				if !inlist("`v'","nominal_interest_rate","real_rate_ni"){
					*keep if `v' != .
					foreach v2 of varlist $lhs_list{
						forval t = 0/10{
							replace dlog`t'_`v2' = . if dlog`t'_`v' == .
						}
						forval t = 1/5{
							replace dlogm`t'_`v2' = . if dlogm`t'_`v' == .
						}
					}
				}
			}
			global recreate_local_projection = 0
		}
		else if `spec' == 18{
			global fig_title "Change from Baseline: Non-missing except for export/import prices"
			foreach v of varlist $lhs_list{
				if !inlist("`v'","lexport_price_WB","limport_price_WB") ///
				 {
					*keep if `v' != .
					foreach v2 of varlist $lhs_list{
						forval t = 0/10{
							replace dlog`t'_`v2' = . if dlog`t'_`v' == .
						}
						forval t = 1/5{
							replace dlogm`t'_`v2' = . if dlogm`t'_`v' == .
						}
					}
				}
			}

			global recreate_local_projection = 0
		}
		else if `spec' == 20{
			global fig_title "Change from Baseline: Control Peg X Commodit Price Change"
			global controls_peg $controls_peg peg_dlog_Commodity
			global var_bh_store peg_dlog_Commodity
		}
		else if `spec' == 21{
			global fig_title "Change from Baseline: Include 24 Advanced Countries"
		}
		else if `spec' == 22{
			global fig_title "Change from Baseline: Control for Interaction btwn. Global Financial Cycle."
			global controls_peg $controls_peg peg_dlogGFC
			global var_bh_store peg_dlogGFC
		}
		else if `spec' == 23{
			global fig_title "Colonial Orign Instrument for African Countries."
			foreach v in "France" "UK" "Spain" "others"{
				gen dlogUS_colonized_by_`v' = dlog_USA_Nominal_Rate*colonized_by_`v'
			}
			global instruments dlogUS_colonized_by_France dlogUS_colonized_by_UK dlogUS_colonized_by_Spain dlogUS_colonized_by_others
		}
		else if `spec' == 24{
			global fig_title "Change from Baseline: Control for Interaction btwn. Capital Openness and USD Exchange Rate."
			replace kaopen = . if !inrange(Time_Period,1973,2019)
			egen mkaopen = median(kaopen)
			bysort Country_Code: egen mc_kaopen = median(kaopen)
			replace kaopen = mc_kaopen if missing(kaopen)
			gen ka_above = kaopen > mkaopen if !missing(kaopen)
			gen ka_dlogUS = ka_above*dlog_USA_Nominal_Rate
			global controls_peg $controls_peg ka_dlogUS ka_above
			global var_bh_store ka_dlogUS
		}
		


		local ys = $nrow*4
		if $nrow == 3{
			local is = 0.5
		}
		else if $nrow == 2{
			local is = 0.5
		}
		else{
			local is = 1.0
		}
		
		if `spec' == 1{
			/* tempname nobs */
			frame create nobs str32 var h0 h1 h2 h3 h4 h5 h6 h7 h8
		}
		foreach var in $lhs_list {
			sort Country_Code Time_Period
			local controls_compile peg_USD
			local controls_R2
			if $no_control == 0{
				forval L = 1/$control_lags{
					if "`var'" != "RGDP_WB"{
						capture drop L`L'_dlog0_`var' 
						gen L`L'_dlog0_`var' =  L`L'.dlog0_`var' 
						local controls_compile `controls_compile' L`L'_dlog0_`var' 
						local controls_R2 `controls_compile' L`L'_dlog0_`var' 
					}
					foreach convar in $controls_vars{
						capture drop L`L'_`convar'
						gen L`L'_`convar'  = L`L'.`convar' 
						local controls_compile `controls_compile' L`L'_`convar' 
						local controls_R2 `controls_compile' L`L'_`convar' 
					}
				}
				
				local controls_compile `controls_compile' $controls_peg

			}
			* Y = outcome variable (`var')
			local n_row ("`var'")
			forvalues t = $n_pre/$n_post{
				display "----------------------------------------"
				display `"Horizon = `t'"'
				display `"$fig_title"'
				if ${TimeFE_only} == 0 & ${no_CountryFE} == 0 {
					global absorb_set absorb(i.region#i.Time_Period i.Country_Code)
				}
				else if ${TimeFE_only} == 1 & ${no_CountryFE} == 0 {
					global absorb_set absorb(i.Time_Period i.Country_Code)
				}
				else if ${TimeFE_only} == 0 & ${no_CountryFE} == 1 {
					global absorb_set absorb(i.region#i.Time_Period)
				}

				if `spec' != 2 | `t' == -1 {
					local reg_command "reghdfe"
				}
				else{
					* For whatever reason, stata fails to compute std error with reghdfe when spec == 2
					local reg_command "ivreghdfe"
				}

				* Specification: ΔLog[Y(t+h)] = α (I(Pegged) x ΔLog(e(Base, t))) + βΔLog(Y(t-1)) + γ π(t-t) + δ I(Pegged) + ξ(Region x Time) + ϕ(Country) + ε(t+h)
				* Country clustering
				if `t' >=0{
					if !inlist($by_period,3,4){
						`reg_command' dlog`t'_`var' peg_dlogUS `controls_compile' [aw = $weight] if out_`t'_`var' == 0 $time_condition, $absorb_set vce(cluster Country_Code Time_Period)
					}
					else if $by_period == 3{
						`reg_command' dlog`t'_`var' peg_dlogUS peg_dlogUS_app `controls_compile' [aw = $weight] if out_`t'_`var' == 0 $time_condition, $absorb_set vce(cluster Country_Code Time_Period)
					}
					else if $by_period == 4{
						`reg_command' dlog`t'_`var' peg_dlogUS peg_dlogUS_dep `controls_compile' [aw = $weight] if out_`t'_`var' == 0 $time_condition, $absorb_set vce(cluster Country_Code Time_Period)
					}
					if `spec' == 23{
						ivreghdfe dlog`t'_`var' (peg_dlogUS = $instruments ) `controls_compile' [aw = $weight] if out_`t'_`var' == 0 $time_condition  & region == 1, $absorb_set vce(cluster Country_Code Time_Period)
					}
				}
				else if `t' < 0{
					local controls_compile_lag peg_USD
					local tm = -`t'
					if $no_control == 0{
						forval L = 1/$control_lags{
							local lag_con = `tm' + `L'
							capture drop L`lag_con'_dlog0_`var'
							gen L`lag_con'_dlog0_`var' = L`lag_con'.dlog0_`var'
							local  controls_compile_lag `controls_compile_lag' L`lag_con'.dlog0_`var'
							foreach convar in $controls_vars{
								capture drop L`lag_con'_`convar'
								gen L`lag_con'_`convar' = L`lag_con'.`convar'
								local controls_compile_lag `controls_compile_lag' L`lag_con'_`convar'
							}
							local controls_compile_lag `controls_compile_lag' $controls_peg
						}
					}
					if !inlist($by_period,3,4){
						qui `reg_command' dlogm`tm'_`var' peg_dlogUS `controls_compile_lag' [aw = $weight] if out_m`tm'_`var' == 0 $time_condition , $absorb_set vce(cluster Country_Code Time_Period)
						}
					else if $by_period == 3{
						qui `reg_command' dlogm`tm'_`var' peg_dlogUS peg_dlogUS_app `controls_compile_lag' [aw = $weight] if out_m`tm'_`var' == 0 $time_condition, $absorb_set vce(cluster Country_Code Time_Period)
					}
					else if $by_period == 4{
						qui `reg_command' dlogm`tm'_`var' peg_dlogUS peg_dlogUS_dep `controls_compile_lag' [aw = $weight] if out_m`tm'_`var' == 0 $time_condition, $absorb_set vce(cluster Country_Code Time_Period)
					}
					if `spec' == 23 & `t' != -1 {
						ivreghdfe dlogm`tm'_`var' (peg_dlogUS = $instruments ) `controls_compile_lag' [aw = $weight] if out_m`tm'_`var' == 0 $time_condition & region == 1, $absorb_set vce(cluster Country_Code Time_Period)
					}
				}
				
				local n_row `n_row' (`e(N)')

				replace horizon = `t' if _n == `t' - $n_pre + 1
				replace bh = _b[peg_dlogUS] if horizon == `t'
				replace up95 = bh + 1.96*_se[peg_dlogUS] if horizon == `t'
				replace low95 = bh - 1.96*_se[peg_dlogUS] if horizon == `t'
				replace Nobs = `e(N)' if horizon == `t'
				replace seh = _se[peg_dlogUS] if horizon == `t'



				if $report_r2 == 1 & `t' >= 0 {
					replace R2 = e(r2) if horizon == `t'
					replace R2_adj = e(r2_a) if horizon == `t'
					`reg_command' dlog`t'_`var' `controls_R2' [aw = $weight] if out_`t'_`var' == 0 $time_condition, $absorb_set vce(cluster Country_Code Time_Period)
					replace R2_nopeg = e(r2) if horizon == `t'
					replace R2_nopeg_adj = e(r2_a) if horizon == `t'
				}
				if inlist(`spec',9,20,22,24){
					replace bh_store = _b[$var_bh_store] if horizon == `t'
					replace seh_store = _se[$var_bh_store] if horizon == `t'
					if `t' >= 0{
						`reg_command' dlog`t'_`var' `controls_compile' [aw = $weight] if out_`t'_`var' == 0 $time_condition, $absorb_set vce(cluster Country_Code Time_Period)
						replace bh_store_nopeg = _b[$var_bh_store] if horizon == `t'
						replace seh_store_nopeg = _se[$var_bh_store] if horizon == `t'
					}
				}

			}
			// check
			local lab: variable label `var'

			if `spec' == 23{
				local ylab_fig 
				global ymax 1000
				global ymin -1000
			}
			else if inlist("`var'","RGDP_WB"){
				local ylab_fig ylabel(-0.4(0.2)0.8) yscale(range(-0.4 0.8))
				global ymax 1000
				global ymin -1000
				global ylabel_set "% of initial GDP"
			}
			else if inlist("`var'","investment_WB","consumption_WB","exports_WB","imports_WB","net_exports_WB") {
				local ylab_fig ylabel(-0.4(0.2)0.8) yscale(range(-0.4 0.8))
				global ymax 1000
				global ymin -1000
				global ylabel_set "% of initial GDP"

			}
			else if inlist("`var'","real_rate_ni","nominal_interest_rate","inflation_WB","real_rate_bloomberg") {
				local ylab_fig ylabel(-0.4(0.2)0.4) yscale(range(-0.4 0.4))
				global ymax 1000
				global ymin -1000
				global ylabel_set "%"

			}
			else if inlist("`var'","lexport_price_WB","limport_price_WB","lTerms_of_trade_WB") {
				local ylab_fig ylabel(-1.0(0.5)1.0) yscale(range(-1.0 1.0))
				global ymax 1000
				global ymin -1000
							global ylabel_set "%"

			}
			else if inlist("`var'","lnominal","lreal","lexrate_to_USD"){
				global ymax 1.5
				global ymin -1.0
				local ylab_fig ylabel($ymin(0.5)$ymax) yscale(range($ymin $ymax))
							global ylabel_set "%"

			}
			else{
				local ylab_fig 
				global ymax 1000
				global ymin -1000

			}

			preserve
			if inlist(`spec',9,20,22,24){
				keep bh up95 low95 horizon seh bh_store seh_store bh_store_nopeg seh_store_nopeg
			}
			else{
				keep bh up95 low95 horizon seh
			}
			keep if horizon != .
			if $write_table == 1 & $by_openess == 0 & $by_period == 0{
				export delimited using ./Stored_Result/IRF_coef/IRF_`spec'_`var'.csv,replace
			}
			rename bh bh_spec
			rename up95 up95_spec
			rename low95 low95_spec
			rename seh seh_spec
			if $write_table == 1 & $by_openess == 0 & $by_period == 0{
				save ./Stored_Result/IRF_coef/IRF_`spec'_`var',replace
			}
			else if  $write_table == 1 & $by_openess >= 1{
				save ./Stored_Result/IRF_coef/IRF_`spec'_`var'_byopeness_$by_openess,replace
			}
			else if  $write_table == 1 & $by_period >= 1{
				save ./Stored_Result/IRF_coef/IRF_`spec'_`var'_byperiod_$by_period,replace
			}
			restore

			replace up95 = $ymax if up95 > $ymax & up95 != .
			replace low95 = $ymin if low95 < $ymin & low95 != .

			if $fig_list == 17{
				local t_min = 1
			}
			else{
				local t_min = $n_pre
			}
			* Local projection plots
			tw (rarea up95 low95 horizon, bcolor(navy%25) clw(medthin medthin)) ///
			(line zeroline horizon, lp(dash) lc(maroon) ) (scatter bh horizon, c(l) clp(l) ms(5) clc(navy) mc(navy) clw(thick)) ///
			if horizon >= `t_min', ///
			graphregion(color(white)) legend(off) xlabel(`t_min'(1)$n_post) ///
			title("`lab'") ytitle("") xtitle("Years")  name(`var',replace) `ylab_fig' xlab(,nogrid)
			if $fig_save == 1{
				graph export "$fig_slide_folder/slide_`spec'_${peg}_`var'_alone.pdf",replace
			}

			

			if $robust >= 1 | `spec' == 23{

				capture drop bh_spec up95_spec low95_spec
				merge m:1 horizon using ./Stored_Result/IRF_coef/IRF_1_`var',nogen
				replace up95_spec = $ymax if up95_spec > $ymax & up95_spec != .
				replace low95_spec = $ymin if low95_spec < $ymin & low95_spec != .


				tw (rarea up95 low95 horizon, bcolor(maroon%25) clw(medthin medthin)) ///
				(line zeroline horizon, lp(dash) lc(forest_green) ) (scatter bh horizon, msymbol(D) c(l) clp(l) clc(maroon) mc(maroon) clw(thick)) ///
				(scatter bh_spec horizon, c(l) clp(dash) ms(5) clc(navy) mc(navy) clw(thick) msymbol(o)) ///
				(line up95_spec horizon, lp(dash) lc(navy) lw(medthick) ) ///
				(line low95_spec horizon, lp(dash) lc(navy) lw(medthick)), ///
				graphregion(color(white)) legend(off) xlabel($n_pre(1)$n_post) ///
				title("`lab'") ytitle("") xtitle("Years")  name(`var',replace) `ylab_fig' ytitle("${ylabel_set}")  xlab(,nogrid)

			}

			if $report_r2 == 1{
				preserve
				keep horizon R2*
				keep if horizon !=.
				order horizon R2 R2_nopeg R2_adj R2_nopeg_adj
				save "$fig_slide_folder/R2_report_`spec'_${peg}_`var'",replace
				restore
			}
			
		}
		if $ncol <= 2{
			global xsize_set = 6*$ncol
		}
		else{
			global xsize_set = 14
		}
		
		if $robust == 0 & $by_openess == 0 & $by_period == 0{
			
			if $nrow == 1{
				graph combine $lhs_list , ///
				graphregion(color(white)) rows($nrow) xsize($xsize_set) iscale(`is') ycommon
				if $fig_save == 1{
					graph export "$fig_slide_folder/slide_`spec'_${peg}_${lhs_list}_nrow${nrow}.pdf",replace

				}
				graph combine $lhs_list , ///
				graphregion(color(white)) rows($nrow) xsize($xsize_set) iscale(`is')
				if $fig_save == 1{
					graph export "$fig_slide_folder/slide_`spec'_${peg}_${lhs_list}_nrow${nrow}_noncommony.pdf",replace

				}

			}
			else if $nrow == 2{
				graph combine $lhs_list , ///
				graphregion(color(white)) rows($nrow) xsize($xsize_set) ysize(8) iscale(0.5) ycommon
				if $fig_save == 1{
					graph export "$fig_slide_folder/slide_`spec'_${peg}_${lhs_list}_nrow${nrow}.pdf",replace

				}
				graph combine $lhs_list , ///
				graphregion(color(white)) rows($nrow) xsize($xsize_set) ysize(8) iscale(0.5)
				if $fig_save == 1{
					graph export "$fig_slide_folder/slide_`spec'_${peg}_${lhs_list}_nrow${nrow}_noncommony.pdf",replace

				}
			}

		}
		else if $robust == 1 &  $by_openess == 0 & $by_period == 0{
			local ys = 8
			graph combine  $lhs_list, ///
			graphregion(color(white)) rows($nrow) xsize($xsize_set) ysize(`ys') iscale(0.3) title("$fig_title",size(2))
			if $fig_save == 1{
				graph export "$fig_slide_folder/robust_by_`spec'.pdf",replace
			}
		}
		else if $robust == 2 &  $by_openess == 0 & $by_period == 0{
			local ys = 8
			graph combine  $lhs_list, ///
			graphregion(color(white)) rows($nrow) xsize($xsize_set) ysize(`ys') iscale(0.3) title("$fig_title",size(2))
			if $fig_save == 1{
				graph export "$fig_slide_folder/robust2_by_`spec'.pdf",replace
			}
		}
		else if $robust == 3 &  $by_openess == 0 & $by_period == 0{
			local ys = 8
			graph combine  $lhs_list, ///
			graphregion(color(white)) rows($nrow) xsize($xsize_set) ysize(`ys') iscale(0.3) title("$fig_title",size(2))
			if $fig_save == 1{
				graph export "$fig_slide_folder/robust2_by_`spec'.pdf",replace
			}
		}
		
	}

	*log close

}
