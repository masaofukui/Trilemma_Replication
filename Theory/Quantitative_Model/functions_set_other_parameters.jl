



function set_parameters_fun(eta,phipi,deltap,
    theta_U_to_F_dollar,theta_F_to_U_dollar,theta_F_to_F_dollar,
    alph,rhom,
    param_predetermined,deltaw,GammaB,GammaD,GammaI,HtMshare,delay,SI,smallopen,P_Taylor,habit,
    flow_adj,sig,SN,F_fix,Tradable_share,T_NT_elasticity,s_share, SS)
   
    @unpack nu,rss,beta,Ushare,Pshare,Fshare,phiY,
    kappaK,deltaK,omega,zeta,phiRisk,Inertia,
    dynamic_trade_elas,T,sigw = param_predetermined
    @unpack WNss,Yss,Kss,Css,Iss,Xss,QK,Dss,qss = SS

    if smallopen > 0 
        Fshare = smallopen;
        Ushare = 1- Fshare-Pshare;
    end

    P = Dict([
        ("U MP shock",0.0)
        ("U UIP shock",0.0)
        ("F UIP shock",0.0)
        ("P UIP shock",0.0)
        ("U TFP shock",0.0)
        ("U Demand shock",0.0)
        ("U Investment shock",0.0)
        ("U Risk shock",0.0)
        ("F MP shock",0.0)
        ("F TFP shock",0.0)
        ("F Demand shock",0.0)
        ("F Investment shock",0.0)
        ("F Risk shock",0.0)
        ("P MP shock",0.0)
        ("P TFP shock",0.0)
        ("P Demand shock",0.0)
        ("P Investment shock",0.0)
        ("P Risk shock",0.0)
        ("Common TFP shock",0.0)
        ("Common Demand shock",0.0)
        ("U TFPI shock",0.0)
        ("F TFPI shock",0.0)
        ("P TFPI shock",0.0)
        ])

    P["eta"] = eta;
    P["phipi"] = phipi;
    P["deltap"] = deltap;
    P["rhom"] = rhom
    P["phiY"] = phiY;
    P["delay"] = delay
    P["alph"] = alph;
    P["zeta"] = zeta
    P["habit"] = habit
    P["sigw"] = sigw;
    
    P["phiRisk"] = phiRisk

    P["sig"] = sig;
    P["deltaw"] = deltaw;
    P["nu"] = nu;
    P["GammaB"] = GammaB;
    P["GammaD"] = GammaD;
    P["GammaI"] = GammaI;
    P["rss"] = rss;
    P["Dss"] = Dss;
    P["qss"] = qss;
    P["HtMshare"] = HtMshare;
    P["Kshare"] = kappaK/(1-omega)
    P["Kshare"] = 1.0;
    P["Lshare"] = 1 - P["Kshare"]
    P["flow_adj"] = flow_adj;
    P["SN"] = SN;
    P["F_fix"] = F_fix

    P["Tradable_share"] = Tradable_share;
    P["T_NT_elasticity"] = T_NT_elasticity;


    Crss = (rss*Kss)./(1-HtMshare) + WNss
    Chss = WNss

    P["HtMcshare"] = HtMshare*Chss/((1-HtMshare)*Crss + (HtMshare)*Chss);
    MUfun(C) = (C*(1-habit))^(-sigw) - habit*(C*(1-habit))^(-sigw)
    P["HtMdushare"] = HtMshare*MUfun(Chss)./(HtMshare*MUfun(Chss) + (1-HtMshare)*MUfun(Crss));
    P["Crss"] = Crss;
    P["ass"] = qss./(1-HtMshare)


    
    P["beta"] = beta;
    P["rhom"] = rhom;
    P["Ushare"] = Ushare;
    P["Pshare"] = Pshare;
    P["Fshare"] = Fshare;


    P["omega"] = omega;
    P["deltaK"] = deltaK;
    P["kappaK"] = kappaK;
    P["WNss"] = WNss;

    P["Yss"] = Yss;
    P["Xss"] = Xss;
    P["Kss"] = Kss;
    P["Iss"] = Iss;
    P["Css"] = Css;
    P["RealYss"] = WNss + rss*(Kss)
    P["RealYrss"] = WNss + rss*(Kss)/(1-HtMshare)

    P["RKss"] = (P["rss"] + P["deltaK"])*Kss;


    P["rKss"] = rss*(Kss )
    P["GDPss"] = Css + Iss
    P["EXPss"] = Tradable_share*alph*(Css + Iss + Xss)
    P["IMPss"] = Tradable_share*alph*(Css + Iss + Xss)

    P["Inertia"] = Inertia
    P["SI"] = SI;
    P["QK"] = QK

    theta_UU_U = 1;
    theta_UU_F = 0;
    theta_UU_P = 0;

    theta_FFown_U = 0;
    theta_FFown_F = 1;
    theta_FFown_P = 0;


    theta_PP_U = 0;
    theta_PP_F = 0;
    theta_PP_P = 1;

    
    theta_UP_U = 1;
    theta_UP_F = 0;
    theta_UP_P = 0;

    # origin P
    theta_PU_U = 1;
    theta_PU_F = 0;
    theta_PU_P = 0;
    #=
    if smallopen == 1
        theta_PU_U = 0;
        theta_PU_F = 1;
        theta_PU_P = 0;
    end
    =#

    theta_UF_P = 0;
    theta_FU_P = 0;
    theta_FP_P = 0;
    theta_PF_P = 0;
    theta_FF_P = 0;


    P["theta_UU_U"] = theta_UU_U;
    P["theta_UU_F"] = theta_UU_F;
    P["theta_UU_P"] = theta_UU_P;
    P["theta_FFown_U"] = theta_FFown_U;
    P["theta_FFown_F"] = theta_FFown_F;
    P["theta_FFown_P"] = theta_FFown_P;
    P["theta_PP_U"] = theta_PP_U;
    P["theta_PP_F"] = theta_PP_F;
    P["theta_PP_P"] = theta_PP_P;
    P["theta_UP_U"] = theta_UP_U;
    P["theta_UP_F"] = theta_UP_F;
    P["theta_UP_P"] = theta_UP_P;
    P["theta_PU_U"] = theta_PU_U;
    P["theta_PU_F"] = theta_PU_F;
    P["theta_PU_P"] = theta_PU_P;
    P["theta_UF_P"] = theta_UF_P;
    P["theta_FU_P"] = theta_FU_P;
    P["theta_FP_P"] = theta_FP_P;
    P["theta_PF_P"] = theta_PF_P;
    P["theta_FF_P"] = theta_FF_P;



    chiUF = Tradable_share* alph*Fshare;
    chiUP = Tradable_share* alph*Pshare;
    chiUU = 1 - chiUF - chiUP;

    chiPU = Tradable_share* alph*Ushare;
    chiPF = Tradable_share* alph*Fshare;
    chiPP = 1- chiPU - chiPF;

    chiFU = Tradable_share* alph*Ushare;
    chiFP = Tradable_share* alph*Pshare;
    chiFF = Tradable_share* alph*Fshare;
    chiFFown = 1 - chiFU - chiFP - chiFF;


    chiUF_T =  alph*Fshare;
    chiUP_T =  alph*Pshare;
    chiUU_T = 1 - chiUF_T - chiUP_T;

    chiPU_T =  alph*Ushare;
    chiPF_T =  alph*Fshare;
    chiPP_T = 1- chiPU_T - chiPF_T;

    chiFU_T =  alph*Ushare;
    chiFP_T =  alph*Pshare;
    chiFF_T =  alph*Fshare;
    chiFFown_T = 1 - chiFU_T - chiFP_T - chiFF_T;



    lambdaUF = Tradable_share* alph*Ushare;
    lambdaPF = Tradable_share* alph*Pshare;
    lambdaFF = Tradable_share* alph*Fshare ;
    lambdaFFown = 1 - lambdaUF - lambdaPF - lambdaFF;

    lambdaPU = Tradable_share* alph*Pshare;
    lambdaFU = Tradable_share* alph*Fshare;
    lambdaUU = 1-lambdaPU - lambdaFU;

    lambdaUP = Tradable_share* alph*Ushare;
    lambdaFP = Tradable_share* alph*Fshare;
    lambdaPP = 1-lambdaUP - lambdaFP;


    lambdaUF_T = alph*Ushare;
    lambdaPF_T = alph*Pshare;
    lambdaFF_T = alph*Fshare ;
    lambdaFFown_T = 1 - lambdaUF_T - lambdaPF_T - lambdaFF_T;

    lambdaPU_T = alph*Pshare;
    lambdaFU_T = alph*Fshare;
    lambdaUU_T = 1-lambdaPU_T - lambdaFU_T;

    lambdaUP_T = alph*Ushare;
    lambdaFP_T = alph*Fshare;
    lambdaPP_T = 1-lambdaUP_T - lambdaFP_T;



    #theta_ij_k
    # origin U
    theta_UF_U = theta_U_to_F_dollar;
    theta_UF_F = 1 - theta_U_to_F_dollar;

    # origin F
    theta_FU_U = theta_F_to_U_dollar;
    theta_FU_F = 1-theta_F_to_U_dollar;

    theta_FP_U = theta_F_to_U_dollar;
    theta_FP_F = 1 - theta_F_to_U_dollar;

    # origin P

    theta_PF_U = theta_U_to_F_dollar;
    theta_PF_F = 1 - theta_U_to_F_dollar;

    theta_FF_U = theta_F_to_F_dollar;
    theta_FF_F = 1 - theta_F_to_F_dollar;

    #=
    if smallopen == 1
        theta_FP_U = 0;
        theta_FP_F = 1 ;    
        theta_PF_U = 0;
        theta_PF_F = 1;
    end
    =#

    P["chiUF"] = chiUF
    P["chiUP"] = chiUP
    P["chiUU"] = chiUU
    P["chiPU"] = chiPU 
    P["chiPF"] = chiPF
    P["chiPP"] = chiPP
    P["chiFU"] = chiFU
    P["chiFP"] = chiFP
    P["chiFF"] = chiFF
    P["chiFFown"] = chiFFown

    P["chiUF_T"] = chiUF_T
    P["chiUP_T"] = chiUP_T
    P["chiUU_T"] = chiUU_T
    P["chiPU_T"] = chiPU_T
    P["chiPF_T"] = chiPF_T
    P["chiPP_T"] = chiPP_T
    P["chiFU_T"] = chiFU_T
    P["chiFP_T"] = chiFP_T
    P["chiFF_T"] = chiFF_T
    P["chiFFown_T"] = chiFFown_T
    
    P["lambdaUF"] = lambdaUF
    P["lambdaPF"] = lambdaPF
    P["lambdaFF"] = lambdaFF
    P["lambdaFFown"] = lambdaFFown
    P["lambdaPU"] = lambdaPU
    P["lambdaFU"] = lambdaFU
    P["lambdaUU"]= lambdaUU
    P["lambdaUP"] = lambdaUP
    P["lambdaFP"] = lambdaFP
    P["lambdaPP"] = lambdaPP

    P["lambdaUF_T"] = lambdaUF_T
    P["lambdaPF_T"] = lambdaPF_T
    P["lambdaFF_T"] = lambdaFF_T
    P["lambdaFFown_T"] = lambdaFFown_T
    P["lambdaPU_T"] = lambdaPU_T
    P["lambdaFU_T"] = lambdaFU_T
    P["lambdaUU_T"]= lambdaUU_T
    P["lambdaUP_T"] = lambdaUP_T
    P["lambdaFP_T"] = lambdaFP_T
    P["lambdaPP_T"] = lambdaPP_T
    
    P["theta_UF_U"] = theta_UF_U
    P["theta_UF_F"] = theta_UF_F
    P["theta_FU_U"] = theta_FU_U
    P["theta_FU_F"] = theta_UF_F
    P["theta_FU_U"] = theta_FU_U
    P["theta_FU_F"] = theta_FU_F 
    P["theta_FP_U"] = theta_FP_U
    P["theta_FP_F"] = theta_FP_F
    P["theta_PF_U"] = theta_PF_U
    P["theta_PF_F"] = theta_PF_F
    P["theta_FF_U"] = theta_FF_U 
    P["theta_FF_F"] = theta_FF_F
    P["phiEx_F"] = phiEx_F
    P["phiEx_P"] = phiEx_P
    P["P_Taylor"] = P_Taylor


    P["s_UU"] = 1-s_share 
    P["s_UP"] = 0.0
    P["s_UF"] = s_share

    P["s_PU"] = 0.0;
    P["s_PP"] = 1-s_share
    P["s_PF"] = s_share

    P["s_FU"] = s_share*Ushare/(Pshare + Ushare)
    P["s_FP"] = s_share*Pshare/(Pshare + Ushare)

    P["s_FF"] = 1 - s_share 

    P["s_own"] = 1-s_share;
    P["s_FF_others"] =  s_share*Fshare;
    P["s_share"] = s_share

    if smallopen == 1
        P["s_UU"] = 1 
        P["s_UP"] = 0.0
        P["s_UF"] = 0.0
    
        P["s_PU"] = 0.0;
        P["s_PP"] = 1
        P["s_PF"] = 0.0;
    
    end

    return P
    
end




