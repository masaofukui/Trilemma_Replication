

Ex_ij_fun(Q_ij,P_i,P_j) = Q_ij - P_i + P_j;



###############################################
# Consumption (3) (TO BE MODIFIED THOUGH SEQUENCE SPACE JACOBIAN)
###############################################

function Cr_U_def(P, Cr_U,r_U,Cr_U_p1,rp_U_p1,Cr_U_m1,MUr_U,MUr_U_p1,B_U,RealY_U,C_U)
    #eval = - P["sig"]*(Cr_U - P["habit"]*Cr_U_m1) + P["sig"]*(Cr_U_p1 - P["habit"]*Cr_U) - rp_U_p1 + P["U Demand shock"] + P["Common Demand shock"]
    eval =  MUr_U - MUr_U_p1 - rp_U_p1 + P["U Demand shock"] + P["Common Demand shock"]
    if P["final2"] == 1
        eval =  - P["Css"]*C_U  - B_U +
        (1+P["rss"])*B_U + P["Css"]*(RealY_U);
    end
    return eval;
end
Cr_U_def_inputs = arg_name(Cr_U_def)

function Cr_P_def(P, Cr_P,r_P,Cr_P_p1,rp_P_p1,Cr_P_m1,MUr_P,MUr_P_p1,B_P,RealY_P,C_P)
    #eval = - P["sig"]*(Cr_P - P["habit"]*Cr_P_m1) + P["sig"]*(Cr_P_p1 - P["habit"]*Cr_P) - rp_P_p1 + P["P Demand shock"]  + P["Common Demand shock"]
    eval = MUr_P - MUr_P_p1 - rp_P_p1 + P["P Demand shock"]  + P["Common Demand shock"]
    if P["final2"] == 1
        eval =  - P["Css"]*C_P  - B_P +
        (1+P["rss"])*B_P + P["Css"]*(RealY_P);
    end
    return eval;
end
Cr_P_def_inputs = arg_name(Cr_P_def)

function Cr_F_def(P, Cr_F,r_F,Cr_F_p1,rp_F_p1,Cr_F_m1,MUr_F,MUr_F_p1,B_F,RealY_F,C_F)
    #eval = - P["sig"]*(Cr_F - P["habit"]*Cr_F_m1) + P["sig"]*(Cr_F_p1 - P["habit"]*Cr_F) - rp_F_p1 + P["F Demand shock"]
    eval = MUr_F - MUr_F_p1 - rp_F_p1 + P["F Demand shock"]
    if P["final2"] == 1
        eval =  - P["Css"]*C_F  - B_F +
        (1+P["rss"])*B_F + P["Css"]*(RealY_F);
    end
    return eval;
end
Cr_F_def_inputs = arg_name(Cr_F_def)


function MUr_U_def(P, MUr_U,Cr_U,Cr_U_m1,Cr_U_p1)
    eval = - P["sig"]*Cr_U*(1 + P["beta"]*P["habit"]^2)./(1-P["beta"]*P["habit"]) +
    P["habit"]./(1-P["beta"]*P["habit"])*P["sig"]*Cr_U_m1 +
        P["beta"]*P["habit"]./(1-P["beta"]*P["habit"])*P["sig"]*Cr_U_p1 - MUr_U*(1-P["habit"]);

    #eval = - P["sig"]*(Cr_U - P["habit"]*Cr_U_m1) - MUr_U
    return eval;
end
MUr_U_def_inputs = arg_name(MUr_U_def)

function MUr_P_def(P, MUr_P,Cr_P,Cr_P_m1,Cr_P_p1)
    eval = - P["sig"]*Cr_P*(1 + P["beta"]*P["habit"]^2)./(1-P["beta"]*P["habit"]) + 
    P["habit"]./(1-P["beta"]*P["habit"])*P["sig"]*Cr_P_m1 +
        P["beta"]*P["habit"]./(1-P["beta"]*P["habit"])*P["sig"]*Cr_P_p1 - MUr_P*(1-P["habit"]);
    
    #eval = - P["sig"]*(Cr_P - P["habit"]*Cr_P_m1) - MUr_P

    return eval;
end
MUr_P_def_inputs = arg_name(MUr_P_def)

function MUr_F_def(P, MUr_F,Cr_F,Cr_F_m1,Cr_F_p1)
    eval = - P["sig"]*Cr_F*(1 + P["beta"]*P["habit"]^2)./(1-P["beta"]*P["habit"]) + 
    P["habit"]./(1-P["beta"]*P["habit"])*P["sig"]*Cr_F_m1 +
        P["beta"]*P["habit"]./(1-P["beta"]*P["habit"])*P["sig"]*Cr_F_p1 - MUr_F*(1-P["habit"]);
    
        #eval = - P["sig"]*(Cr_F - P["habit"]*Cr_F_m1) - MUr_F

    return eval;
end
MUr_F_def_inputs = arg_name(MUr_F_def)



function MUh_U_def(P, MUh_U,Ch_U,Ch_U_m1,Ch_U_p1)
    eval = - P["sig"]*Ch_U*(1 + P["beta"]*P["habit"]^2)./(1-P["beta"]*P["habit"]) +
    P["habit"]./(1-P["beta"]*P["habit"])*P["sig"]*Ch_U_m1 +
        P["beta"]*P["habit"]./(1-P["beta"]*P["habit"])*P["sig"]*Ch_U_p1 - MUh_U*(1-P["habit"]);
    
    #eval = - P["sig"]*(Ch_U - P["habit"]*Ch_U_m1) - MUh_U

    return eval;
end
MUh_U_def_inputs = arg_name(MUh_U_def)

function MUh_P_def(P, MUh_P,Ch_P,Ch_P_m1,Ch_P_p1)
    eval = - P["sig"]*Ch_P*(1 + P["beta"]*P["habit"]^2)./(1-P["beta"]*P["habit"]) + 
    P["habit"]./(1-P["beta"]*P["habit"])*P["sig"]*Ch_P_m1 +
        P["beta"]*P["habit"]./(1-P["beta"]*P["habit"])*P["sig"]*Ch_P_p1 - MUh_P*(1-P["habit"]);
    
    #eval = - P["sig"]*(Ch_P - P["habit"]*Ch_P_m1) - MUh_P

    return eval;
end
MUh_P_def_inputs = arg_name(MUh_P_def)

function MUh_F_def(P, MUh_F,Ch_F,Ch_F_m1,Ch_F_p1)
    eval = - P["sig"]*Ch_F*(1 + P["beta"]*P["habit"]^2)./(1-P["beta"]*P["habit"]) + 
    P["habit"]./(1-P["beta"]*P["habit"])*P["sig"]*Ch_F_m1 +
        P["beta"]*P["habit"]./(1-P["beta"]*P["habit"])*P["sig"]*Ch_F_p1 - MUh_F*(1-P["habit"]);
    
     #eval = - P["sig"]*(Ch_F - P["habit"]*Ch_F_m1) - MUh_F

    return eval;
end
MUh_F_def_inputs = arg_name(MUh_F_def)




###############################################
# HtM Consumption (3) (TO BE MODIFIED THOUGH SEQUENCE SPACE JACOBIAN)
###############################################

function Ch_U_def(P, Ch_U,W_U,N_U,P_U,Profit_U)
    #eval = Ch_U - RealY_U
    eval = Ch_U -(W_U + N_U - P_U) - 1/P["WNss"]*P["Lshare"]*Profit_U
    return eval;
end
Ch_U_def_inputs = arg_name(Ch_U_def)

function Ch_P_def(P, Ch_P,W_P,N_P,P_P,Profit_P)
    eval = Ch_P -(W_P + N_P - P_P) - 1/P["WNss"]*P["Lshare"]*Profit_P
    #eval = Ch_P - RealY_P
    return eval;
end
Ch_P_def_inputs = arg_name(Ch_P_def)

function Ch_F_def(P, Ch_F,W_F,N_F,P_F,Profit_F)
    eval = Ch_F -(W_F + N_F - P_F) - 1/P["WNss"]*P["Lshare"]*Profit_F
    #eval = Ch_F - RealY_F
    return eval;
end
Ch_F_def_inputs = arg_name(Ch_F_def)

###############################################
# Tptal Consumption (3) (TO BE MODIFIED THOUGH SEQUENCE SPACE JACOBIAN)
###############################################
function C_U_def(P, Ch_U,Cr_U,C_U)
    eval = C_U - (Ch_U*P["HtMcshare"] + Cr_U*(1-P["HtMcshare"]))
    return eval;
end
C_U_def_inputs = arg_name(C_U_def)

function C_P_def(P, Ch_P,Cr_P,C_P)
    eval = C_P - (Ch_P*P["HtMcshare"] + Cr_P*(1-P["HtMcshare"]))
    return eval;
end
C_P_def_inputs = arg_name(C_P_def)


function C_F_def(P, Ch_F,Cr_F,C_F)
    eval = C_F - (Ch_F*P["HtMcshare"] + Cr_F*(1-P["HtMcshare"]))
    return eval;
end
C_F_def_inputs = arg_name(C_F_def)

###############################################
# Dividneds
###############################################

function D_U_def(P, D_U,p_UF,Q_UF,P_U,P_F,p_UU,p_UP,Q_UP,P_P,N_U,X_U,K_U,W_U,I_U)
    if P["Yss"] - P["WNss"] - P["Xss"]- P["Iss"] == 0
        eval = D_U
    else
        eval =
        1/(P["Yss"] - P["WNss"] - P["Xss"]- P["Iss"])*
        ( P["Yss"]* ( P["chiUF"].*(p_UF - Ex_ij_fun(Q_UF,P_U,P_F)) +
        P["chiUU"].*(p_UU ) +
        P["chiUP"].*(p_UP - Ex_ij_fun(Q_UP,P_U,P_P)) +
        P["U TFP shock"] + P["Common TFP shock"] +
        (1-P["omega"] - P["kappaK"])*N_U + 
        P["omega"]*X_U +
        P["kappaK"]*K_U) +
        - P["WNss"]*(W_U + N_U) +
        - P["Xss"]*(P_U + X_U) +
        - P["Iss"]*(P_U + I_U) 
        ) - P_U - D_U
    end
    return eval;
end
D_U_def_inputs = arg_name(D_U_def)

function D_P_def(P, D_P,p_PF,Q_PF,P_P,P_F,p_PU,Q_PU,P_U,p_PP,N_P,X_P,K_P,W_P,I_P)
    if P["Yss"] - P["WNss"] - P["Xss"]- P["Iss"] == 0
        eval = D_P
    else
        eval = 
        1/(P["Yss"] - P["WNss"] - P["Xss"]- P["Iss"])*
        ( P["Yss"]* ( P["chiPF"].*(p_PF - Ex_ij_fun(Q_PF,P_P,P_F)) +
        P["chiPU"].*(p_PU - Ex_ij_fun(Q_PU,P_P,P_U)) +
        P["chiPP"].*(p_PP ) +
        P["P TFP shock"] + P["Common TFP shock"] +
        (1-P["omega"] - P["kappaK"])*N_P + 
        P["omega"]*X_P +
        P["kappaK"]*K_P) +
        - P["WNss"]*(W_P + N_P) +
        - P["Xss"]*(P_P + X_P) +
        - P["Iss"]*(P_P + I_P) 
        ) - P_P - D_P
    end
    return eval;
end
D_P_def_inputs = arg_name(D_P_def)

function D_F_def(P, D_F,p_FF,p_FFown,p_FU,Q_FU,P_F,P_U,p_FP,Q_FP,P_P,N_F,X_F,K_F,W_F,I_F)
    if P["Yss"] - P["WNss"] - P["Xss"]- P["Iss"] == 0
        eval = D_F
    else
        eval = 
        1/(P["Yss"] - P["WNss"] - P["Xss"]- P["Iss"])*
        ( P["Yss"]* ( P["chiFF"].*(p_FF) +
        P["chiFFown"].*(p_FFown) +
        P["chiFU"].*(p_FU - Ex_ij_fun(Q_FU,P_F,P_U)) +
        P["chiFP"].*(p_FP - Ex_ij_fun(Q_FP,P_F,P_P)) +
        P["F TFP shock"] +
        (1-P["omega"] - P["kappaK"])*N_F + 
        P["omega"]*X_F +
        P["kappaK"]*K_F) +
        - P["WNss"]*(W_F + N_F) +
        - P["Xss"]*(P_F + X_F) +
        - P["Iss"]*(P_F + I_F) 
        ) - P_F - D_F
    end

    return eval;
end
D_F_def_inputs = arg_name(D_F_def)



###############################################
# Dividneds without investment
###############################################

function Dk_U_def(P, Dk_U,p_UF,Q_UF,P_U,P_F,p_UU,p_UP,Q_UP,P_P,N_U,X_U,K_U,W_U,I_U,MC_U,Profit_U)
    if P["Yss"] - P["WNss"] - P["Xss"]- P["Iss"] == 0
        eval = Dk_U
    else
        eval =
        1/(P["rss"]*P["Kss"]) * ( P["Yss"]* ( MC_U + 
        P["U TFP shock"] + P["Common TFP shock"] +
            (1-P["omega"] - P["kappaK"])*N_U + 
            P["omega"]*X_U +
            P["kappaK"]*K_U) +
            - P["WNss"]*(W_U + N_U) +
            - P["Xss"]*(P_U + X_U)  +
            P["Kshare"]*Profit_U + 
            - P["deltaK"]*P["Kss"]*(P_U + I_U) ) +
         - P_U - Dk_U
    end
    return eval;
end
Dk_U_def_inputs = arg_name(Dk_U_def)

function Dk_P_def(P, Dk_P,p_PF,Q_PF,P_P,P_F,p_PU,Q_PU,P_U,p_PP,N_P,X_P,K_P,W_P,I_P,MC_P,Profit_P)
    if P["Yss"] - P["WNss"] - P["Xss"]- P["Iss"] == 0
        eval = Dk_P
    else
        eval =
        1/(P["rss"]*P["Kss"]) * ( P["Yss"]* ( MC_P + 
            P["P TFP shock"] + P["Common TFP shock"] +
            (1-P["omega"] - P["kappaK"])*N_P + 
            P["omega"]*X_P +
            P["kappaK"]*K_P) +
            - P["WNss"]*(W_P + N_P) +
            - P["Xss"]*(P_P + X_P)  +
            P["Kshare"]*Profit_P + 
            - P["deltaK"]*P["Kss"]*(P_P + I_P) ) +
         - P_P - Dk_P
    end
    return eval;
end
Dk_P_def_inputs = arg_name(Dk_P_def)

function Dk_F_def(P, Dk_F,p_FF,p_FFown,p_FU,Q_FU,P_F,P_U,p_FP,Q_FP,P_P,N_F,X_F,K_F,W_F,I_F,MC_F,Profit_F)
    if P["Yss"] - P["WNss"] - P["Xss"]- P["Iss"] == 0
        eval = Dk_F
    else
        eval =
        1/(P["rss"]*P["Kss"]) * ( P["Yss"]* ( MC_F + 
            P["F TFP shock"]  +
            (1-P["omega"] - P["kappaK"])*N_F + 
            P["omega"]*X_F +
            P["kappaK"]*K_F) +
            - P["WNss"]*(W_F + N_F) +
            - P["Xss"]*(P_F + X_F)  +
            P["Kshare"]*Profit_F + 
            - P["deltaK"]*P["Kss"]*(P_F + I_F) ) +
         - P_F - Dk_F
    end

    return eval;
end
Dk_F_def_inputs = arg_name(Dk_F_def)



###############################################
# Dividneds without investment
###############################################

function Profit_U_def(P, Profit_U,p_UF,Q_UF,P_U,P_F,p_UU,p_UP,Q_UP,P_P,N_U,X_U,K_U,W_U,I_U,MC_U)
    if P["Yss"] - P["WNss"] - P["Xss"]- P["Iss"] == 0
        eval = Dk_U
    else
        eval =
        P["Yss"]* ( P["chiUF"].*(p_UF - Ex_ij_fun(Q_UF,P_U,P_F)) +
        P["chiUU"].*(p_UU ) +
        P["chiUP"].*(p_UP - Ex_ij_fun(Q_UP,P_U,P_P)) +
         - MC_U 
        ) - Profit_U
    end
    return eval;
end
Profit_U_def_inputs = arg_name(Profit_U_def)

function Profit_P_def(P, Profit_P,p_PF,Q_PF,P_P,P_F,p_PU,Q_PU,P_U,p_PP,N_P,X_P,K_P,W_P,I_P,MC_P)
    if P["Yss"] - P["WNss"] - P["Xss"]- P["Iss"] == 0
        eval = Dk_P
    else
        eval = 
        P["Yss"]* ( P["chiPF"].*(p_PF - Ex_ij_fun(Q_PF,P_P,P_F)) +
        P["chiPU"].*(p_PU - Ex_ij_fun(Q_PU,P_P,P_U)) +
        P["chiPP"].*(p_PP ) +
        - MC_P
        )   -  Profit_P
    end
    return eval;
end
Profit_P_def_inputs = arg_name(Profit_P_def)

function Profit_F_def(P, Profit_F,p_FF,p_FFown,p_FU,Q_FU,P_F,P_U,p_FP,Q_FP,P_P,N_F,X_F,K_F,W_F,I_F,MC_F)
    if P["Yss"] - P["WNss"] - P["Xss"]- P["Iss"] == 0
        eval = Dk_F
    else
        eval = 
        P["Yss"]* ( P["chiFF"].*(p_FF) +
        P["chiFFown"].*(p_FFown) +
        P["chiFU"].*(p_FU - Ex_ij_fun(Q_FU,P_F,P_U)) +
        P["chiFP"].*(p_FP - Ex_ij_fun(Q_FP,P_F,P_P)) +
        - MC_F
        ) - Profit_F
    end

    return eval;
end
Profit_F_def_inputs = arg_name(Profit_F_def)


###############################################
# Real Rate (3) 
###############################################

function r_U_def(P, r_U,i_U,pi_U_p1,pi_U)
    if P["final2"] != 1
        eval = r_U - (i_U - pi_U_p1) 
    else
        eval = r_U - (i_U - pi_U) 
    end
    return eval;
end
r_U_def_inputs = arg_name(r_U_def)


function r_P_def(P, r_P,i_P,pi_P_p1,pi_P)
    if P["final2"] != 1
        eval = r_P - (i_P - pi_P_p1) 
    else
        eval = r_P - (i_P - pi_P) 
    end
    return eval;
end
r_P_def_inputs = arg_name(r_P_def)

function r_F_def(P,r_F, i_F,pi_F_p1,pi_F)
    if P["final2"] != 1
        eval = r_F - (i_F - pi_F_p1) 
    else
        eval = r_F - (i_F - pi_F) 
    end
    return eval;
end
r_F_def_inputs = arg_name(r_F_def)


###############################################
# Wage Phillips Curve (3)
###############################################
function wp_U(P,W_U,piW_U_p1,piW_U,N_U,P_U,Ch_U,Cr_U,Profit_U,C_U,C_U_m1,MUr_U,MUh_U)
    MUtemp = P["sigw"]/P["sig"]*( P["HtMdushare"]*MUh_U + (1-P["HtMdushare"])*MUr_U) 
    eval = P["deltaw"].*(piW_U) -
        (1-P["deltaw"]) .*(1-P["beta"].*P["deltaw"]).*
        (P_U - MUtemp + P["nu"].*N_U - W_U - P["Lshare"]/P["WNss"]*Profit_U);
    if P["final"] != 1
        eval = eval - P["deltaw"].*P["beta"].*(piW_U_p1);
    else
        eval = eval - P["deltaw"].*P["beta"].*(piW_U);
        eval = piW_U
    end
    return eval
end
wp_U_inputs = arg_name(wp_U)
function wp_F(P,piW_F,piW_F_p1,N_F,W_F,P_F,Ch_F,Cr_F,Profit_F,C_F,C_F_m1,MUr_F,MUh_F)
    MUtemp = P["sigw"]/P["sig"]*( P["HtMdushare"]*MUh_F + (1-P["HtMdushare"])*MUr_F) 

   eval = P["deltaw"].*(piW_F) -
    (1-P["deltaw"]) .*(1-P["beta"].*P["deltaw"]).*
        (P_F - MUtemp + P["nu"].*N_F - W_F - P["Lshare"]/P["WNss"]*Profit_F);
    if P["final"] != 1
        eval = eval - P["deltaw"].*P["beta"].*(piW_F_p1) ;
    else
        eval = eval - P["deltaw"].*P["beta"].*(piW_F);
        eval = piW_F

    end
    return eval
end
wp_F_inputs = arg_name(wp_F)
function wp_P(P,piW_P,piW_P_p1,N_P,W_P,P_P,Ch_P,Cr_P,Profit_P,C_P,C_P_m1,MUr_P,MUh_P)
    MUtemp = P["sigw"]/P["sig"]*( P["HtMdushare"]*MUh_P + (1-P["HtMdushare"])*MUr_P) 

    eval = P["deltaw"].*(piW_P) -
    (1-P["deltaw"]) .*(1-P["beta"].*P["deltaw"]).*
        (P_P - MUtemp + P["nu"].*N_P - W_P - P["Lshare"]/P["WNss"]*Profit_P);
    if P["final"] != 1
        eval = eval - P["deltaw"].*P["beta"].*(piW_P_p1);
    else
        eval = eval - P["deltaw"].*P["beta"].*(piW_P);
        eval = piW_P

    end
    return eval
end
wp_P_inputs = arg_name(wp_P)

###############################################
# UIP (3)
###############################################



function UIP_FU(P,Q_FU,NFA_F,Bflow_FU,i_F,Q_UF_p1,Q_UF,i_U,pi_U_p1,pi_F_p1)
    if  P["F_fix"] == 0 
        if P["final"] == 1
            eval = Q_FU
        else
            eval = Bflow_FU + P["U UIP shock"] - P["F UIP shock"]  ;
        end
    else
        eval = i_U - i_F + Q_UF_p1 - Q_UF+ 
        pi_F_p1 - pi_U_p1;
    end

    return eval
end
UIP_FU_inputs = arg_name(UIP_FU)

function Bflow_FU_def(P,i_F,i_U,Q_FU_p1,Q_FU,pi_U_p1,pi_F_p1,Bflow_FU,rp_F_p1,Bflow_FU_m1,r_F,A_U,A_P,A_F,q_F,NFA_F,NFA_U,NFA_P,pi_U,pi_F)
    tot_F_saving = P["s_share"]*P["Ushare"]/(1-P["Fshare"])*NFA_U + P["Pshare"]/(1-P["Fshare"])*NFA_P + (1-P["s_share"])*NFA_F 
    if P["GammaB"] == 0
        tot_F_saving = 0.0;
    end
    
    eval = P["flow_adj"]*( 1*(i_F - i_U + Q_FU_p1 - Q_FU + 
        pi_U_p1 - pi_F_p1)*P["qss"] + 
        P["GammaB"]* tot_F_saving - 1/P["GammaD"]*P["F Risk shock"] + 1/P["GammaD"]*P["U Risk shock"]) +
        (1-P["flow_adj"])*Bflow_FU_m1 + 
        - Bflow_FU;
    if P["final2"] == 1
        eval = P["flow_adj"]*( 1*(i_F - i_U + Q_FU - Q_FU + 
        pi_U - pi_F)*P["qss"] + 
        P["GammaB"]*tot_F_saving - 1/P["GammaD"]*P["F Risk shock"] + 1/P["GammaD"]*P["U Risk shock"]) +
        P["GammaB"]*(1-P["flow_adj"])*Bflow_FU_m1 + 
        - Bflow_FU;
    end
    return eval
end
Bflow_FU_def_inputs = arg_name(Bflow_FU_def)


function UIP_PF(P,Q_FP,NFA_F,Bflow_PF,i_P,i_F,Q_PF_p1,Q_PF,pi_F_p1,pi_P_p1) 
    if P["F_fix"] == 0 
        if P["final"] == 1
            eval = Q_FP
        else
            if P["P_Taylor"] == 0
                eval = Bflow_PF + P["U UIP shock"] - P["F UIP shock"]  ;

            else
                eval = Bflow_PF + P["P UIP shock"] ;
            end
        end
    else
        eval = i_P - i_F + Q_PF_p1 - Q_PF+ 
        pi_F_p1 - pi_P_p1;
    end
    return eval
end
UIP_PF_inputs = arg_name(UIP_PF)

function Bflow_PF_def(P,i_F,i_P,Q_FP_p1,Q_FP,pi_P_p1,pi_F_p1,Bflow_PF,rp_F_p1,Bflow_PF_m1,r_F,A_U,A_P,A_F,q_F,NFA_F,NFA_U,NFA_P,pi_P,pi_F)
    tot_F_saving = P["s_share"]*P["Ushare"]/(1-P["Fshare"])*NFA_U + P["Pshare"]/(1-P["Fshare"])*NFA_P + (1-P["s_share"])*NFA_F 
    if P["GammaB"] == 0
        tot_F_saving = 0.0;
    end

    eval = P["flow_adj"]*( 1*(i_F - i_P + Q_FP_p1 - Q_FP+ 
    pi_P_p1 - pi_F_p1)*P["qss"] + 
    P["GammaB"]*tot_F_saving - 1/P["GammaD"]*P["F Risk shock"] + 1/P["GammaD"]*P["U Risk shock"])+ 
    P["GammaB"]*(1-P["flow_adj"])*Bflow_PF_m1 + 
    - Bflow_PF;
    if P["final2"] == 1
        eval = P["flow_adj"]*((i_F - i_P + Q_FP - Q_FP+ 
        pi_P - pi_F)*P["qss"] + 
        P["GammaB"]*tot_F_saving - 1/P["GammaD"]*P["F Risk shock"] + 1/P["GammaD"]*P["U Risk shock"])+ 
        (1-P["flow_adj"])*Bflow_PF_m1 + 
        - Bflow_PF;
    end
    return eval
end
Bflow_PF_def_inputs = arg_name(Bflow_PF_def)


function UIP_UP(P,i_U,i_P,Q_UP_p1,Q_UP,pi_P_p1,pi_U_p1,B_P,pi_U,pi_P)
    if P["final"] == 1
        eval = Q_UP
    else
        if P["P_Taylor"] == 0
            eval = i_U - i_P ;
        else
            eval = i_U - i_P + Q_UP_p1 - Q_UP+ 
            pi_P_p1 - pi_U_p1 + P["P UIP shock"] - P["U UIP shock"] + P["F UIP shock"] ;
        end
    end
    
    return eval
end 
UIP_UP_inputs = arg_name(UIP_UP)



UIP_FU_ss(P,B_U) = B_U;
UIP_FU_ss_inputs = arg_name(UIP_FU_ss)

UIP_PF_ss(P,B_F) = B_F;
UIP_PF_ss_inputs = arg_name(UIP_PF_ss)

UIP_UP_ss(P,B_P) = B_P;
UIP_UP_ss_inputs = arg_name(UIP_UP_ss)

###############################################
# Budget constraint (3)
###############################################

function BC_U(P,C_U,B_U,B_U_m1,RealY_U)
    eval =  - P["Css"]*C_U  - B_U +
        (1+P["rss"])*B_U_m1 + P["Css"]*(RealY_U);
    return eval
end
BC_U_inputs = arg_name(BC_U);

function BC_F(P,C_F,B_F,B_F_m1,RealY_F)
    eval =  - P["Css"]*C_F  - B_F +
        (1+P["rss"])*B_F_m1 + P["Css"]*(RealY_F);
    return eval
end
BC_F_inputs = arg_name(BC_F);


function BC_P(P,C_P,B_P,B_P_m1,RealY_P)
    eval =  - P["Css"]*C_P  - B_P+
        (1+P["rss"])*B_P_m1 + P["Css"]*(RealY_P);
    return eval
end
BC_P_inputs = arg_name(BC_P);



function A_U_def(P,C_U,A_U,A_U_m1,RealWN_U,rp_U ,Profit_U)
    eval =  - P["Css"]*C_U  - A_U +
        (1+P["rss"])*A_U_m1 + (1+P["rss"])*P["qss"]*rp_U + P["WNss"]*RealWN_U + 
        P["Lshare"]*Profit_U;
    return eval
end
A_U_def_inputs = arg_name(A_U_def);

function A_P_def(P,C_P,A_P,A_P_m1,RealWN_P,rp_P,Profit_P)
    eval =  - P["Css"]*C_P  - A_P +
        (1+P["rss"])*A_P_m1 + (1+P["rss"])*P["qss"]*rp_P + P["WNss"]*RealWN_P + 
        P["Lshare"]*Profit_P;
    return eval
end
A_P_def_inputs = arg_name(A_P_def);


function A_F_def(P,C_F,A_F,A_F_m1,RealWN_F,rp_F,Profit_F)
    eval =  - P["Css"]*C_F  - A_F +
        (1+P["rss"])*A_F_m1 + (1+P["rss"])*P["qss"]*rp_F + P["WNss"]*RealWN_F +
        P["Lshare"]*Profit_F;
    return eval
end
A_F_def_inputs = arg_name(A_F_def);


###############################################
# Monetary Policy (3)
###############################################

function MP_U(P,i_U,pi_U,i_U_m1,pi_U_p1,N_U)
    if P["final"] == 1
        eval = i_U - P["rhom"].*i_U_m1 +
            - (1-P["rhom"]).*( P["phipi"].*pi_U + P["phiY"].*N_U )+ P["U MP shock"]
    else
        eval = i_U - P["rhom"].*i_U_m1 +
        - (1-P["rhom"]).*( P["phipi"].*pi_U + P["phiY"].*N_U )+ P["U MP shock"]
    end
    
    return eval
end
MP_U_inputs = arg_name(MP_U)


function MP_F(P,i_F,pi_F,i_F_m1,pi_F_p1,N_F,Q_FU,P_F,P_U)
    if P["F_fix"] == 0 
        if P["final"] == 1
            eval  = i_F - P["rhom"].*i_F_m1 +
            - (1-P["rhom"]).*( P["phipi"].*pi_F + P["phiY"].*N_F ) -  P["phiEx_F"]*Ex_ij_fun(Q_FU,P_F,P_U) +
            + P["F MP shock"] 
        else
            eval  = i_F - P["rhom"].*i_F_m1 +
            - (1-P["rhom"]).*( P["phipi"].*pi_F + P["phiY"].*N_F ) -  P["phiEx_F"]*Ex_ij_fun(Q_FU,P_F,P_U)  +
            + P["F MP shock"] 
        end
    else
        eval = Ex_ij_fun(Q_FU,P_F,P_U);
    end

    return eval
end
MP_F_inputs = arg_name(MP_F)


function MP_P(P,i_P,pi_P,i_P_m1,pi_P_p1,N_P,Q_PU,P_P,P_U)
    if P["P_Taylor"] == 1
        if P["final"] == 1
            eval  = i_P - P["rhom"].*i_P_m1 +
            - (1-P["rhom"]).*( P["phipi"].*pi_P + P["phiY"].*N_P ) -  P["phiEx_P"]*Ex_ij_fun(Q_PU,P_P,P_U) +
            + P["P MP shock"] 
        else
            eval  = i_P - P["rhom"].*i_P_m1 +
            - (1-P["rhom"]).*( P["phipi"].*pi_P + P["phiY"].*N_P ) -  P["phiEx_P"]*Ex_ij_fun(Q_PU,P_P,P_U)  +
            + P["P MP shock"] 
        end
    else
        eval = Ex_ij_fun(Q_PU,P_P,P_U);

    end
    return eval

end

MP_P_inputs = arg_name(MP_P)



MP_U_ss(P,P_U) = P_U
MP_U_ss_inputs = arg_name(MP_U_ss)

MP_P_ss(P,P_P) = P_P
MP_P_ss_inputs = arg_name(MP_P_ss)

MP_F_ss(P,P_F) = P_F
MP_F_ss_inputs = arg_name(MP_F_ss)


#MP_P(P,i_P,pi_P,i_P_m1,pi_P_p1,N_P,Q_PU,P_P,P_U,i_U) = Ex_ij_fun(Q_PU,P_P,P_U);
#MP_P_inputs = arg_name(MP_P)

###############################################
# Goods market clearing (3)
###############################################

GC_U(P,p_UF,p_UP,p_UU,N_U,P_F,C_F,P_P,C_P,P_U,C_U,X_U,X_P,X_F,I_F,I_P,I_U,K_U,
    ratio_UF,ratio_UP,ratio_UU) = 
    - (P["chiUF"].*p_UF + P["chiUP"].*p_UP + P["chiUU"].*p_UU) +
     - (1-P["omega"]- P["kappaK"])*N_U - P["omega"]*X_U - P["kappaK"]*K_U +
     - P["U TFP shock"]  - P["Common TFP shock"] +
    P["Tradable_share"]*P["chiUF_T"].*((p_UF - P_F) + ratio_UF +  P_F + P["Css"]/P["Yss"]*C_F + P["Xss"]/P["Yss"]*X_F + P["Iss"]/P["Yss"]*I_F) +
    P["Tradable_share"]*P["chiUP_T"].*((p_UP - P_P) + ratio_UP + P_P + P["Css"]/P["Yss"]*C_P + P["Xss"]/P["Yss"]*X_P +  P["Iss"]/P["Yss"]*I_P) +
    P["Tradable_share"]*P["chiUU_T"].*((p_UU - P_U) + ratio_UU + P_U + P["Css"]/P["Yss"]*C_U + P["Xss"]/P["Yss"]*X_U +  P["Iss"]/P["Yss"]*I_U) +
    (1-P["Tradable_share"]).*( (p_UU - P_U) - P["T_NT_elasticity"]*(p_UU - P_U) + P_U + P["Css"]/P["Yss"]*C_U + P["Xss"]/P["Yss"]*X_U + P["Iss"]/P["Yss"]*I_U );
GC_U_inputs = arg_name(GC_U)


GC_P(P,p_PF,p_PP,p_PU,N_P,P_F,C_F,P_P,C_P,P_U,C_U,X_U,X_P,X_F,I_F,I_P,I_U,K_P,
    ratio_PF,ratio_PP,ratio_PU) = 
    - (P["chiPF"].*p_PF + P["chiPP"].*p_PP + P["chiPU"].*p_PU) + 
    - (1-P["omega"]- P["kappaK"])*N_P - P["omega"]*X_P - P["kappaK"]*K_P +
    - P["P TFP shock"] - P["Common TFP shock"] +
    P["Tradable_share"]*P["chiPF_T"].*((p_PF - P_F) + ratio_PF + P_F  + P["Css"]/P["Yss"]*C_F + P["Xss"]/P["Yss"]*X_F + P["Iss"]/P["Yss"]*I_F) +
    P["Tradable_share"]*P["chiPP_T"].*((p_PP - P_P) + ratio_PP + P_P + P["Css"]/P["Yss"]*C_P + P["Xss"]/P["Yss"]*X_P+ P["Iss"]/P["Yss"]*I_P) +
    P["Tradable_share"]*P["chiPU_T"].*((p_PU - P_U) + ratio_PU + P_U  + P["Css"]/P["Yss"]*C_U + P["Xss"]/P["Yss"]*X_U+ P["Iss"]/P["Yss"]*I_U) + 
    (1-P["Tradable_share"]).*( (p_PP - P_P) - P["T_NT_elasticity"]*(p_PP - P_P) + P_P + P["Css"]/P["Yss"]*C_P + P["Xss"]/P["Yss"]*X_P + P["Iss"]/P["Yss"]*I_P );
GC_P_inputs = arg_name(GC_P)


GC_F(P,p_FF,p_FFown,p_FP,p_FU,N_F,P_F,C_F,P_P,C_P,P_U,C_U,X_U,X_P,X_F,I_F,I_P,I_U,K_F,
    ratio_FFown,ratio_FF,ratio_FP,ratio_FU) = 
    - (P["chiFFown"].*p_FFown + P["chiFF"].*p_FF + P["chiFP"].*p_FP + P["chiFU"].*p_FU) +
     - (1-P["omega"]- P["kappaK"])*N_F - P["omega"]*X_F - P["kappaK"]*K_F +
     - P["F TFP shock"] + 
    P["Tradable_share"]*P["chiFFown_T"].*((p_FFown - P_F) + ratio_FFown + P_F  + P["Css"]/P["Yss"]*C_F + P["Xss"]/P["Yss"]*X_F+ P["Iss"]/P["Yss"]*I_F) +
    P["Tradable_share"]*P["chiFF_T"].*((p_FF - P_F) + ratio_FF + P_F + P["Css"]/P["Yss"]*C_F + P["Xss"]/P["Yss"]*X_F+ P["Iss"]/P["Yss"]*I_F) +
    P["Tradable_share"]*P["chiFP_T"].*((p_FP - P_P) + ratio_FP + P_P  + P["Css"]/P["Yss"]*C_P + P["Xss"]/P["Yss"]*X_P+ P["Iss"]/P["Yss"]*I_P) +
    P["Tradable_share"]*P["chiFU_T"].*((p_FU - P_U) + ratio_FU + P_U  + P["Css"]/P["Yss"]*C_U + P["Xss"]/P["Yss"]*X_U+ P["Iss"]/P["Yss"]*I_U) +
    (1-P["Tradable_share"]).*( (p_FFown - P_F) - P["T_NT_elasticity"]*(p_FFown - P_F) + P_F + P["Css"]/P["Yss"]*C_F + P["Xss"]/P["Yss"]*X_F + P["Iss"]/P["Yss"]*I_F );
GC_F_inputs = arg_name(GC_F)


#GC_F(P,p_FF,p_FFown,p_FP,p_FU,N_F,P_F,C_F,P_P,C_P,P_U,C_U,X_U,X_P,X_F,I_F,I_P,I_U,K_F,
#    ratio_FFown,ratio_FF,ratio_FP,ratio_FU) = p_FU
#GC_F_inputs = arg_name(GC_F)



###############################################
# Delayed substitution U
###############################################


function target_ratio_UU(P,p_UU,PT_U,P_U,target_UU,target_UU_p1)
    eval =  (1-P["beta"]*P["delay"])* (- P["eta"]*(p_UU - PT_U) - P["T_NT_elasticity"]*(PT_U - P_U) )  +
        P["beta"]*P["delay"]*target_UU_p1 - target_UU
    return eval
end
target_ratio_UU_inputs = arg_name(target_ratio_UU)

function target_ratio_UP(P,p_UP,PT_P,P_P,target_UP,target_UP_p1)
    eval = (1-P["beta"]*P["delay"])* (- P["eta"]*(p_UP - PT_P)- P["T_NT_elasticity"]*(PT_P - P_P) )  +
        P["beta"]*P["delay"]*target_UP_p1 - target_UP
    return eval
end
target_ratio_UP_inputs = arg_name(target_ratio_UP)

function target_ratio_UF(P,p_UF,PT_F,P_F,target_UF,target_UF_p1)
    eval = (1-P["beta"]*P["delay"])*(-P["eta"]*(p_UF - PT_F) - P["T_NT_elasticity"]*(PT_F - P_F))  +
        P["beta"]*P["delay"]*target_UF_p1 - target_UF
    return eval
end
target_ratio_UF_inputs = arg_name(target_ratio_UF)


function eqm_ratio_UU(P,ratio_UU,ratio_UU_m1,target_UU)
    eval = (1-P["delay"])*target_UU + P["delay"]*ratio_UU_m1 - ratio_UU
    return eval
end
eqm_ratio_UU_inputs = arg_name(eqm_ratio_UU)


function eqm_ratio_UP(P,ratio_UP,ratio_UP_m1,target_UP)
    eval = (1-P["delay"])*target_UP + P["delay"]*ratio_UP_m1 - ratio_UP
    return eval
end
eqm_ratio_UP_inputs = arg_name(eqm_ratio_UP)

function eqm_ratio_UF(P,ratio_UF,ratio_UF_m1,target_UF)
    eval = (1-P["delay"])*target_UF + P["delay"]*ratio_UF_m1 - ratio_UF
    return eval
end
eqm_ratio_UF_inputs = arg_name(eqm_ratio_UF)


###############################################
# Delayed substitution P
###############################################

function target_ratio_PU(P,p_PU,PT_U,P_U,target_PU,target_PU_p1)
    eval = (1-P["beta"]*P["delay"])*(- P["eta"]*(p_PU - PT_U) - P["T_NT_elasticity"]*(PT_U - P_U)) +
        P["beta"]*P["delay"]*target_PU_p1 - target_PU
    return eval
end
target_ratio_PU_inputs = arg_name(target_ratio_PU)

function target_ratio_PP(P,p_PP,PT_P,P_P,target_PP,target_PP_p1)
    eval = (1-P["beta"]*P["delay"])*(-P["eta"]*(p_PP - PT_P) - P["T_NT_elasticity"]*(PT_P - P_P)) +
        P["beta"]*P["delay"]*target_PP_p1 - target_PP
    return eval
end
target_ratio_PP_inputs = arg_name(target_ratio_PP)

function target_ratio_PF(P,p_PF,PT_F,P_F,target_PF,target_PF_p1)
    eval = (1-P["beta"]*P["delay"])*(- P["eta"]*(p_PF - PT_F) - P["T_NT_elasticity"]*(PT_F - P_F)) +
        P["beta"]*P["delay"]*target_PF_p1 - target_PF
    return eval
end
target_ratio_PF_inputs = arg_name(target_ratio_PF)


function eqm_ratio_PU(P,ratio_PU,ratio_PU_m1,target_PU)
    eval = (1-P["delay"])*target_PU + P["delay"]*ratio_PU_m1 - ratio_PU
    return eval
end
eqm_ratio_PU_inputs = arg_name(eqm_ratio_PU)


function eqm_ratio_PP(P,ratio_PP,ratio_PP_m1,target_PP)
    eval = (1-P["delay"])*target_PP + P["delay"]*ratio_PP_m1 - ratio_PP
    return eval
end
eqm_ratio_PP_inputs = arg_name(eqm_ratio_PP)

function eqm_ratio_PF(P,ratio_PF,ratio_PF_m1,target_PF)
    eval = (1-P["delay"])*target_PF + P["delay"]*ratio_PF_m1 - ratio_PF
    return eval
end
eqm_ratio_PF_inputs = arg_name(eqm_ratio_PF)

###############################################
# Delayed substitution F
###############################################

function target_ratio_FU(P,p_FU,PT_U,P_U,target_FU,target_FU_p1)
    eval =  (1-P["beta"]*P["delay"])*(- P["eta"]*(p_FU - PT_U) - P["T_NT_elasticity"] *(PT_U - P_U)) +
        P["beta"]*P["delay"]*target_FU_p1 - target_FU
    return eval
end
target_ratio_FU_inputs = arg_name(target_ratio_FU)

function target_ratio_FP(P,p_FP,PT_P,P_P,target_FP,target_FP_p1)
    eval = (1-P["beta"]*P["delay"])*(-P["eta"]*(p_FP - PT_P)  - P["T_NT_elasticity"] *(PT_P - P_P)) +
        P["beta"]*P["delay"]*target_FP_p1 - target_FP
    return eval
end
target_ratio_FP_inputs = arg_name(target_ratio_FP)

function target_ratio_FF(P,p_FF,PT_F,P_F,target_FF,target_FF_p1)
    eval =  (1-P["beta"]*P["delay"])*(- P["eta"]*(p_FF - PT_F)  - P["T_NT_elasticity"] *(PT_F - P_F)) +
        P["beta"]*P["delay"]*target_FF_p1 - target_FF
    return eval
end
target_ratio_FF_inputs = arg_name(target_ratio_FF)

function target_ratio_FFown(P,p_FFown,PT_F,P_F,target_FFown,target_FFown_p1)
    eval = (1-P["beta"]*P["delay"])*( - P["eta"]*(p_FFown - PT_F) - P["T_NT_elasticity"] *(PT_F - P_F)) +
        P["beta"]*P["delay"]*target_FFown_p1 - target_FFown
    return eval
end
target_ratio_FFown_inputs = arg_name(target_ratio_FFown)


function eqm_ratio_FU(P,ratio_FU,ratio_FU_m1,target_FU)
    eval = (1-P["delay"])*target_FU + P["delay"]*ratio_FU_m1 - ratio_FU
    return eval
end
eqm_ratio_FU_inputs = arg_name(eqm_ratio_FU)


function eqm_ratio_FP(P,ratio_FP,ratio_FP_m1,target_FP)
    eval = (1-P["delay"])*target_FP + P["delay"]*ratio_FP_m1 - ratio_FP
    return eval
end
eqm_ratio_FP_inputs = arg_name(eqm_ratio_FP)

function eqm_ratio_FF(P,ratio_FF,ratio_FF_m1,target_FF)
    eval = (1-P["delay"])*target_FF + P["delay"]*ratio_FF_m1 - ratio_FF
    return eval
end
eqm_ratio_FF_inputs = arg_name(eqm_ratio_FF)

function eqm_ratio_FFown(P,ratio_FFown,ratio_FFown_m1,target_FFown)
    eval = (1-P["delay"])*target_FFown + P["delay"]*ratio_FFown_m1 - ratio_FFown
    return eval
end
eqm_ratio_FFown_inputs = arg_name(eqm_ratio_FFown)


###############################################
# Phillips Curve (9)
###############################################
MCfun(P,W_i,P_i,RK_i) = (1-P["omega"] - P["kappaK"])*W_i +  P["omega"]*P_i + P["kappaK"]*RK_i

Desired_price(P,MC,LocalP,Exrate) = (1-P["zeta"])*(MC + Exrate) + P["zeta"]*LocalP

#origin U
function PC_UP(P,Q_UP,Q_UP_m1, pi_P, pi_U,Q_FP,Q_FP_m1,pi_F,Q_UP_p1,pi_P_p1,pi_U_p1,Q_FP_p1,pi_F_p1,
P_U,P_P,W_U,p_UP,pi_UP,pi_UP_p1,MC_U,pi_UP_m1)

    eval = P["theta_UP_U"].*( Q_UP - Q_UP_m1 + pi_P-pi_U) +
        P["theta_UP_F"].*( Q_FP - Q_FP_m1 + pi_P-pi_F) +
        P["theta_UP_P"].*( 0 )  +
        - (pi_UP) + 
        (1-P["beta"].*P["deltap"]).*(1-P["deltap"])./P["deltap"].*(Desired_price(P,MC_U,P_P,Ex_ij_fun(Q_UP,P_U,P_P)) - p_UP - P["U TFP shock"] - P["Common TFP shock"]) +
        P["Inertia"]*pi_UP_m1
    if P["final2"] != 1
        eval = eval + 
        -P["beta"].*(
            P["theta_UP_U"].*( Q_UP_p1 - Q_UP + pi_P_p1-pi_U_p1) +
            P["theta_UP_F"].*( Q_FP_p1 - Q_FP + pi_P_p1-pi_F_p1) +
            P["theta_UP_P"].*( 0) 
        ) + 
        (1-P["Inertia"])*P["beta"].*(pi_UP_p1) 
    else
        eval = eval + 
        -P["beta"].*(
            P["theta_UP_U"].*( Q_UP - Q_UP + pi_P-pi_U) +
            P["theta_UP_F"].*( Q_FP - Q_FP + pi_P-pi_F) +
            P["theta_UP_P"].*( 0) 
        ) + 
        (1-P["Inertia"])*P["beta"].*(pi_UP) 
        eval = pi_UP
    end
    return eval
end
PC_UP_inputs = arg_name(PC_UP)

function PC_UU(P,Q_FU,Q_FU_m1,Q_FU_p1, pi_P, pi_U,pi_F,pi_P_p1, pi_U_p1,pi_F_p1, Q_PU, Q_PU_m1,Q_PU_p1,
W_U,p_UU,pi_UU,pi_UU_p1,P_U,MC_U,pi_UU_m1)

    eval = P["theta_UU_U"].*( 0) +
    P["theta_UU_F"].*( Q_FU - Q_FU_m1 + pi_U-pi_F) +
    P["theta_UU_P"].*( Q_PU - Q_PU_m1 + pi_U-pi_P) +
    - (pi_UU) + 
    (1-P["beta"].*P["deltap"]).*(1-P["deltap"])./P["deltap"].*(Desired_price(P,MC_U,P_U,0) - p_UU - P["U TFP shock"] - P["Common TFP shock"]) +
    P["Inertia"]*pi_UU_m1

    if P["final"]!= 1
        eval = eval + 
        -P["beta"].*(
            P["theta_UU_U"].*(0) +
            P["theta_UU_F"].*( Q_FU_p1 - Q_FU  + pi_U_p1 - pi_F_p1) +
            P["theta_UU_P"].*( Q_PU_p1 - Q_PU + pi_U_p1 - pi_P_p1) 
        ) + 
        (1-P["Inertia"])*P["beta"].*(pi_UU_p1 );
    else
        eval = eval + 
        -P["beta"].*(
            P["theta_UU_U"].*(0) +
            P["theta_UU_F"].*( Q_FU - Q_FU  + pi_U - pi_F ) +
            P["theta_UU_P"].*( Q_PU - Q_PU + pi_U - pi_P ) 
        ) + 
        (1-P["Inertia"])*P["beta"].*(pi_UU );
        eval = pi_UU
    end
    return eval
end
PC_UU_inputs = arg_name(PC_UU)

function PC_UF(P,Q_UF, Q_UF_m1,Q_UF_p1, Q_PF,Q_PF_p1,Q_PF_m1, pi_F,pi_U,pi_P,pi_F_p1,pi_P_p1,pi_U_p1,
P_U,P_F,W_U,p_UF,pi_UF_p1,pi_UF,MC_U,pi_UF_m1) 
    
    eval = P["theta_UF_U"].*( Q_UF - Q_UF_m1 + pi_F- pi_U) +
    P["theta_UF_F"].*( 0) +
    P["theta_UF_P"].*( Q_PF - Q_PF_m1 + pi_F-pi_P) +
    - (pi_UF) + 
    (1-P["beta"].*P["deltap"]).*(1-P["deltap"])./P["deltap"].*(Desired_price(P,MC_U,P_F,Ex_ij_fun(Q_UF,P_U,P_F)) - p_UF - P["U TFP shock"] - P["Common TFP shock"]) +
    P["Inertia"]*pi_UF_m1


    if P["final"] != 1
        eval = eval +
        -P["beta"].*(
        P["theta_UF_U"].*( Q_UF_p1 - Q_UF + pi_F_p1 - pi_U_p1 ) +
        P["theta_UF_F"].*( 0) +
        P["theta_UF_P"].*( Q_PF_p1 - Q_PF + pi_F_p1 - pi_P_p1)
        ) + 
        (1-P["Inertia"])*P["beta"].*(pi_UF_p1);
    else
        eval = eval +
        -P["beta"].*(
        P["theta_UF_U"].*( Q_UF - Q_UF + pi_F - pi_U ) +
        P["theta_UF_F"].*( 0) +
        P["theta_UF_P"].*( Q_PF - Q_PF + pi_F - pi_P)
        ) + 
        (1-P["Inertia"])*P["beta"].*(pi_UF);
        eval = pi_UF

    end
    return eval
end
PC_UF_inputs = arg_name(PC_UF)


# origin P
function PC_PP(P,Q_UP,Q_UP_m1, pi_P, pi_U,Q_FP,Q_FP_m1,pi_F,Q_UP_p1,pi_P_p1,pi_U_p1,Q_FP_p1,pi_F_p1,
P_P,W_P,p_PP,pi_PP_p1,pi_PP,MC_P,pi_PP_m1)
    
    eval = P["theta_PP_U"].*( Q_UP - Q_UP_m1 + pi_P-pi_U) +
    P["theta_PP_F"].*( Q_FP - Q_FP_m1 + pi_P-pi_F) +
    P["theta_PP_P"].*( 0) +
    - (pi_PP) + 
    (1-P["beta"].*P["deltap"]).*(1-P["deltap"])./P["deltap"].*(Desired_price(P,MC_P,P_P,0) - P["P TFP shock"]  - p_PP - P["Common TFP shock"]) +
    P["Inertia"]*pi_PP_m1


    if P["final"] != 1
        eval = eval +
        -P["beta"].*(
            P["theta_PP_U"].*( Q_UP_p1 - Q_UP + pi_P_p1-pi_U_p1) +
            P["theta_PP_F"].*( Q_FP_p1 - Q_FP  + pi_P_p1-pi_F_p1) +
            P["theta_PP_P"].*( 0) 
        ) +
        (1-P["Inertia"])*P["beta"].*(pi_PP_p1);
    else
        eval = eval +
        -P["beta"].*(
            P["theta_PP_U"].*( Q_UP - Q_UP + pi_P_p1-pi_U) +
            P["theta_PP_F"].*( Q_FP - Q_FP  + pi_P_p1-pi_F) +
            P["theta_PP_P"].*( 0) 
        ) +
        (1-P["Inertia"])*P["beta"].*(pi_PP);
        eval = pi_PP
    end
    return eval
end
PC_PP_inputs = arg_name(PC_PP)

function PC_PU(P,Q_FU,Q_FU_m1,Q_FU_p1,Q_PU,Q_PU_m1,Q_PU_p1,pi_U,pi_F,pi_P,pi_U_p1,pi_F_p1,pi_P_p1,
P_P,P_U,p_PU,pi_PU,pi_PU_p1,W_P,MC_P,pi_PU_m1) 
    
    eval = 
    P["theta_PU_U"].*( 0) +
    P["theta_PU_F"].*( Q_FU - Q_FU_m1 + pi_U-pi_F) +
    P["theta_PU_P"].*( Q_PU - Q_PU_m1 + pi_U-pi_P) +
    - (pi_PU) + 
    (1-P["beta"].*P["deltap"]).*(1-P["deltap"])./P["deltap"].*(Desired_price(P,MC_P,P_U,Ex_ij_fun(Q_PU,P_P,P_U)) - p_PU - P["P TFP shock"] - P["Common TFP shock"]) +
    P["Inertia"]*pi_PU_m1


    if P["final"] != 1
        eval = eval + 
        -P["beta"].*(
        P["theta_PU_U"].*(0) +
        P["theta_PU_F"].*( Q_FU_p1 - Q_FU + pi_U_p1 - pi_F_p1) +
        P["theta_PU_P"].*( Q_PU_p1 - Q_PU + pi_U_p1 - pi_P_p1) 
        ) +
        (1-P["Inertia"])*P["beta"].*(pi_PU_p1);
    else
        eval = eval + 
        -P["beta"].*(
        P["theta_PU_U"].*(0) +
        P["theta_PU_F"].*( Q_FU - Q_FU + pi_U - pi_F) +
        P["theta_PU_P"].*( Q_PU - Q_PU + pi_U - pi_P) 
        ) +
        (1-P["Inertia"])*P["beta"].*(pi_PU);
        eval = pi_PU
    end
    return eval
end
PC_PU_inputs = arg_name(PC_PU)

function PC_PF(P,Q_UF,Q_UF_m1,Q_UF_p1, pi_P, pi_U,pi_F,pi_P_p1, pi_U_p1,pi_F_p1, Q_PF, Q_PF_m1,Q_PF_p1,
W_P,p_PF,pi_PF_p1,pi_PF,P_P,P_F,MC_P,pi_PF_m1)

    eval = P["theta_PF_U"].*( Q_UF - Q_UF_m1 + pi_F- pi_U) +
    P["theta_PF_F"].*( 0) +
    P["theta_PF_P"].*( Q_PF - Q_PF_m1 + pi_F-pi_P) +
    - (pi_PF) + 
    (1-P["beta"].*P["deltap"]).*(1-P["deltap"])./P["deltap"].*(Desired_price(P,MC_P,P_F,Ex_ij_fun(Q_PF,P_P,P_F)) - p_PF - P["P TFP shock"] - P["Common TFP shock"]) +
    P["Inertia"]*pi_PF_m1

    
    if P["final"] !=1
        eval = eval + 
        -P["beta"].*(
            P["theta_PF_U"].*( Q_UF_p1 - Q_UF + pi_F_p1 - pi_U_p1 ) +
            P["theta_PF_F"].*( 0) +
            P["theta_PF_P"].*( Q_PF_p1 - Q_PF + pi_F_p1 - pi_P_p1)
        ) +
        (1-P["Inertia"])*P["beta"].*(pi_PF_p1 );
    else
        eval = eval + 
        -P["beta"].*(
            P["theta_PF_U"].*( Q_UF - Q_UF + pi_F - pi_U ) +
            P["theta_PF_F"].*( 0) +
            P["theta_PF_P"].*( Q_PF - Q_PF + pi_F - pi_P ) 
        ) +
        (1-P["Inertia"])*P["beta"].*(pi_PF );
        eval = pi_PF
    end   
    return eval 
end
PC_PF_inputs = arg_name(PC_PF)



# origin F
function PC_FP(P,Q_UP,Q_UP_m1, pi_P, pi_U,Q_FP,Q_FP_m1,pi_F,Q_UP_p1,pi_P_p1,pi_U_p1,Q_FP_p1,pi_F_p1,
P_F, P_P,W_F,p_FP,pi_FP,pi_FP_p1,MC_F,pi_FP_m1)

    eval = P["theta_FP_U"].*( Q_UP - Q_UP_m1 + pi_P-pi_U) +
    P["theta_FP_F"].*( Q_FP - Q_FP_m1 + pi_P-pi_F) +
    P["theta_FP_P"].*( 0) +
    - (pi_FP) + 
    (1-P["beta"].*P["deltap"]).*(1-P["deltap"])./P["deltap"].*(Desired_price(P,MC_F,P_P,Ex_ij_fun(Q_FP,P_F,P_P))- P["F TFP shock"] - p_FP) +
    P["Inertia"]*pi_FP_m1


    if P["final"] != 1
        eval = eval + 
        -P["beta"].*(
        P["theta_FP_U"].*( Q_UP_p1 - Q_UP + pi_P_p1-pi_U_p1) +
        P["theta_FP_F"].*( Q_FP_p1 - Q_FP + pi_P_p1-pi_F_p1) +
        P["theta_FP_P"].*( 0) 
        ) +
        (1-P["Inertia"])*P["beta"].*(pi_FP_p1 );
    else
        eval = eval + 
        -P["beta"].*(
        P["theta_FP_U"].*( Q_UP - Q_UP + pi_P -pi_U) +
        P["theta_FP_F"].*( Q_FP - Q_FP + pi_P -pi_F) +
        P["theta_FP_P"].*( 0) 
        ) +
        (1-P["Inertia"])*P["beta"].*(pi_FP );
        eval = pi_FP
    end
    return eval
end
PC_FP_inputs = arg_name(PC_FP)

function PC_FU(P,Q_FU,Q_FU_m1,Q_FU_p1,Q_PU,Q_PU_m1,Q_PU_p1,pi_U,pi_F,pi_P,pi_U_p1,pi_F_p1,pi_P_p1,
P_F,P_U,p_FU,pi_FU,pi_FU_p1,W_F,MC_F,pi_FU_m1)

    eval = P["theta_FU_U"].*( 0) +
    P["theta_FU_F"].*( Q_FU - Q_FU_m1 + pi_U-pi_F) +
    P["theta_FU_P"].*( Q_PU - Q_PU_m1 + pi_U-pi_P) +
    - (pi_FU ) + 
    (1-P["beta"].*P["deltap"]).*(1-P["deltap"])./P["deltap"].*(Desired_price(P,MC_F,P_U,Ex_ij_fun(Q_FU,P_F,P_U))- P["F TFP shock"] - p_FU) +
    P["Inertia"]*pi_FU_m1

    if P["final"] != 1
        eval = eval + 
        -P["beta"].*(
            P["theta_FU_U"].*(0) +
            P["theta_FU_F"].*( Q_FU_p1 - Q_FU + pi_U_p1 - pi_F_p1) +
            P["theta_FU_P"].*( Q_PU_p1 - Q_PU + pi_U_p1 - pi_P_p1) 
        ) +
        (1-P["Inertia"])*P["beta"].*(pi_FU_p1 );
    else
        eval = eval + 
        -P["beta"].*(
            P["theta_FU_U"].*(0) +
            P["theta_FU_F"].*( Q_FU - Q_FU + pi_U - pi_F) +
            P["theta_FU_P"].*( Q_PU - Q_PU + pi_U - pi_P) 
        ) +
        (1-P["Inertia"])*P["beta"].*(pi_FU );
        eval = pi_FU
    end
    return eval
end
PC_FU_inputs = arg_name(PC_FU)

function PC_FF(P,Q_UF,Q_UF_m1,Q_UF_p1, pi_P, pi_U,pi_F,pi_P_p1, pi_U_p1,pi_F_p1, Q_PF, Q_PF_m1,Q_PF_p1,
W_F,p_FF,pi_FF,pi_FF_p1,P_F,MC_F,pi_FF_m1)

    eval = 
    P["theta_FF_U"].*( Q_UF - Q_UF_m1 + pi_F- pi_U) +
    P["theta_FF_F"].*( 0) +
    P["theta_FF_P"].*( Q_PF - Q_PF_m1 + pi_F-pi_P) +
    - (pi_FF ) + 
    (1-P["beta"].*P["deltap"]).*(1-P["deltap"])./P["deltap"].*(Desired_price(P,MC_F,P_F,0)- P["F TFP shock"] - p_FF) +
    P["Inertia"]*pi_FF_m1

    if P["final"] != 1
        eval = eval + 
        -P["beta"].*(
            P["theta_FF_U"].*( Q_UF_p1 - Q_UF + pi_F_p1 - pi_U_p1 ) +
            P["theta_FF_F"].*( 0) +
            P["theta_FF_P"].*( Q_PF_p1 - Q_PF + pi_F_p1 - pi_P_p1)
        ) +
        (1-P["Inertia"])*P["beta"].*(pi_FF_p1 );
    else
        eval = eval + 
        -P["beta"].*(
            P["theta_FF_U"].*( Q_UF - Q_UF + pi_F  - pi_U ) +
            P["theta_FF_F"].*( 0) +
            P["theta_FF_P"].*( Q_PF - Q_PF + pi_F - pi_P )
        ) +
        (1-P["Inertia"])*P["beta"].*(pi_FF );
        eval = pi_FF
    end
    return eval
end
PC_FF_inputs = arg_name(PC_FF)





function PC_FFown(P,Q_UF,Q_UF_m1,Q_UF_p1, pi_P, pi_U,pi_F,pi_P_p1, pi_U_p1,pi_F_p1, Q_PF, Q_PF_m1,Q_PF_p1,
    W_F,p_FFown,pi_FFown,pi_FFown_p1,P_F,MC_F,pi_FFown_m1)

    eval = 
    P["theta_FFown_U"].*( Q_UF - Q_UF_m1 + pi_F- pi_U) +
    P["theta_FFown_F"].*( 0) +
    P["theta_FFown_P"].*( Q_PF - Q_PF_m1 + pi_F-pi_P) +
    - (pi_FFown ) + 
    (1-P["beta"].*P["deltap"]).*(1-P["deltap"])./P["deltap"].*(Desired_price(P,MC_F,P_F,0) - P["F TFP shock"]- p_FFown) +
    P["Inertia"]*pi_FFown_m1

    if P["final"] != 1
        eval = eval + 
        -P["beta"].*(
            P["theta_FFown_U"].*( Q_UF_p1 - Q_UF + pi_F_p1 - pi_U_p1 ) +
            P["theta_FFown_F"].*( 0) +
            P["theta_FFown_P"].*( Q_PF_p1 - Q_PF + pi_F_p1 - pi_P_p1)
        ) +
        (1-P["Inertia"])*P["beta"].*(pi_FFown_p1 );
    else
        eval = eval + 
        -P["beta"].*(
            P["theta_FFown_U"].*( Q_UF - Q_UF + pi_F - pi_U) +
            P["theta_FFown_F"].*( 0) +
            P["theta_FFown_P"].*( Q_PF- Q_PF + pi_F - pi_P)
        ) +
        (1-P["Inertia"])*P["beta"].*(pi_FFown );
        eval = pi_FFown
    end
    return eval
end
PC_FFown_inputs = arg_name(PC_FFown)
    
###############################################
# Input Choice (3)
###############################################

function Input_X_U(P,MC_U,X_U,K_U,N_U,P_U)
    eval = MC_U +(1-P["omega"]-P["kappaK"])*N_U + (P["omega"]-1)*X_U + P["kappaK"]*K_U - P_U
    return eval
end
Input_X_U_inputs = arg_name(Input_X_U)

function Input_X_P(P,MC_P,X_P,K_P,N_P,P_P)
    eval = MC_P +(1-P["omega"]-P["kappaK"])*N_P + (P["omega"]-1)*X_P + P["kappaK"]*K_P - P_P

    return eval
end
Input_X_P_inputs = arg_name(Input_X_P)

function Input_X_F(P,MC_F,X_F,K_F,N_F,P_F)
    eval = MC_F +(1-P["omega"]-P["kappaK"])*N_F + (P["omega"]-1)*X_F + P["kappaK"]*K_F - P_F
    return eval
end
Input_X_F_inputs = arg_name(Input_X_F)

###############################################
# Input Choice, N (3)
###############################################

function Input_N_U(P,MC_U,X_U,K_U,N_U,W_U,N_U_p1,N_U_m1)
    eval = MC_U + (-P["omega"]-P["kappaK"])*N_U + (P["omega"])*X_U + P["kappaK"]*K_U - W_U +
    - P["SN"]*(N_U - N_U_m1) + P["beta"]*P["SN"]*(N_U_p1 - N_U)
    return eval
end
Input_N_U_inputs = arg_name(Input_N_U)

function Input_N_P(P,MC_P,X_P,K_P,N_P,W_P,N_P_p1,N_P_m1)
    eval = MC_P + (-P["omega"]-P["kappaK"])*N_P + (P["omega"])*X_P + P["kappaK"]*K_P - W_P +
    - P["SN"]*(N_P - N_P_m1) + P["beta"]*P["SN"]*(N_P_p1 - N_P)


    return eval
end
Input_N_P_inputs = arg_name(Input_N_P)

function Input_N_F(P,MC_F,X_F,K_F,N_F,W_F,N_F_p1,N_F_m1)
    eval = MC_F + (-P["omega"]-P["kappaK"])*N_F + (P["omega"])*X_F + P["kappaK"]*K_F - W_F + 
    - P["SN"]*(N_F - N_F_m1) + P["beta"]*P["SN"]*(N_F_p1 - N_F)

    return eval
end
Input_N_F_inputs = arg_name(Input_N_F)

###############################################
# Real Output
###############################################

RealY_U_def(P,W_U,N_U,P_U,D_U,r_U,RealY_U) = 
P["WNss"]/P["RealYss"]*(W_U + N_U - P_U) + P["rss"]*P["Kss"]/P["RealYss"]*D_U  - RealY_U;
RealY_U_def_inputs = arg_name(RealY_U_def)

RealY_P_def(P,W_P,N_P,P_P,D_P,r_P,RealY_P) = 
P["WNss"]/P["RealYss"]*(W_P + N_P - P_P) + P["rss"]*P["Kss"]/P["RealYss"]*D_P - RealY_P;
RealY_P_def_inputs = arg_name(RealY_P_def)

RealY_F_def(P,W_F,N_F,P_F,D_F,r_F,RealY_F) = 
P["WNss"]/P["RealYss"]*(W_F + N_F - P_F) + P["rss"]*P["Kss"]/P["RealYss"]*D_F- RealY_F;
RealY_F_def_inputs = arg_name(RealY_F_def)

###############################################
# Real  Income Income
###############################################

NFA_U_def(P,B_U,q_U,NFA_U) = 
B_U - NFA_U
NFA_U_def_inputs = arg_name(NFA_U_def)

NFA_P_def(P,B_P,q_P,NFA_P) = 
B_P - NFA_P
NFA_P_def_inputs = arg_name(NFA_P_def)

NFA_F_def(P,B_F,q_F,NFA_F) = 
B_F  - NFA_F
NFA_F_def_inputs = arg_name(NFA_F_def)



###############################################
# Real Labor Income
###############################################

RealWN_U_def(P,W_U,N_U,P_U,RealWN_U) = 
(W_U + N_U - P_U) - RealWN_U;
RealWN_U_def_inputs = arg_name(RealWN_U_def)

RealWN_P_def(P,W_P,N_P,P_P,RealWN_P) = 
(W_P + N_P - P_P) - RealWN_P;
RealWN_P_def_inputs = arg_name(RealWN_P_def)

RealWN_F_def(P,W_F,N_F,P_F,RealWN_F) = 
(W_F + N_F - P_F)  - RealWN_F;
RealWN_F_def_inputs = arg_name(RealWN_F_def)

###############################################
# Capital accumulation
###############################################

function K_U_def(P,K_U_m1,K_U,I_U_m1)
    if P["kappaK"] == 0 
        eval = K_U
    else
        eval = (1-P["deltaK"])*K_U_m1 + P["deltaK"]*I_U_m1 - K_U
    end
    return eval 
end
K_U_def_inputs = arg_name(K_U_def)

function K_P_def(P,K_P_m1,K_P,I_P_m1)
    if P["kappaK"] == 0 
        eval = K_P
    else
        eval  = (1-P["deltaK"])*K_P_m1 + P["deltaK"]*I_P_m1- K_P
    end
    return eval
end
K_P_def_inputs = arg_name(K_P_def)

function K_F_def(P,K_F_m1,K_F,I_F_m1)
    if P["kappaK"] == 0
        eval = K_F
    else
        eval =  (1-P["deltaK"])*K_F_m1 + P["deltaK"]*I_F_m1 - K_F
    end
end
K_F_def_inputs = arg_name(K_F_def)

###############################################
# Investment
###############################################

function I_U_def(P,QK_U,I_U,I_U_m1,I_U_p1)
    if P["kappaK"] == 0 ||  P["SI"] >= 1e3
        eval = I_U 
    else
        eval  = P["SI"]*(I_U - I_U_m1) - 1/(1+P["rss"]) * P["SI"]*(I_U_p1 - I_U) - P["QK"]*QK_U
    end
    if P["final2"] == 1
        eval  = P["SI"]*(I_U - I_U_m1) #- 1/(1+P["rss"]) * P["SI"]*(I_U - I_U_m1) - P["QK"]*QK_U
    end
    return eval
end
I_U_def_inputs = arg_name(I_U_def)

function I_P_def(P,QK_P,I_P,I_P_m1,I_P_p1)
    if P["kappaK"] == 0  || P["SI"] >= 1e3
        eval = I_P
    else
        eval  = P["SI"]*(I_P - I_P_m1)- 1/(1+P["rss"]) * P["SI"]*(I_P_p1 - I_P) - P["QK"]*QK_P
    end
    if P["final2"] == 1
        eval  = P["SI"]*(I_P - I_P_m1) #- 1/(1+P["rss"]) * P["SI"]*(I_P - I_P_m1) - P["QK"]*QK_P
    end
    return eval
end
I_P_def_inputs = arg_name(I_P_def)

function I_F_def(P,QK_F,I_F,I_F_m1,I_F_p1)
    if P["kappaK"] == 0 ||  P["SI"] >= 1e3
        eval = I_F
    else
        eval  = P["SI"]*(I_F - I_F_m1) - 1/(1+P["rss"]) * P["SI"]*(I_F_p1 - I_F)  - P["QK"]*QK_F
    end
    if P["final2"] == 1
        eval  = P["SI"]*(I_F - I_F_m1) #- 1/(1+P["rss"]) * P["SI"]*(I_F - I_F_m1)  - P["QK"]*QK_F
    end
    return eval
end
I_F_def_inputs = arg_name(I_F_def)

###############################################
# Tobin's Q
###############################################

function QK_U_def(P,MC_U_p1,N_U_p1,X_U_p1,K_U_p1,P_U_p1,r_U,QK_U_p1,QK_U,Profit_U_p1,rp_U_p1,
    Profit_U,rp_U,P_U,MC_U,N_U,X_U,K_U)
    MPK_p1 = MC_U_p1 + (1- P["omega"] - P["kappaK"])*N_U_p1 + P["omega"]*X_U_p1 + (P["kappaK"]-1)*K_U_p1
    if P["final"] == 1 || P["kappaK"] == 0 
        eval = QK_U
    else
        eval = (P["rss"]+P["deltaK"])/(1+P["rss"]) * (MPK_p1 + P["Kshare"]/(P["RKss"])*Profit_U_p1 - rp_U_p1  - P_U_p1) + 
            +(1-P["deltaK"])/(1+P["rss"])*P["QK"]*(- rp_U_p1 + QK_U_p1)  - QK_U
    end
    if P["final2"] == 1
        MPK = MC_U + (1- P["omega"] - P["kappaK"])*N_U + P["omega"]*X_U + (P["kappaK"]-1)*K_U
        eval = (P["rss"]+P["deltaK"])/(1+P["rss"]) * (MPK + P["Kshare"]/(P["RKss"])*Profit_U - rp_U  - P_U) + 
            +(1-P["deltaK"])/(1+P["rss"])*P["QK"]*(- rp_U + QK_U)  - QK_U

    end
    return eval

end
QK_U_def_inputs = arg_name(QK_U_def)

function QK_P_def(P,MC_P_p1,N_P_p1,X_P_p1,K_P_p1,P_P_p1,r_P,QK_P_p1,QK_P,Profit_P_p1,rp_P_p1,
    Profit_P,rp_P,P_P,MC_P,N_P,X_P,K_P)
    MPK_p1 = MC_P_p1 + (1- P["omega"] - P["kappaK"])*N_P_p1 + P["omega"]*X_P_p1 + (P["kappaK"]-1)*K_P_p1

    if P["final"] == 1 || P["kappaK"] == 0 
        eval = QK_P
    else
        eval = (P["rss"]+P["deltaK"])/(1+P["rss"]) * (MPK_p1 + P["Kshare"]/(P["RKss"])*Profit_P_p1 - rp_P_p1  - P_P_p1) + 
        +(1-P["deltaK"])/(1+P["rss"])*P["QK"]*(- rp_P_p1 + QK_P_p1)  - QK_P
    end
    if P["final2"] == 1
        MPK = MC_P + (1- P["omega"] - P["kappaK"])*N_P + P["omega"]*X_P + (P["kappaK"]-1)*K_P
        eval = (P["rss"]+P["deltaK"])/(1+P["rss"]) * (MPK + P["Kshare"]/(P["RKss"])*Profit_P - rp_P  - P_P) + 
            +(1-P["deltaK"])/(1+P["rss"])*P["QK"]*(- rp_P + QK_P)  - QK_P

    end
    return eval
end
QK_P_def_inputs = arg_name(QK_P_def)

function QK_F_def(P,MC_F_p1,N_F_p1,X_F_p1,K_F_p1,P_F_p1,r_F,QK_F_p1,QK_F,Profit_F_p1,rp_F_p1,
    Profit_F,rp_F,P_F,MC_F,N_F,X_F,K_F)

    MPK_p1 = MC_F_p1 + (1- P["omega"] - P["kappaK"])*N_F_p1 + P["omega"]*X_F_p1 + (P["kappaK"]-1)*K_F_p1

    if P["final"] == 1 || P["kappaK"] == 0 
        eval = QK_F
    else
        eval = (P["rss"]+P["deltaK"])/(1+P["rss"]) * (MPK_p1 + P["Kshare"]/(P["RKss"])*Profit_F_p1 - rp_F_p1  - P_F_p1) + 
        +(1-P["deltaK"])/(1+P["rss"])*P["QK"]*(- rp_F_p1 + QK_F_p1) - QK_F
    end
    if P["final2"] == 1
        MPK = MC_F + (1- P["omega"] - P["kappaK"])*N_F + P["omega"]*X_F + (P["kappaK"]-1)*K_F
        eval = (P["rss"]+P["deltaK"])/(1+P["rss"]) * (MPK + P["Kshare"]/(P["RKss"])*Profit_F - rp_F  - P_F) + 
            +(1-P["deltaK"])/(1+P["rss"])*P["QK"]*(- rp_F + QK_F)  - QK_F

    end
    return eval
end
QK_F_def_inputs = arg_name(QK_F_def)

###############################################
# Asset Price
###############################################
function rp_U_def(P,r_U,r_P,r_F,Q_FU_p1,Q_FU,Q_PU_p1,Q_PU,q_U,q_U_p1,Dk_U_p1)
    rp_U_p1_temp = 1/(P["Dss"]+P["qss"])*(P["Dss"]*Dk_U_p1 + P["qss"]*q_U_p1) - q_U

    r_UF = r_F + Q_FU_p1 - Q_FU + P["U Risk shock"]
    r_UP = r_P + Q_PU_p1 - Q_PU 
    r_UU = r_U

    if P["final2"] == 1
        r_UF = r_F + Q_FU - Q_FU + P["U Risk shock"]
        r_UP = r_P + Q_PU - Q_PU 
        r_UU = r_U
    end

    eval = P["s_UF"]*r_UF + P["s_UP"]*r_UP +  P["s_UU"]*r_UU - rp_U_p1_temp

    return eval
end
rp_U_def_inputs = arg_name(rp_U_def)

function rp_P_def(P,rp_P_p1,r_U,r_P,r_F,Q_FP_p1,Q_FP,Q_UP_p1,Q_UP,q_P,q_P_p1,Dk_P_p1)
    rp_P_p1_temp = 1/(P["Dss"]+P["qss"])*(P["Dss"]*Dk_P_p1 + P["qss"]*q_P_p1) - q_P

    r_PF = r_F + Q_FP_p1 - Q_FP
    r_PP = r_P
    r_PU = r_U + Q_UP_p1 - Q_UP

    if P["final2"] == 1
        r_PF = r_F + Q_FP  - Q_FP
        r_PP = r_P
        r_PU = r_U + Q_UP - Q_UP
    end
    eval = P["s_PF"]*r_PF + P["s_PP"]*r_PP +  P["s_PU"]*r_PU - rp_P_p1_temp

    return eval
end
rp_P_def_inputs = arg_name(rp_P_def)

function rp_F_def(P,rp_F_p1,r_U,r_P,r_F,Q_PF_p1,Q_PF,Q_UF_p1,Q_UF,q_F,q_F_p1,Dk_F_p1)
    rp_F_p1_temp = 1/(P["Dss"]+P["qss"])*(P["Dss"]*Dk_F_p1 + P["qss"]*q_F_p1) - q_F;

    r_FF = r_F 
    r_FP = r_P + Q_PF_p1 - Q_PF + P["F Risk shock"]
    r_FU = r_U + Q_UF_p1 - Q_UF + P["F Risk shock"]

    if P["final2"] == 1
        r_FF = r_F 
        r_FP = r_P + P["F Risk shock"]
        r_FU = r_U + P["F Risk shock"]
    end
    eval = P["s_FF"]*r_FF + P["s_FP"]*r_FP +  P["s_FU"]*r_FU - rp_F_p1_temp

    return eval
end
rp_F_def_inputs = arg_name(rp_F_def)


###############################################
# Portfolio Return
###############################################
function q_U_def(P,Dk_U,q_U_m1,q_U,rp_U)
    eval = 1/(P["qss"] + P["Dss"])*(P["Dss"]*Dk_U +  P["qss"]*q_U) - q_U_m1 -rp_U
    return eval
end
q_U_def_inputs = arg_name(q_U_def)

function q_P_def(P,Dk_P,q_P_m1,q_P,rp_P)
    eval = 1/(P["qss"] + P["Dss"])*(P["Dss"]*Dk_P + P["qss"]*q_P) - q_P_m1 -rp_P
    return eval
end
q_P_def_inputs = arg_name(q_P_def)

function q_F_def(P,Dk_F,q_F_m1,q_F,rp_F)
    eval = 1/(P["qss"] + P["Dss"])*(P["Dss"]*Dk_F + P["qss"]*q_F) - q_F_m1 -rp_F
    return eval
end
q_F_def_inputs = arg_name(q_F_def)


###############################################
# Definitions (9)
###############################################
pi_U_def(P,pi_U,P_U,P_U_m1) = pi_U - (P_U - P_U_m1);
pi_U_def_inputs = arg_name(pi_U_def)
pi_F_def(P,pi_F,P_F,P_F_m1) = pi_F - (P_F - P_F_m1);
pi_F_def_inputs = arg_name(pi_F_def)
pi_P_def(P,pi_P,P_P,P_P_m1) = pi_P - (P_P - P_P_m1);
pi_P_def_inputs = arg_name(pi_P_def)


pi_UU_def(P,pi_UU,p_UU,p_UU_m1) = pi_UU - (p_UU - p_UU_m1);
pi_UU_def_inputs = arg_name(pi_UU_def)
pi_UP_def(P,pi_UP,p_UP,p_UP_m1) = pi_UP - (p_UP - p_UP_m1);
pi_UP_def_inputs = arg_name(pi_UP_def)
pi_UF_def(P,pi_UF,p_UF,p_UF_m1) = pi_UF - (p_UF - p_UF_m1);
pi_UF_def_inputs = arg_name(pi_UF_def)

pi_PU_def(P,pi_PU,p_PU,p_PU_m1) = pi_PU - (p_PU - p_PU_m1);
pi_PU_def_inputs = arg_name(pi_PU_def)
pi_PP_def(P,pi_PP,p_PP,p_PP_m1) = pi_PP - (p_PP - p_PP_m1);
pi_PP_def_inputs = arg_name(pi_PP_def)
pi_PF_def(P,pi_PF,p_PF,p_PF_m1) = pi_PF - (p_PF - p_PF_m1);
pi_PF_def_inputs = arg_name(pi_PF_def)


pi_FU_def(P,pi_FU,p_FU,p_FU_m1) = pi_FU - (p_FU - p_FU_m1);
pi_FU_def_inputs = arg_name(pi_FU_def)
pi_FP_def(P,pi_FP,p_FP,p_FP_m1) = pi_FP - (p_FP - p_FP_m1);
pi_FP_def_inputs = arg_name(pi_FP_def)
pi_FF_def(P,pi_FF,p_FF,p_FF_m1) = pi_FF - (p_FF - p_FF_m1);
pi_FF_def_inputs = arg_name(pi_FF_def)
pi_FFown_def(P,pi_FFown,p_FFown,p_FFown_m1) = pi_FFown - (p_FFown - p_FFown_m1);
pi_FFown_def_inputs = arg_name(pi_FFown_def)



piW_U_def(P,piW_U,W_U,W_U_m1) = piW_U - (W_U - W_U_m1);
piW_U_def_inputs = arg_name(piW_U_def)
piW_P_def(P,piW_P,W_P,W_P_m1) = piW_P - (W_P - W_P_m1);
piW_P_def_inputs = arg_name(piW_P_def)
piW_F_def(P,piW_F,W_F,W_F_m1) = piW_F - (W_F - W_F_m1);
piW_F_def_inputs = arg_name(piW_F_def)


P_U_def(P,P_U,p_UU,p_PU,p_FU) = P_U - (P["lambdaUU"]*p_UU + P["lambdaPU"]*p_PU + P["lambdaFU"]*p_FU)
P_U_def_inputs = arg_name(P_U_def)
P_P_def(P,P_P,p_UP,p_PP,p_FP) = P_P - (P["lambdaUP"]*p_UP + P["lambdaPP"]*p_PP + P["lambdaFP"]*p_FP)
P_P_def_inputs = arg_name(P_P_def)
P_F_def(P,P_F,p_UF,p_PF,p_FF,p_FFown) = P_F - (P["lambdaUF"]*p_UF + P["lambdaPF"]*p_PF + P["lambdaFF"]*p_FF + P["lambdaFFown"]*p_FFown)
P_F_def_inputs = arg_name(P_F_def)



PT_U_def(P,PT_U,p_UU,p_PU,p_FU) = PT_U - (P["lambdaUU_T"]*p_UU + P["lambdaPU_T"]*p_PU + P["lambdaFU_T"]*p_FU)
PT_U_def_inputs = arg_name(PT_U_def)
PT_P_def(P,PT_P,p_UP,p_PP,p_FP) = PT_P - (P["lambdaUP_T"]*p_UP + P["lambdaPP_T"]*p_PP + P["lambdaFP_T"]*p_FP)
PT_P_def_inputs = arg_name(PT_P_def)
PT_F_def(P,PT_F,p_UF,p_PF,p_FF,p_FFown) = PT_F - (P["lambdaUF_T"]*p_UF + P["lambdaPF_T"]*p_PF + P["lambdaFF_T"]*p_FF + P["lambdaFFown_T"]*p_FFown)
PT_F_def_inputs = arg_name(PT_F_def)


Q_UF_def(P,Q_UF,Q_FU) = Q_UF + Q_FU
Q_UF_def_inputs = arg_name(Q_UF_def)
Q_UP_def(P,Q_UP,Q_PU) = Q_UP + Q_PU
Q_UP_def_inputs = arg_name(Q_UP_def)
Q_PF_def(P,Q_PF,Q_FP) = Q_PF + Q_FP
Q_PF_def_inputs = arg_name(Q_PF_def)

# so we have 42 equations
# how many unkowns do we have?
# C_U,C_P,C_F
# W_U, W_P, W_F
# Q_PU, Q_PF, Q_UP, Q_UF, Q_FP, Q_FU
# dQ_PU, dQ_PF, dQ_UP, dQ_UF, dQ_FP, dQ_FU
# B_U, B_P , B_F
# i_U, i_P, i_F
# N_U, N_P , N_F
# p_FP, p_FU, p_FF, p_UP, p_UF, p_UU, p_PP, p_PU, p_PF
# pi_U, pi_F, pi_P
# P_U, P_F, P_P
# Cr_U,Cr_P,Cr_F
# Ch_U,Ch_P,Ch_F
# yes, 36 unkowns


allinputs_string = "C_U,C_P,C_F,W_U,W_P,W_F,Q_PU,Q_PF,Q_UP,Q_UF,
Q_FP,Q_FU,B_U,B_P,B_F,i_U,i_P,i_F,N_U,N_P,N_F,
p_FP,p_FU,p_FF,p_FFown,p_UP,
p_UF,p_UU,p_PP,p_PU,p_PF,pi_U,pi_F,pi_P,
P_U,P_F,P_P,
r_U,r_P,r_F,X_U,X_P,X_F,
I_U,I_P,I_F,K_U,K_P,K_F,MC_U,MC_P,MC_F,
QK_U,QK_P,QK_F,NFA_U,NFA_P,NFA_F,
pi_FP,pi_FU,pi_FF,pi_FFown,pi_UP,
pi_UF,pi_UU,pi_PP,pi_PU,pi_PF,
piW_U,piW_P,piW_F,
RealWN_U,RealWN_P,RealWN_F,
Cr_U,Cr_P,Cr_F,
Ch_U,Ch_P,Ch_F,
RealY_U,RealY_P,RealY_F,
D_U,D_P,D_F,
target_UU,target_UP,target_UF,
target_PU,target_PP,target_PF,
target_FU,target_FP,target_FF,target_FFown,
ratio_UU,ratio_UP,ratio_UF,
ratio_PU,ratio_PP,ratio_PF,
ratio_FU,ratio_FP,ratio_FF,ratio_FFown,
q_U,q_P,q_F,
rp_U,rp_P,rp_F,
A_U,A_P,A_F,
Dk_U,Dk_P,Dk_F,
Profit_U,Profit_P,Profit_F,
Bflow_FU,Bflow_PF,
MUr_U,MUr_P,MUr_F,
MUh_U,MUh_P,MUh_F,
PT_U,PT_P,PT_F"




varargin = [
    C_U_def,C_U_def_inputs,
    C_P_def,C_P_def_inputs,
    C_F_def,C_F_def_inputs,
    wp_U,wp_U_inputs,
    wp_P,wp_P_inputs,
    wp_F,wp_F_inputs,
    UIP_FU,UIP_FU_inputs,
    UIP_PF,UIP_PF_inputs,
    UIP_UP,UIP_UP_inputs,
    BC_U,BC_U_inputs,
    BC_P,BC_P_inputs,
    BC_F,BC_F_inputs,
    MP_U,MP_U_inputs,
    MP_P,MP_P_inputs,
    MP_F,MP_F_inputs,
    GC_U,GC_U_inputs,
    GC_P,GC_P_inputs,
    GC_F,GC_F_inputs,
    PC_UP,PC_UP_inputs,
    PC_UU,PC_UU_inputs,
    PC_UF,PC_UF_inputs,
    PC_PP,PC_PP_inputs,
    PC_PF,PC_PF_inputs,
    PC_PU,PC_PU_inputs,
    PC_FP,PC_FP_inputs,
    PC_FU,PC_FU_inputs,
    PC_FF,PC_FF_inputs,
    PC_FFown,PC_FFown_inputs,
    pi_U_def,pi_U_def_inputs,
    pi_P_def,pi_P_def_inputs,
    pi_F_def,pi_F_def_inputs,
    P_U_def,P_U_def_inputs,
    P_P_def,P_P_def_inputs,
    P_F_def,P_F_def_inputs,
    Q_UF_def,Q_UF_def_inputs,
    Q_UP_def,Q_UP_def_inputs,
    Q_PF_def,Q_PF_def_inputs,
    r_U_def,r_U_def_inputs,
    r_P_def,r_P_def_inputs,
    r_F_def,r_F_def_inputs,
    Input_X_U, Input_X_U_inputs,
    Input_X_P, Input_X_P_inputs,
    Input_X_F, Input_X_F_inputs,
    I_U_def, I_U_def_inputs,
    I_P_def, I_P_def_inputs,
    I_F_def, I_F_def_inputs,
    K_U_def, K_U_def_inputs,
    K_P_def, K_P_def_inputs,
    K_F_def, K_F_def_inputs,
    Input_N_U, Input_N_U_inputs,
    Input_N_P, Input_N_P_inputs,
    Input_N_F, Input_N_F_inputs,
    QK_U_def, QK_U_def_inputs,
    QK_P_def, QK_P_def_inputs,
    QK_F_def, QK_F_def_inputs,
    NFA_U_def, NFA_U_def_inputs,
    NFA_P_def, NFA_P_def_inputs,
    NFA_F_def, NFA_F_def_inputs,
    pi_UU_def,pi_UU_def_inputs,
    pi_UP_def,pi_UP_def_inputs,
    pi_UF_def,pi_UF_def_inputs,
    pi_FU_def,pi_FU_def_inputs,
    pi_FP_def,pi_FP_def_inputs,
    pi_FF_def,pi_FF_def_inputs,
    pi_FFown_def,pi_FFown_def_inputs,
    pi_PU_def,pi_PU_def_inputs,
    pi_PP_def,pi_PP_def_inputs,
    pi_PF_def,pi_PF_def_inputs,
    piW_U_def,piW_U_def_inputs,
    piW_P_def,piW_P_def_inputs,
    piW_F_def,piW_F_def_inputs,
    RealWN_U_def, RealWN_U_def_inputs,
    RealWN_P_def, RealWN_P_def_inputs,
    RealWN_F_def, RealWN_F_def_inputs,
    Cr_U_def,Cr_U_def_inputs,
    Cr_P_def,Cr_P_def_inputs,
    Cr_F_def,Cr_F_def_inputs,
    Ch_U_def,Ch_U_def_inputs,
    Ch_P_def,Ch_P_def_inputs,
    Ch_F_def,Ch_F_def_inputs,
    RealY_U_def, RealY_U_def_inputs,
    RealY_P_def, RealY_P_def_inputs,
    RealY_F_def, RealY_F_def_inputs,
    D_U_def,D_U_def_inputs,
    D_P_def,D_P_def_inputs,
    D_F_def,D_F_def_inputs,
    target_ratio_UU,target_ratio_UU_inputs,
    target_ratio_UP,target_ratio_UP_inputs,
    target_ratio_UF,target_ratio_UF_inputs,
    target_ratio_PU,target_ratio_PU_inputs,
    target_ratio_PP,target_ratio_PP_inputs,
    target_ratio_PF,target_ratio_PF_inputs,
    target_ratio_FU,target_ratio_FU_inputs,
    target_ratio_FP,target_ratio_FP_inputs,
    target_ratio_FF,target_ratio_FF_inputs,
    target_ratio_FFown,target_ratio_FFown_inputs,
    eqm_ratio_UU,eqm_ratio_UU_inputs,
    eqm_ratio_UP,eqm_ratio_UP_inputs,
    eqm_ratio_UF,eqm_ratio_UF_inputs,
    eqm_ratio_PU,eqm_ratio_PU_inputs,
    eqm_ratio_PP,eqm_ratio_PP_inputs,
    eqm_ratio_PF,eqm_ratio_PF_inputs,
    eqm_ratio_FU,eqm_ratio_FU_inputs,
    eqm_ratio_FP,eqm_ratio_FP_inputs,
    eqm_ratio_FF,eqm_ratio_FF_inputs,
    eqm_ratio_FFown,eqm_ratio_FFown_inputs,
    q_U_def,q_U_def_inputs,
    q_P_def,q_P_def_inputs,
    q_F_def,q_F_def_inputs,
    rp_U_def,rp_U_def_inputs,
    rp_P_def,rp_P_def_inputs,
    rp_F_def,rp_F_def_inputs,
    A_U_def,A_U_def_inputs,
    A_P_def,A_P_def_inputs,
    A_F_def,A_F_def_inputs,
    Dk_U_def,Dk_U_def_inputs,
    Dk_P_def,Dk_P_def_inputs,
    Dk_F_def,Dk_F_def_inputs,
    Profit_U_def,Profit_U_def_inputs,
    Profit_P_def,Profit_P_def_inputs,
    Profit_F_def,Profit_F_def_inputs,
    Bflow_FU_def,Bflow_FU_def_inputs,
    Bflow_PF_def,Bflow_PF_def_inputs,
    MUr_U_def,MUr_U_def_inputs,
    MUr_P_def,MUr_P_def_inputs,
    MUr_F_def,MUr_F_def_inputs,
    MUh_U_def,MUh_U_def_inputs,
    MUh_P_def,MUh_P_def_inputs,
    MUh_F_def,MUh_F_def_inputs,
    PT_U_def,PT_U_def_inputs,
    PT_P_def,PT_P_def_inputs,
    PT_F_def,PT_F_def_inputs
    ]
    


references = process_inputs(allinputs_string,varargin)
n = length(references)

ss0 = zeros(n)
ss1 = zeros(n)
varargin_eq = varargin[1:2:end]





varargin_ss = [
    C_U_def,C_U_def_inputs,
    C_P_def,C_P_def_inputs,
    C_F_def,C_F_def_inputs,
    wp_U,wp_U_inputs,
    wp_P,wp_P_inputs,
    wp_F,wp_F_inputs,
    UIP_FU_ss,UIP_FU_ss_inputs,
    UIP_PF_ss,UIP_PF_ss_inputs,
    UIP_UP_ss,UIP_UP_ss_inputs,
    BC_U,BC_U_inputs,
    BC_P,BC_P_inputs,
    BC_F,BC_F_inputs,
    MP_U_ss,MP_U_ss_inputs,
    MP_P_ss,MP_P_ss_inputs,
    MP_F_ss,MP_F_ss_inputs,
    GC_U,GC_U_inputs,
    GC_P,GC_P_inputs,
    GC_F,GC_F_inputs,
    PC_UP,PC_UP_inputs,
    PC_UU,PC_UU_inputs,
    PC_UF,PC_UF_inputs,
    PC_PP,PC_PP_inputs,
    PC_PF,PC_PF_inputs,
    PC_PU,PC_PU_inputs,
    PC_FP,PC_FP_inputs,
    PC_FU,PC_FU_inputs,
    PC_FF,PC_FF_inputs,
    PC_FFown,PC_FFown_inputs,
    pi_U_def,pi_U_def_inputs,
    pi_P_def,pi_P_def_inputs,
    pi_F_def,pi_F_def_inputs,
    P_U_def,P_U_def_inputs,
    P_P_def,P_P_def_inputs,
    P_F_def,P_F_def_inputs,
    Q_UF_def,Q_UF_def_inputs,
    Q_UP_def,Q_UP_def_inputs,
    Q_PF_def,Q_PF_def_inputs,
    r_U_def,r_U_def_inputs,
    r_P_def,r_P_def_inputs,
    r_F_def,r_F_def_inputs,
    Input_X_U, Input_X_U_inputs,
    Input_X_P, Input_X_P_inputs,
    Input_X_F, Input_X_F_inputs,
    I_U_def, I_U_def_inputs,
    I_P_def, I_P_def_inputs,
    I_F_def, I_F_def_inputs,
    K_U_def, K_U_def_inputs,
    K_P_def, K_P_def_inputs,
    K_F_def, K_F_def_inputs,
    Input_N_U, Input_N_U_inputs,
    Input_N_P, Input_N_P_inputs,
    Input_N_F, Input_N_F_inputs,
    QK_U_def, QK_U_def_inputs,
    QK_P_def, QK_P_def_inputs,
    QK_F_def, QK_F_def_inputs,
    NFA_U_def, NFA_U_def_inputs,
    NFA_P_def, NFA_P_def_inputs,
    NFA_F_def, NFA_F_def_inputs,
    pi_UU_def,pi_UU_def_inputs,
    pi_UP_def,pi_UP_def_inputs,
    pi_UF_def,pi_UF_def_inputs,
    pi_FU_def,pi_FU_def_inputs,
    pi_FP_def,pi_FP_def_inputs,
    pi_FF_def,pi_FF_def_inputs,
    pi_FFown_def,pi_FFown_def_inputs,
    pi_PU_def,pi_PU_def_inputs,
    pi_PP_def,pi_PP_def_inputs,
    pi_PF_def,pi_PF_def_inputs,
    piW_U_def,piW_U_def_inputs,
    piW_P_def,piW_P_def_inputs,
    piW_F_def,piW_F_def_inputs,
    RealWN_U_def, RealWN_U_def_inputs,
    RealWN_P_def, RealWN_P_def_inputs,
    RealWN_F_def, RealWN_F_def_inputs,
    Cr_U_def,Cr_U_def_inputs,
    Cr_P_def,Cr_P_def_inputs,
    Cr_F_def,Cr_F_def_inputs,
    Ch_U_def,Ch_U_def_inputs,
    Ch_P_def,Ch_P_def_inputs,
    Ch_F_def,Ch_F_def_inputs,
    RealY_U_def, RealY_U_def_inputs,
    RealY_P_def, RealY_P_def_inputs,
    RealY_F_def, RealY_F_def_inputs,
    D_U_def,D_U_def_inputs,
    D_P_def,D_P_def_inputs,
    D_F_def,D_F_def_inputs,
    target_ratio_UU,target_ratio_UU_inputs,
    target_ratio_UP,target_ratio_UP_inputs,
    target_ratio_UF,target_ratio_UF_inputs,
    target_ratio_PU,target_ratio_PU_inputs,
    target_ratio_PP,target_ratio_PP_inputs,
    target_ratio_PF,target_ratio_PF_inputs,
    target_ratio_FU,target_ratio_FU_inputs,
    target_ratio_FP,target_ratio_FP_inputs,
    target_ratio_FF,target_ratio_FF_inputs,
    target_ratio_FFown,target_ratio_FFown_inputs,
    eqm_ratio_UU,eqm_ratio_UU_inputs,
    eqm_ratio_UP,eqm_ratio_UP_inputs,
    eqm_ratio_UF,eqm_ratio_UF_inputs,
    eqm_ratio_PU,eqm_ratio_PU_inputs,
    eqm_ratio_PP,eqm_ratio_PP_inputs,
    eqm_ratio_PF,eqm_ratio_PF_inputs,
    eqm_ratio_FU,eqm_ratio_FU_inputs,
    eqm_ratio_FP,eqm_ratio_FP_inputs,
    eqm_ratio_FF,eqm_ratio_FF_inputs,
    eqm_ratio_FFown,eqm_ratio_FFown_inputs,
    q_U_def,q_U_def_inputs,
    q_P_def,q_P_def_inputs,
    q_F_def,q_F_def_inputs,
    rp_U_def,rp_U_def_inputs,
    rp_P_def,rp_P_def_inputs,
    rp_F_def,rp_F_def_inputs,
    A_U_def,A_U_def_inputs,
    A_P_def,A_P_def_inputs,
    A_F_def,A_F_def_inputs,
    Dk_U_def,Dk_U_def_inputs,
    Dk_P_def,Dk_P_def_inputs,
    Dk_F_def,Dk_F_def_inputs,
    Profit_U_def,Profit_U_def_inputs,
    Profit_P_def,Profit_P_def_inputs,
    Profit_F_def,Profit_F_def_inputs,
    Bflow_FU_def,Bflow_FU_def_inputs,
    Bflow_PF_def,Bflow_PF_def_inputs,
    MUr_U_def,MUr_U_def_inputs,
    MUr_P_def,MUr_P_def_inputs,
    MUr_F_def,MUr_F_def_inputs,
    MUh_U_def,MUh_U_def_inputs,
    MUh_P_def,MUh_P_def_inputs,
    MUh_F_def,MUh_F_def_inputs,
    PT_U_def,PT_U_def_inputs,
    PT_P_def,PT_P_def_inputs,
    PT_F_def,PT_F_def_inputs
    ]
references_ss = process_inputs(allinputs_string,varargin_ss)
varargin_eq_ss = varargin_ss[1:2:end]
