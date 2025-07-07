
function construct_IRF(P,xfull,allinputs,Shock_Path,scaling,ss0;scaling2 = 0,xfull2 = 0)

    d = Dict{String,Any}()
    n = length(allinputs)

    if scaling2 == 0 
        for i = 1:n
            d[(allinputs[i])] = xfull[:,i]*scaling .- ss0[i]
        end
    else
        for i = 1:n
            d[(allinputs[i])] = xfull[:,i]*scaling  + xfull2[:,i]*scaling2  .- ss0[i]
        end
    end
    

    
    d["exp_U"] =  ( P["Fshare"]*( P["EXPss"]*d["ratio_UF"] + P["Tradable_share"].*P["alph"].*P["Css"]*d["C_F"] + P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_F"] +P["Tradable_share"].*P["alph"].* P["Iss"]*d["I_F"] ) + 
        P["Pshare"]*( P["EXPss"]*d["ratio_UP"] + P["Tradable_share"].*P["alph"].*P["Css"]*d["C_P"]+ P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_P"] +P["Tradable_share"].*P["alph"].* P["Iss"]*d["I_P"]) + 
        P["Ushare"]*( P["EXPss"]*d["ratio_UU"] + P["Tradable_share"].*P["alph"].*P["Css"]*d["C_U"]+ P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_U"] + P["Tradable_share"].*P["alph"].*P["Iss"]*d["I_U"]));
    
    d["exp_F"] = ( P["Fshare"]*( P["EXPss"]*d["ratio_FF"] + P["Tradable_share"].*P["alph"].*P["Css"]*d["C_F"]+ P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_F"] + P["Tradable_share"].*P["alph"].*P["Iss"]*d["I_F"]) + 
        P["Pshare"]*( P["EXPss"]*d["ratio_FP"] + P["Tradable_share"].*P["alph"].*P["Css"]*d["C_P"]+ P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_P"] + P["Tradable_share"].*P["alph"].*P["Iss"]*d["I_P"]) + 
        P["Ushare"]*( P["EXPss"]*d["ratio_FU"] + P["Tradable_share"].*P["alph"].*P["Css"]* d["C_U"]+ P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_U"] + P["Tradable_share"].*P["alph"].*P["Iss"]*d["I_U"]));
    
    d["exp_P"]=  ( P["Fshare"]*( P["EXPss"]*d["ratio_PF"] + P["Tradable_share"].*P["alph"].*P["Css"]*d["C_F"]+ P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_F"] + P["Tradable_share"].*P["alph"].*P["Iss"]*d["I_F"]) + 
        P["Pshare"]*( P["EXPss"]*d["ratio_PP"] + P["Tradable_share"].*P["alph"].*P["Css"]*d["C_P"]+ P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_P"] + P["Tradable_share"].*P["alph"].*P["Iss"]*d["I_P"]) + 
        P["Ushare"]*( P["EXPss"]*d["ratio_PU"] + P["Tradable_share"].*P["alph"].*P["Css"]*d["C_U"]+ P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_U"] + P["Tradable_share"].*P["alph"].*P["Iss"]*d["I_U"]));
    
    
    d["imp_U"] =  ( P["Ushare"].*( P["IMPss"]*d["ratio_UU"] +P["Tradable_share"].*P["alph"].* P["Css"]* d["C_U"] + P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_U"] + P["Tradable_share"].*P["alph"].*P["Iss"]*d["I_U"]) + 
        P["Pshare"].*( P["IMPss"]*d["ratio_PU"] + P["Tradable_share"].*P["alph"].*P["Css"]*d["C_U"]+ P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_U"] + P["Tradable_share"].*P["alph"].*P["Iss"]*d["I_U"]) + 
        P["Fshare"].*( P["IMPss"]*d["ratio_FU"] + P["Tradable_share"].*P["alph"].*P["Css"]*d["C_U"]+ P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_U"] +P["Tradable_share"].*P["alph"].* P["Iss"]*d["I_U"]) );
    
    d["imp_F"] =  ( P["Ushare"]*( P["IMPss"]*d["ratio_UF"] + P["Tradable_share"].*P["alph"].*P["Css"]* d["C_F"] + P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_F"] + P["Tradable_share"].*P["alph"].*P["Iss"]*d["I_F"]) + 
        P["Pshare"]*( P["IMPss"]*d["ratio_PF"] + P["Tradable_share"].*P["alph"].*P["Css"]*d["C_F"]+ P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_F"] + P["Tradable_share"].*P["alph"].*P["Iss"]*d["I_F"]) + 
        P["Fshare"]*( P["IMPss"]*d["ratio_FF"] + P["Tradable_share"].*P["alph"].*P["Css"]*d["C_F"]+ P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_F"] + P["Tradable_share"].*P["alph"].*P["Iss"]*d["I_F"]) );
    
    d["imp_P"] = ( P["Ushare"]*( P["IMPss"]*d["ratio_UP"] + P["Tradable_share"].*P["alph"].*P["Css"]*d["C_P"]+ P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_P"] + P["Tradable_share"].*P["alph"].*P["Iss"]*d["I_P"]) + 
        P["Pshare"]*(P["IMPss"]*d["ratio_PP"] + P["Tradable_share"].*P["alph"].*P["Css"]*d["C_P"]+ P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_P"] + P["Tradable_share"].*P["alph"].*P["Iss"]*d["I_P"]) + 
        P["Fshare"]*( P["IMPss"]*d["ratio_FP"] + P["Tradable_share"].*P["alph"].*P["Css"]*d["C_P"] + P["Tradable_share"].*P["alph"].*P["Xss"]*d["X_P"] + P["Tradable_share"].*P["alph"].*P["Iss"]*d["I_P"])  );
    


    d["risky_U"] = copy(d["r_U"])
    d["risky_F"] = copy(d["r_F"])
    d["risky_P"] = copy(d["r_P"])


    d["risk_premium_U"] = [d["rp_U"][2:end] - d["r_U"][1:(end-1)];0]
    d["risk_premium_P"] = [d["rp_P"][2:end] - d["r_P"][1:(end-1)];0]
    d["risk_premium_F"] = [d["rp_F"][2:end] - d["r_F"][1:(end-1)];0]

    
    
    d["NER_UF"] = Ex_ij_fun(d["Q_UF"],d["P_U"],d["P_F"])
    d["NER_FU"] = -d["NER_UF"] 
    d["NER_UP"] = Ex_ij_fun(d["Q_UP"],d["P_U"],d["P_P"])
    d["NER_PU"] = -d["NER_UP"] 
    d["NER_PF"] = Ex_ij_fun(d["Q_PF"],d["P_P"],d["P_F"])
    d["NER_FP"] = -d["NER_PF"] 
    
    d["NER_U"] = (P["Fshare"]*d["NER_FU"] .+ P["Pshare"]*d["NER_PU"] .+ 0.0)
    d["NER_F"] = (0 .+ P["Pshare"]*d["NER_PF"] .+ P["Ushare"]*d["NER_UF"])
    d["NER_P"] = (P["Fshare"]*d["NER_FP"] .+ 0 .+ P["Ushare"]*d["NER_UP"])
    
    d["RER_U"] = (P["Fshare"]*d["Q_FU"] .+ P["Pshare"]*d["Q_PU"] .+ 0)
    d["RER_F"] = (0 .+ P["Pshare"]*d["Q_PF"] + P["Ushare"]*d["Q_UF"])
    d["RER_P"] = (P["Fshare"]*d["Q_FP"] .+ P["Ushare"]*d["Q_UP"])
    
    
    d["imp_price_U"] =  ( P["Ushare"]*d["p_UU"] + P["Pshare"]*d["p_PU"] + P["Fshare"]*d["p_FU"])
    d["imp_price_F"] = ( P["Ushare"]*d["p_UF"] + P["Pshare"]*d["p_PF"] + P["Fshare"]*d["p_FF"])
    d["imp_price_P"] = ( P["Ushare"]*d["p_UP"] + P["Pshare"]*d["p_PP"] + P["Fshare"]*d["p_FP"])
    
    d["exp_price_U"] = ( P["Ushare"]*d["p_UU"] + P["Pshare"]*(d["p_UP"] + d["NER_PU"]) + P["Fshare"]*( d["p_UF"] + d["NER_FU"]))
    d["exp_price_P"] = ( P["Ushare"]*( d["p_PU"] + d["NER_UP"]) + P["Pshare"]*d["p_PP"]+ P["Fshare"]*(d["p_PF"] + d["NER_FP"] ))
    d["exp_price_F"] = ( P["Ushare"]* ( d["p_FU"] + d["NER_UF"]) + P["Pshare"]*( d["p_FP"]+ d["NER_PF"])  + P["Fshare"]*d["p_FF"] )
    
    d["imp_price_U_USD"] =  ( P["Ushare"]*d["p_UU"] + P["Pshare"]*d["p_PU"] + P["Fshare"]*d["p_FU"])
    d["imp_price_F_USD"] = ( P["Ushare"]*( d["p_UF"] + d["NER_FU"]) + P["Pshare"]*( d["p_PF"]+ d["NER_FU"]) + P["Fshare"]*( d["p_FF"] + d["NER_FU"]))
    d["imp_price_P_USD"] = ( P["Ushare"]*(d["p_UP"] +d["NER_PU"])+ P["Pshare"]*( d["p_PP"] + d["NER_PU"]) + P["Fshare"]*(d["p_FP"] +  +d["NER_PU"]))
    
    d["exp_price_U_USD"] = ( P["Ushare"]*d["p_UU"] + P["Pshare"]*(d["p_UP"] + d["NER_PU"]) + P["Fshare"]*( d["p_UF"] + d["NER_FU"]))
    d["exp_price_P_USD"] = ( P["Ushare"]*( d["p_PU"] ) + P["Pshare"]*(d["p_PP"] +  +d["NER_PU"])+ P["Fshare"]*(d["p_PF"] + d["NER_FU"] ))
    d["exp_price_F_USD"] = ( P["Ushare"]* ( d["p_FU"] ) + P["Pshare"]*( d["p_FP"]+ d["NER_PU"])  + P["Fshare"]*( d["p_FF"] + d["NER_FU"]))
    
    
    d["ToT_U"] = d["exp_price_U"] - d["imp_price_U"]
    d["ToT_P"] = d["exp_price_P"] - d["imp_price_P"]
    d["ToT_F"] = d["exp_price_F"] - d["imp_price_F"]

    d["C_GDP_U"] = P["Css"]/P["GDPss"]*d["C_U"]
    d["C_GDP_P"] = P["Css"]/P["GDPss"]*d["C_P"] 
    d["C_GDP_F"] = P["Css"]/P["GDPss"]*d["C_F"] 

    d["I_GDP_U"] = P["Iss"]/P["GDPss"]*d["I_U"]
    d["I_GDP_P"] = P["Iss"]/P["GDPss"]*d["I_P"] 
    d["I_GDP_F"] = P["Iss"]/P["GDPss"]*d["I_F"] 

    d["EXP_GDP_U"] = 1 ./P["GDPss"]*d["exp_U"]
    d["EXP_GDP_P"] = 1 ./P["GDPss"]*d["exp_P"]
    d["EXP_GDP_F"] = 1 ./P["GDPss"]*d["exp_F"]

    d["IMP_GDP_U"] = 1 ./P["GDPss"]*d["imp_U"]
    d["IMP_GDP_P"] = 1 ./P["GDPss"]*d["imp_P"]
    d["IMP_GDP_F"] = 1 ./P["GDPss"]*d["imp_F"]

    
    d["NX_GDP_U"] = d["EXP_GDP_U"]  .- d["IMP_GDP_U"]
    d["NX_GDP_P"] = d["EXP_GDP_P"]  .- d["IMP_GDP_P"]
    d["NX_GDP_F"] = d["EXP_GDP_F"]  .- d["IMP_GDP_F"]

    d["GDP_U"] = d["C_GDP_U"] + d["I_GDP_U"] + d["EXP_GDP_U"] -  d["IMP_GDP_U"]
    d["GDP_P"] = d["C_GDP_P"] + d["I_GDP_P"] + d["EXP_GDP_P"] -  d["IMP_GDP_P"]
    d["GDP_F"] = d["C_GDP_F"] + d["I_GDP_F"] + d["EXP_GDP_F"] -  d["IMP_GDP_F"]


    d["NX_U"] = (d["exp_U"] -  d["imp_U"])./d["GDP_U"]
    d["NX_P"] = (d["exp_P"] -  d["imp_P"])./d["GDP_P"]
    d["NX_F"] = (d["exp_F"] -  d["imp_F"])./d["GDP_F"]

    d["NT_GDP_U"] = (1-P["Tradable_share"]).*P["Yss"]*(1-P["omega"]).*( ( - P["T_NT_elasticity"]*(d["p_UU"] - d["P_U"])) + P["Css"]/P["Yss"]*d["C_U"] + P["Xss"]/P["Yss"]*d["X_U"] + P["Iss"]/P["Yss"]*d["I_U"] )/P["GDPss"]
    d["NT_GDP_P"] = (1-P["Tradable_share"]).*P["Yss"]*(1-P["omega"]).*( ( - P["T_NT_elasticity"]*(d["p_PP"] - d["P_P"])) + P["Css"]/P["Yss"]*d["C_P"] + P["Xss"]/P["Yss"]*d["X_P"] + P["Iss"]/P["Yss"]*d["I_P"] )/P["GDPss"]
    d["NT_GDP_F"] = (1-P["Tradable_share"]).*P["Yss"]*(1-P["omega"]).*( ( - P["T_NT_elasticity"]*(d["p_FF"] - d["P_F"])) + P["Css"]/P["Yss"]*d["C_F"] + P["Xss"]/P["Yss"]*d["X_F"] + P["Iss"]/P["Yss"]*d["I_F"] )/P["GDPss"]

    d["T_GDP_U"] = d["GDP_U"] - d["NT_GDP_U"]
    d["T_GDP_P"] = d["GDP_P"] - d["NT_GDP_P"]
    d["T_GDP_F"] = d["GDP_F"] - d["NT_GDP_F"]

    
    d["relative_C"] = d["C_GDP_P"] - d["C_GDP_F"]
    d["relative_N"] = d["N_P"] - d["N_F"]
    d["relative_Y"] = d["GDP_P"] - d["GDP_F"]
    d["relative_I"] = d["I_GDP_P"] - d["I_GDP_F"]
    d["relative_K"] = d["K_P"] - d["K_F"]
    d["relative_i"] = d["i_P"] - d["i_F"]
    d["relative_pi"] = d["pi_P"] - d["pi_F"]
    d["relative_r"] = d["r_P"] - d["r_F"]
    d["relative_exp"] = d["EXP_GDP_P"] - d["EXP_GDP_F"]
    d["relative_imp"] = d["IMP_GDP_P"] - d["IMP_GDP_F"]
    d["relative_netexp"] = d["relative_exp"] - d["relative_imp"]
    d["relative_RER"] = d["RER_P"] - d["RER_F"]
    d["relative_NER"] = d["NER_P"] - d["NER_F"]
    d["relative_ToT"] = d["ToT_P"] - d["ToT_F"]
    d["relative_risk_premium"] = d["risk_premium_P"] - d["risk_premium_F"]
    d["relative_rp"] = [d["rp_P"][2:end] - d["rp_F"][2:end];0]

    d["relative_exp_price"] = d["exp_price_P_USD"] - d["exp_price_F_USD"]
    d["relative_imp_price"] = d["imp_price_P_USD"] - d["imp_price_F_USD"]
    
    d["relative_exp_price_local"] = d["exp_price_P"] - d["exp_price_F"]
    d["relative_imp_price_local"] = d["imp_price_P"] - d["imp_price_F"]
    
    d["relative_T_GDP"] = d["T_GDP_P"] - d["T_GDP_F"]
    d["relative_NT_GDP"] = d["NT_GDP_P"] - d["NT_GDP_F"]

    d["relative_UIP_deviation"] = d["NER_UF"][1:end] - [0; d["NER_UF"][1:(end-1)]] + d["i_F"] - d["i_P"]

    return d

end
