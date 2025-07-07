using Debugger
using SparseArrays
using Plots
using DelimitedFiles
using DataFrames
using LinearAlgebra
using JLD
using Optim
using NLsolve
using Statistics
using Printf
using LaTeXStrings
using Plots.PlotMeasures
file_overleaf = "./figures"
tables_overleaf = "./tables"
stored_results = "Empirics/Stored_Result"
include("./Sequence_Space_Solver_HANK.jl")
include("load_data.jl")
include("./plot_fun.jl")
include("./solve_ss.jl")
include("./cov_fun.jl")

estimate_param = 0;
explosive_off= 0;
data_irf = data_load()
# set Parameters
sig = 0.5;
sigw = copy(sig);
deltaw = 0.95;
nu = 2;
rss = 0.04;
beta  = 1/(1+rss);

GammaB = 0.001;
GammaD = 2.090;
GammaI = 1.30*beta

# Original result
s_share = 0.24;

pricing = "free"
trate = 0.06
fig_save = 0;
Ushare = 0.3;
Fshare = 0.5;
Pshare = 1-Ushare-Fshare;
HtMshare = 0.0;
habit = 0.5;
flow_adj = 1.0;
SN = 0;


Tradable_share = 1.0;
T_NT_elasticity = 1.0;

dynamic_trade_elas = 0;

phiY = 0.0;
phiEx_P = 0;
phiEx_F = 0.0;
phiRisk = 0.0;
P_Taylor = 0;
F_fix = 0;

smallopen = 0;
#intermediate inputs share
omega = 0.5;
#strategic complementarity
zeta = 0.0;

Inertia = 0.0;

investment = 1;
if investment == 1
    kappaK = 0.43*(1-omega)
    SI = 2.0;
else
    kappaK = 0;
    SI = 1e10;
end

#Inattention
Inattention = 0.0;
Auclert_inattention = 0;

delay = 0.0;

deltaK = 0.04;
scaling = "matchIRF"
scaling = "matchRER"

T = 100;

param_predetermined = (
    nu = nu,
    rss = rss,
    beta = beta,
    Ushare = Ushare,
    Pshare = Pshare,
    Fshare = Fshare,
    phiY = phiY,
    phiEx_F = phiEx_F,
    phiEx_P = phiEx_P,
    kappaK = kappaK,
    deltaK = deltaK,
    omega = omega,
    zeta = zeta,
    phiRisk = phiRisk,
    Inertia = Inertia,
    dynamic_trade_elas = dynamic_trade_elas,
    T = T,
    HtMshare = HtMshare,
    delay = delay,
    sigw = sigw
)

SS = solve_ss(param_predetermined)
@unpack Yss, Xss, Kss, Css, Nss,Iss,WNss = SS

# below are estimated
phipi = 1.5;
deltap = 0.8744200057383883;
theta_F_to_F_dollar = 0.0;
theta_F_to_U_dollar = 1.0;
theta_U_to_F_dollar = 0.0;
alph = 0.4*(1-omega)/Tradable_share;
eta = 1.5;


bmin = -0.00;
rho_shock = 0.89;
shock_size = 1.0;
Tnews = 30;

Tshock = T;
rhom = 0.81^4;
#rhom = 0.0;

# shock path
Shock_Var = "U UIP shock";

Tplot = 200;
ms = 8;
lw = 5;
tplot = 0:(T-1)





###############################################################
# compute moment
###############################################################



function compute_data_minus_irf(data,model)
    Tcut = 10;
    std = ( data[!,:up95] -  data[!,:bh] )./1.96
    std = 1;
    #std = mean(std)
    diff_data_model =  ( data[!,:bh] - model[1:10] ) ./ std
    sumdiff = sum( diff_data_model[1:Tcut].^2);
    return sumdiff
end

list_model = ["relative_NER","relative_RER","relative_Y", "relative_C", "relative_I",
"relative_pi","relative_i" ,"relative_exp","relative_imp","relative_ToT"]

list_data = ["lnominal","lreal", "RGDP_WB", "consumption_WB",  "investment_WB", 
"inflation_WB","bloomberg_rate_all","exports_WB","imports_WB","lTerms_of_trade_WB"]

include("Model_equations_v4_HANK_alt2.jl")
nvar = Int(length(varargin)/2);
allinputs = replace(allinputs_string,"\n" => "")
allinputs = split(allinputs,',');
include("construct_IRF.jl")

include("set_other_parameters.jl")
include("Shock_constructor.jl")
include("compute_steady_state.jl")


auxillary_inputs = (
    nvar = nvar,
    allinputs = allinputs,
    list_model = list_model,
    list_data = list_data,
    ss0 = ss0,
    ss1 = ss1,
    data_irf = data_irf,
    T = T,
    SS = SS,
    Tnews = Tnews
)

function GMMobj_fun(
    eta,
    phipi,
    deltap,
    theta_F_to_F_dollar,
    theta_F_to_U_dollar,
    theta_U_to_F_dollar,
    alph,
    Inattention,
    bmin,
    rho_shock,
    rhom,
    param_predetermined,
    auxillary_inputs,
    Shock_Var,
    deltaw,
    GammaB,
    GammaD,
    GammaI,
    HtMshare,
    delay,
    SI,
    habit,
    flow_adj,
    sig,
    SN,
    s_share;
    scaling = scaling,
    Tshock = Tshock,
    smallopen = 0,
    P_Taylor = P_Taylor,
    F_fix = F_fix,
    Tradable_share = Tradable_share,
    T_NT_elasticity = T_NT_elasticity,
    explosive_off = explosive_off)

    @unpack nvar, allinputs, list_data, list_model, 
    ss0, ss1, data_irf,T,Tnews = auxillary_inputs

    shock_size = 1.0;
    d =0.0;

    scaling_temp = 0.0;
    if eta >0.0 && 
        #bmin >= minimum(bmingrid) && 
       # bmin <= maximum(bmingrid) &&
        phipi > 0.0 &&
        deltap >= 0.0 && 
        deltap <= 1.0 &&
        theta_F_to_F_dollar >= 0.0 && 
        theta_F_to_F_dollar <= 1.0 &&
        theta_F_to_U_dollar >= 0.0 &&
        theta_F_to_U_dollar <= 1.0 && 
        theta_U_to_F_dollar >= 0.0 && 
        theta_U_to_F_dollar <= 1.0 && 
        alph >= 0.0 && 
        alph <= 1.0 && 
        Inattention >= 0.0 && 
        Inattention < 1.0 && 
        rho_shock >= 0.0 && 
        rho_shock < 1.0 && 
        rhom >= 0.0 && 
        rhom < 1.0 &&
        HtMshare >= 0.0 && 
        HtMshare < 1.0 &&
        delay >= 0 && 
        delay <=1 &&
        GammaD >= 0 &&
        GammaI >= 0 && 
        habit >= 0 &&
        habit < 1 &&
        SI > 0 &&
        deltaw >= 0 &&
        deltaw < 1 && 
        flow_adj >= 0 &&
        flow_adj <= 1 

        if scaling == "matchRER" || scaling == "matchIRF"
            scaling_temp = 1.0;
        else
            scaling_temp = copy(scaling)
        end



        #C_Jacobian_hump,C_Jacobian = Jacobian_output(bmin,Inattention,HANK_RANK,C_Jacobian_Y,C_Jacobian_r,C_Jacobian_beta,load_Jacobian,auxillary_inputs)

        P = set_parameters_fun(eta,phipi,deltap,theta_U_to_F_dollar,theta_F_to_U_dollar,
        theta_F_to_F_dollar,alph,rhom,param_predetermined,
        deltaw,GammaB,GammaD, GammaI, HtMshare,delay, SI,smallopen,P_Taylor, habit,flow_adj,sig, SN, F_fix,
        Tradable_share, T_NT_elasticity,s_share, SS)

        Shock_Path, Shock_Var_in,Shock_Path_before,Shock_Path_after  = Shock_constructor(Shock_Var,Tshock,rho_shock,Tnews,auxillary_inputs)
        guess = zeros(length(references))
        #Shock_Path = copy(Shock_Path_before)
        #hock_Var  = (Shock_Var_in)
        ss0 = steady_state(guess,references_ss,P,varargin_eq_ss,Shock_Var_in,Shock_Path_before)
        ss1 = steady_state(guess,references_ss,P,varargin_eq_ss,Shock_Var_in,Shock_Path_after)
  
        #Shock_Path = copy(Shock_Path_after)
        xfull = system_solve(ss0,ss1,references,P,varargin_eq,T,
        Shock_Var_in,Shock_Path);
        
        d =  construct_IRF(P,xfull,allinputs,Shock_Path,scaling_temp,ss0)

        function optimal_shocksize(shocksize)
           GMM_shocksize = 0.0
            #=
            for imoment = 1:length(list_model)
                local data = data_irf[list_data[imoment]]
                local model = d[list_model[imoment]].*scaling
                GMM_shocksize +=  compute_data_minus_irf(data,model)
            end
            
            

            local data = data_irf["lreal"]
            local model = d["relative_RER"].*scaling
            global GMM_shocksize +=  compute_data_minus_irf(data,model)
            =#
            if scaling == "matchRER" 
                local data = data_irf["lnominal"]
                local model = d["relative_NER"].*shocksize
                #global GMM_shocksize +=  compute_data_minus_irf(data,model)
                GMM_shocksize = (data[1,:bh] - model[1])^2
            else
                for imoment = 1:length(list_model)
                    local data = data_irf[list_data[imoment]]
                    local model = d[list_model[imoment]].*shocksize
                    GMM_shocksize +=  compute_data_minus_irf(data,model)
                end
            end
            return GMM_shocksize
        end

        function optimal_GMM(shocksize)
            GMMobj = 0.0
             for imoment = 1:length(list_model)
                 local data = data_irf[list_data[imoment]]
                 local model = d[list_model[imoment]].*shocksize
                 GMMobj +=  compute_data_minus_irf(data,model)
             end
             return GMMobj
        end
        result_scaling = optimize(optimal_shocksize, [1.0], LBFGS();autodiff = :forward)
        GMMobj = optimal_GMM(result_scaling.minimizer[1])
        
        if scaling == "matchRER" || scaling == "matchIRF"
            scaling_temp = result_scaling.minimizer[1]
            d =  construct_IRF(P,xfull,allinputs,Shock_Path,scaling_temp,ss0)
            d["Shock"] = scaling_temp*Shock_Path;
        else
            d["Shock"] = scaling_temp*Shock_Path;
        end
        if Shock_Var == "F Trend shock"
            d["Shock"] = d["Shock"] .- Shock_Path[1]
        end
        
        if explosive_off == 1
            if mean(abs.( diff( d["rp_U"][(T-9):T])))/mean(abs.( diff( d["rp_U"][(2):11])) )> 0.05
                GMMobj = 1e50
            end
        end
    
    else
        GMMobj = 1e50;
        d = 0.0
    end
    
    println("GMM objective = ", GMMobj)

    return (GMMobj,d,scaling_temp)
end

(GMMobj,d) = GMMobj_fun(
eta,
phipi,
deltap,
theta_F_to_F_dollar,
theta_F_to_U_dollar,
theta_U_to_F_dollar,
alph,
Inattention,
bmin,
rho_shock,
rhom,
param_predetermined,
auxillary_inputs,
Shock_Var,
deltaw,
GammaB,
GammaD,
GammaI,
HtMshare,
delay,
SI,
habit,
flow_adj,
sig,
SN,
s_share,
scaling = scaling,
Tshock = Tshock,
smallopen = smallopen,
F_fix = F_fix)

plot_model_fun(d,Tplot = 20,country_list = ["U" "P" "F"])
plot_model_fun(d,Tplot = T,country_list = ["U" "P" "F"])
plot_result_fun(d,data_irf,fig_all = 0)


function wrapper_GMM(x;scaling = scaling,
    deltap = deltap,
    deltaw = deltaw,
    GammaB = GammaB,
    Shock_Var = Shock_Var,
    rho_shock = rho_shock,
    SI = SI,
    theta_F_to_U_dollar = theta_F_to_U_dollar,
    theta_U_to_F_dollar = theta_U_to_F_dollar,
    theta_F_to_F_dollar = theta_F_to_F_dollar,
    smallopen = smallopen,
    P_Taylor = P_Taylor,
    phipi=phipi,
    HtMshare = HtMshare,
    GammaD = GammaD,
    GammaI = GammaI,
    delay = delay,
    sig = sig,
    rhom = rhom,
    eta =eta,
    F_fix = F_fix,
    Tradable_share = Tradable_share,
    T_NT_elasticity = T_NT_elasticity,
    alph = alph,
    s_share = s_share,
    explosive_off = explosive_off)
    if x[1] > 0 && x[2] > 0
        delta_vec = ( - sqrt.(beta.^2 .+ 2*beta.*(x[1:2].-1) .+ (x[1:2].+1).^2) .+ beta .+ x[1:2] .+ 1)./(2*beta)
    else
        delta_vec = [10 10]
    end
    deltap_in = delta_vec[1]
    deltaw_in =delta_vec[2]

    habit = x[3]
    #SI = x[4]
    #sig = (1-habit)/(1+habit+habit^2)/EIS;
    EIS = (1-habit)/(1+habit+habit^2)/sig

    (obj,d,scaling) = GMMobj_fun(
        eta,
        phipi,
        deltap_in,#deltap
        theta_F_to_F_dollar,
        theta_F_to_U_dollar,
        theta_U_to_F_dollar,
        alph,
        Inattention,
        bmin,
        rho_shock,#rho_shock
        rhom,#rhom
        param_predetermined,
        auxillary_inputs,
        Shock_Var,
        deltaw_in,#deltaw
        GammaB,
        GammaD,#GammaD
        GammaI,#GammaI
        HtMshare,
        delay,
        SI,#SI
        habit,#habit
        flow_adj,
        sig, #sig
        SN,
        s_share,
        scaling = scaling,
        P_Taylor = P_Taylor,
        smallopen = smallopen,
        F_fix = F_fix,
        Tradable_share = Tradable_share,
        T_NT_elasticity = T_NT_elasticity,
        explosive_off = explosive_off)
        println("x = ",x)
    return obj,d,scaling
end

function compute_std(x; fig_save=0)
    dIRF = zeros(length(x),length(list_model)*10)
    Sigma = zeros( length(list_model)*10, length(list_model)*10)
    for imoment = 1:length(list_model)
        local data = data_irf[list_data[imoment]]
        std = ( data[!,:up95] -  data[!,:bh] )./1.96
        for t = 1:10
            idx = (imoment-1)*10 +t
            Sigma[idx,idx] = std[t]^2;
        end
    end

    ~,d = wrapper_GMM(x)
    for ix = 1:length(x)
        xd = copy(x)
        dx = 0.01*x[ix]
      
        xd[ix] = x[ix] - dx;
        ~,d_d = wrapper_GMM(xd)  
        for imoment = 1:length(list_model)
            model = d[list_model[imoment]]
            dmodel = d_d[list_model[imoment]]
            diff_data_model =  (  dmodel[1:10] - model[1:10] );
            idx = (imoment-1)*10 ;
            dIRF[ix,idx .+ (1:10)] = diff_data_model./dx;
        end
    end

    Sigma_temp = Sigma[2:end,2:end]
    dIRF_temp = dIRF[:,2:end]

    Vcov = inv(dIRF_temp*inv(Sigma_temp)*dIRF_temp')
    std_mat = diag(sqrt(Vcov))

    dkappap_ddetalp(deltap) =   - (1-beta*deltap)/deltap +
        - beta*(1-deltap)/deltap +
        - (1-deltap)*(1-beta*deltap)/(deltap^2)

    #deltap_temp = x[1]
    #delta_method = dkappap_ddetalp(deltap_temp)

    std_mat_delta = copy(std_mat)
    #std_mat_delta[1] = std_mat[1]*abs(delta_method)
    #std_mat_delta[2] = std_mat[2]*abs(delta_method)

    x_estimated = copy(x);
    #x_estimated[1] = (1-beta*x[1])*(1-x[1])/x[1]
    #x_estimated[2] = (1-beta*x[2])*(1-x[2])/x[1]

    if fig_save == 1
        io = open(tables_overleaf*"/estimated_parameters.txt", "w");
        #write(io, "\$\\chi\$ & Share of hand-to-mouth households &"*@sprintf("%.2f",x_estimated[2])*"\\\\ \n");
        #write(io, " &  &("*@sprintf("%.2f",std_mat_delta[2])*")\\\\ \n");
        #write(io, "\$\\Gamma^D \$ & Inelasticity between equity and bonds &"*@sprintf("%.3f",x_estimated[3])*"\\\\ \n");
        #write(io, " &  &("*@sprintf("%.3f",std_mat_delta[3])*") \\\\ \n");
        write(io, "\$\\kappa_p\$ & Price Phillips curve slope &"*@sprintf("%.3f",x_estimated[1])*"&("*@sprintf("%.3f",std_mat_delta[1])*")\\\\ \n");
        #write(io, " &  &("*@sprintf("%.3f",std_mat_delta[1])*") \\\\ \n");
        write(io, "\$\\kappa_w\$ & Wage Phillips curve slope &"*@sprintf("%.3f",x_estimated[2])*"&("*@sprintf("%.3f",std_mat_delta[2])*")\\\\ \n");
        #write(io, " &  &("*@sprintf("%.3f",std_mat_delta[2])*") \\\\ \n");
        #write(io, "\$\\rho_\\psi\$ & Shock persistence &"*@sprintf("%.3f",x_estimated[4])*"\\\\ \n");
        #write(io, " &  &("*@sprintf("%.3f",std_mat_delta[4])*") \\\\ \n");
        write(io, "\$ h \$ & Habit &"*@sprintf("%.3f",x_estimated[3])*"&("*@sprintf("%.3f",std_mat_delta[3])*")\\\\  \n");
        #write(io, " &  &("*@sprintf("%.3f",std_mat_delta[3])*") \\\\ \\hline \n");
        #write(io, "\$ \\phi_I \$ & Investment adjustment cost & "*@sprintf("%.2f",x_estimated[4])*"&("*@sprintf("%.3f",std_mat_delta[4])*")\\\\  \n");

        #write(io, "\$\\vartheta\$ & Substitution delay & "*@sprintf("%.2f",x_estimated[3])*"\\\\ \n");
        #write(io, " &  &("*@sprintf("%.2f",std_mat_delta[3])*")\\\\ \\hline \n");
        #write(io, "\$\\rho_m\$ & Monetary policy inertia & "*@sprintf("%.2f",x_estimated[4])*"\\\\ \n");
        #write(io, " &  &("*@sprintf("%.2f",std_mat_delta[4])*")\\\\ \\hline \n");
        close(io);
    end

end


kappap = (1-deltap)*(1-beta*deltap)/deltap
kappaw = (1-deltaw)*(1-beta*deltaw)/deltaw
xinit = [kappap,kappaw,habit]

if estimate_param == 1
    wrapper_GMM(xinit)
    result = optimize(x-> wrapper_GMM(x)[1], xinit,NelderMead())
    x = result.minimizer
    compute_std(x; fig_save= fig_save)
else
    x = [0.0054273103385628465, 0.0033905122886992304, 0.7186998599862398]
end
delta_vec = ( - sqrt.(beta.^2 .+ 2*beta.*(x[1:2].-1) .+ (x[1:2].+1).^2) .+ beta .+ x[1:2] .+ 1)./(2*beta)
deltap = delta_vec[1]
deltaw = delta_vec[2]
#=
x = [0.024082372717679296
0.010451530583131545
0.8187135863571826]
=#

~,d,scaling_fix = wrapper_GMM(x)
plot_result_fun(d,data_irf,fig_all=1)
plot_result_fun(d,data_irf,fig_all=1,UIP_deviation=1)

plot_model_fun(d,Tplot = 100,country_list = ["U" "P" "F"])
plot_result_fun(d,
    data_irf;
    fig_save = fig_save,
    fig_name = "",
    fig_all = 1,
    split = 0)
plot_result_fun(d,
    data_irf;
    fig_save = fig_save,
    fig_name = "",
    fig_all = 1,
    split = 0,
    UIP_deviation=1)
plot_result_fun(d,
    data_irf;
    fig_save = fig_save,
    fig_name = "",
    fig_all = 1,
    split = 1)

~,d_UIP,scaling_fix = wrapper_GMM(x)
~,d_MP,scaling_fix = wrapper_GMM(x,Shock_Var = "U MP shock")
~,d_Tech,scaling_fix = wrapper_GMM(x,Shock_Var = "U TFP shock")
~,d_Inv,scaling_fix = wrapper_GMM(x,Shock_Var = "U Risk shock")
plot_model_fun(d_Inv,Tplot = 100,country_list = ["U" "P" "F"])
plot_result_fun(d_Inv,data_irf,fig_all=1)
plot_model_fun(d_MP,Tplot = 100,country_list = ["U" "P" "F"])

# For Jon's discussion
#=
plot_model_fun(d_MP,Tplot = 20,country_list = ["U" "F"])
~,d_MP_no_s = wrapper_GMM(x,s_share = 0.99,Shock_Var = "U MP shock")
plot_model_fun(d_MP_no_s,Tplot = 20,country_list = ["U" "F"])
=#

plot_result_fun(d_Tech,data_irf,fig_all=1)

write_table_ner_i(data_irf,d_UIP,d_MP,d_Tech,d_Inv;fig_save=fig_save)

plot_result_fun(d_Inv,
    data_irf;
    fig_save = fig_save,
    fig_name = "Risk_shock",
    fig_all = 1)



~,d_no_s = wrapper_GMM(x,s_share = 0.0)

plot_result_fun2(d,d_no_s,d2_label = L"$\bar s = 0$",fig_save=fig_save,tpre=0)



if estimate_param == 1
    #result = optimize(x-> wrapper_GMM(x,s_share = 0.0)[1], xinit,NelderMead(),Optim.Options(g_tol = 0.1,x_tol=0.1,f_tol=0.1))
    result = optimize(x-> wrapper_GMM(x,s_share = 0.0,explosive_off= 1)[1], xinit,NelderMead(),Optim.Options(g_tol = 0.01,x_tol=0.01,f_tol=0.01))

    x_no_s = result.minimizer
else
    x_no_s = [0.006973631388079738
    0.06326781030376707
    0.9416475032036903];
end
#x_no_s = [0.017158161937252697
#0.03943857083027839
#0.9595077113251468]
~,d_no_s_reest = wrapper_GMM(x_no_s,s_share = 0.0)
plot_result_fun(d_no_s_reest,data_irf,fig_all=1)

plot_result_fun3(d,d_no_s,d_no_s_reest,d2_label = "\$\\bar s = 0\$",
d3_label="\$\\bar s = 0\$ (Re-est.)",d1_label="Baseline",
fig_save=fig_save,tpre=0,fig_name = "no_GammaD",
s_share_plot = 1,d1_ls = :solid,d2_ls = :dash,d3_ls=:dot)

##########################################################################################
# Falsification
###########################################################################

#PCP with no GammaD

~,d_no_s_PCP = wrapper_GMM(x,s_share=0, explosive_off=1,theta_F_to_U_dollar=0,theta_U_to_F_dollar=1)
plot_model_fun(d_no_s_PCP)

if estimate_param == 1
    result = optimize(x-> wrapper_GMM(x,s_share=0, explosive_off=1,theta_F_to_U_dollar=0,theta_U_to_F_dollar=1)[1], xinit,NelderMead(),Optim.Options(g_tol = 0.1,x_tol=0.1,f_tol=0.1))
    x_no_s_PCP_reest = result.minimizer
else
    x_no_s_PCP_reest = [0.031318925252578386
    0.003641054557874255
    0.9942525685889245]
end
~,d_no_s_PCP_reest = wrapper_GMM(x_no_s_PCP_reest,s_share=0, explosive_off=0,theta_F_to_U_dollar=0,theta_U_to_F_dollar=1)
plot_model_fun(d_no_s_PCP_reest)

#DCP with no GammaD
~,d_no_s_DCP = wrapper_GMM(x,s_share=0, explosive_off=0,theta_F_to_U_dollar=1,theta_U_to_F_dollar=1)
plot_model_fun(d_no_s_DCP)
if estimate_param == 1
    result = optimize(x-> wrapper_GMM(x,s_share=0, explosive_off=0,theta_F_to_U_dollar=1,theta_U_to_F_dollar=1)[1], xinit,NelderMead(),Optim.Options(g_tol = 0.1,x_tol=0.1,f_tol=0.1))
    x_no_s_DCP_reest = result.minimizer
else
    x_no_s_DCP_reest = [7.182191149651099e-5
    0.005769741727621071
    0.8801397634688488]
end
~,d_no_s_DCP_reest = wrapper_GMM(x_no_s_DCP_reest,s_share=0, explosive_off=1,theta_F_to_U_dollar=1,theta_U_to_F_dollar=1)

plot_model_fun(d_no_s_DCP_reest)

#Low eta
eta_set = 1.0;
~,d_no_s_eta = wrapper_GMM(x,s_share=0, explosive_off=1,eta=eta_set)
if estimate_param == 1
    result = optimize(x-> wrapper_GMM(x,s_share=0, explosive_off=1,eta=eta_set)[1], x,NelderMead(),Optim.Options(g_tol = 0.1,x_tol=0.1,f_tol=0.1))
    x_no_s_eta_reest = result.minimizer
else
    x_no_s_eta_reest = [0.0054273103385628465
    0.0033905122886992304
    0.7186998599862398]
end
~,d_no_s_eta_reest = wrapper_GMM(x_no_s_eta_reest,s_share=0, explosive_off=1,eta=eta_set)
plot_model_fun(d_no_s_eta_reest)


#HtM
~,d_no_s_HtM = wrapper_GMM(x,s_share=0, explosive_off=0,HtMshare=0.3)
if estimate_param == 1
    result = optimize(x-> wrapper_GMM(x,s_share=0, explosive_off=1,HtMshare=0.3)[1], x,NelderMead(),Optim.Options(g_tol = 0.1,x_tol=0.1,f_tol=0.1))
    x_no_s_HtM_reest = result.minimizer
else
    x_no_s_HtM_reest = [0.0054273103385628465
    0.0033905122886992304
    0.7186998599862398]
end
~,d_no_s_HtM_reest = wrapper_GMM(x_no_s_HtM_reest,s_share=0, explosive_off=1,HtMshare=0.3)

plot_model_fun(d_no_s_HtM_reest)
function write_table_falsify(data_irf,d_UIP;fig_save=0)
    ly5_impact = @sprintf("%.2f",mean(data_irf["RGDP_WB"][1:5,2]) );
    lnx5_impact = @sprintf( "%.2f",mean( data_irf["net_exports_WB"][1:5,2]));
    
    ly5_impact_UIP = @sprintf("%.2f",mean(d_UIP["relative_Y"][1:5]) );
    lnx5_impact_UIP = @sprintf( "%.2f",mean( d_UIP["relative_netexp"][1:5]));

    ly5_noG = @sprintf("%.2f",mean(d_no_s["relative_Y"][1:5]) );
    lnx5_noG = @sprintf( "%.2f",mean( d_no_s["relative_netexp"][1:5]));
    ly5_no_s_reest = @sprintf("%.2f",mean(d_no_s_reest["relative_Y"][1:5]) );
    lnx5_no_s_reest = @sprintf( "%.2f",mean( d_no_s_reest["relative_netexp"][1:5]));

    ly5_no_s_PCP = @sprintf("%.2f",mean(d_no_s_PCP["relative_Y"][1:5]) );
    lnx5_no_s_PCP = @sprintf( "%.2f",mean( d_no_s_PCP["relative_netexp"][1:5]));
    ly5_no_s_reest_PCP = @sprintf("%.2f",mean(d_no_s_PCP_reest["relative_Y"][1:5]) );
    lnx5_no_s_reest_PCP = @sprintf( "%.2f",mean( d_no_s_PCP_reest["relative_netexp"][1:5]));

    ly5_no_s_DCP = @sprintf("%.2f",mean(d_no_s_DCP["relative_Y"][1:5]) );
    lnx5_no_s_DCP = @sprintf( "%.2f",mean( d_no_s_DCP["relative_netexp"][1:5]));
    ly5_no_s_reest_DCP = @sprintf("%.2f",mean(d_no_s_DCP_reest["relative_Y"][1:5]) );
    lnx5_no_s_reest_DCP = @sprintf( "%.2f",mean( d_no_s_DCP_reest["relative_netexp"][1:5]));

    ly5_no_s_eta = @sprintf("%.2f",mean(d_no_s_eta["relative_Y"][1:5]) );
    lnx5_no_s_eta = @sprintf( "%.2f",mean( d_no_s_eta["relative_netexp"][1:5]));
    ly5_no_s_reest_eta  = @sprintf("%.2f",mean(d_no_s_eta_reest["relative_Y"][1:5]) );
    lnx5_no_s_reest_eta = @sprintf( "%.2f",mean( d_no_s_eta_reest["relative_netexp"][1:5]));

    ly5_no_s_HtM = @sprintf("%.2f",mean(d_no_s_HtM["relative_Y"][1:5]) );
    lnx5_no_s_HtM = @sprintf( "%.2f",mean( d_no_s_HtM["relative_netexp"][1:5]));
    ly5_no_s_reest_HtM  = @sprintf("%.2f",mean(d_no_s_HtM_reest["relative_Y"][1:5]) );
    lnx5_no_s_reest_HtM = @sprintf( "%.2f",mean( d_no_s_HtM_reest["relative_netexp"][1:5]));


    io = open(tables_overleaf*"/Falsify.txt", "w");
    write(io, "Data && "*ly5_impact*" & "*lnx5_impact*" && "*ly5_impact*" & "*lnx5_impact *"\\\\ \n");
    write(io, "Baseline Model && "*ly5_impact_UIP*" & "*lnx5_impact_UIP*" && "*ly5_impact_UIP*" & "*lnx5_impact_UIP *"\\\\[0.2cm] \n");
    write(io,"Models with \$ \\bar s = 0 \$ &&&&&& \\\\ \n")
    write(io, "\\quad (a) Benchmark  && "*ly5_noG*" & "*lnx5_noG*" && "*ly5_no_s_reest*" & "*lnx5_no_s_reest *"\\\\ \n");
    write(io, "\\quad (b) PCP  && "*ly5_no_s_PCP*" & "*lnx5_no_s_PCP*" && "*ly5_no_s_reest_PCP*" & "*lnx5_no_s_reest_PCP *"\\\\ \n");
    write(io, "\\quad (c) DCP  && "*ly5_no_s_DCP*" & "*lnx5_no_s_DCP*" && "*ly5_no_s_reest_DCP*" & "*lnx5_no_s_reest_DCP *"\\\\ \n");
    write(io, "\\quad (d) Low \$\\eta\$ && "*ly5_no_s_eta*" & "*lnx5_no_s_eta*" && "*ly5_no_s_reest_eta*" & "*lnx5_no_s_reest_eta *"\\\\ \n");
    write(io, "\\quad (e) Hand-to-Mouth && "*ly5_no_s_HtM*" & "*lnx5_no_s_HtM*" && "*ly5_no_s_reest_HtM*" & "*lnx5_no_s_reest_HtM *"\\\\  \n");
    close(io)

end
write_table_falsify(data_irf,d_UIP;fig_save=fig_save)
##########################################################################################
# Disconnect 
###########################################################################
smallopen_set = 0;
corr_target_var = "GDP"

include("load_business_cycle_moments.jl")



target_corr = parse(Float64,data_write["corr_d"*corr_target_var])



d_list =  Dict{String,Any}()
Cov_list = Dict{String,Any}()
std_list = Dict{String,Any}()
autocorr_list = Dict{String,Any}()
corr_list = Dict{String,Any}()
shock_list = ["UIP","TFP","MP"]
for is in shock_list
    for cty in ["F"]
        ~,d_list[cty*"_"*is] = wrapper_GMM(x,Shock_Var = cty*" "*is*" shock",scaling=1,smallopen=smallopen_set)
        Cov_list[cty*"_"*is] = second_moments_list(d_list[cty*"_"*is],cty_set = ["F"])
        std_list[cty*"_"*is], autocorr_list[cty*"_"*is],corr_list[cty*"_"*is] = std_corr_list1(Cov_list[cty*"_"*is])

        ~,d_list[cty*"_"*is*"_fix"] = wrapper_GMM(x,Shock_Var = cty*" "*is*" shock",scaling=1,smallopen=smallopen_set,F_fix=1)
        Cov_list[cty*"_"*is*"_fix"] = second_moments_list(d_list[cty*"_"*is*"_fix"],cty_set = ["F"])
        std_list[cty*"_"*is*"_fix"], autocorr_list[cty*"_"*is*"_fix"],corr_list[cty*"_"*is*"_fix"] = std_corr_list1(Cov_list[cty*"_"*is*"_fix"])

        ~,d_list[cty*"_"*is*"_nos"] = wrapper_GMM(x,s_share=0,Shock_Var = cty*" "*is*" shock",scaling=1,smallopen=smallopen_set)
        Cov_list[cty*"_"*is*"_nos"] = second_moments_list(d_list[cty*"_"*is*"_nos"],cty_set = ["F"])
        std_list[cty*"_"*is*"_nos"], autocorr_list[cty*"_"*is],corr_list[cty*"_"*is] = std_corr_list1(Cov_list[cty*"_"*is])

        ~,d_list[cty*"_"*is*"_fix"*"_nos"] = wrapper_GMM(x,s_share=0,Shock_Var = cty*" "*is*" shock",scaling=1,smallopen=smallopen_set,F_fix=1)
        Cov_list[cty*"_"*is*"_fix"*"_nos"] = second_moments_list(d_list[cty*"_"*is*"_fix"*"_nos"],cty_set = ["F"])
        std_list[cty*"_"*is*"_fix"*"_nos"], autocorr_list[cty*"_"*is*"_fix"*"_nos"],corr_list[cty*"_"*is*"_fix"*"_nos"] = std_corr_list1(Cov_list[cty*"_"*is*"_fix"])

    end
end

Choose_GammaD_result = optimize(z -> Choose_GammaD(Cov_list["F_UIP"],z,x,smallopen = smallopen_set,
vol_target = target_vol,corr_target = target_corr,target_var = "dNER",corr_target_var =corr_target_var )[1],0,100)
GammaD_set = Choose_GammaD_result.minimizer
shock_list = ["Risk"]
for is in shock_list
    for cty in ["F"]
        ~,d_list[cty*"_"*is] = wrapper_GMM(x,Shock_Var = cty*" "*is*" shock",scaling=1,smallopen=smallopen_set,GammaD=GammaD_set)
        Cov_list[cty*"_"*is] = second_moments_list(d_list[cty*"_"*is],cty_set = ["F"])
        std_list[cty*"_"*is], autocorr_list[cty*"_"*is],corr_list[cty*"_"*is] = std_corr_list1(Cov_list[cty*"_"*is])

        ~,d_list[cty*"_"*is*"_fix"] = wrapper_GMM(x,Shock_Var = cty*" "*is*" shock",scaling=1,smallopen=smallopen_set,F_fix=1,GammaD=GammaD_set)
        Cov_list[cty*"_"*is*"_fix"] = second_moments_list(d_list[cty*"_"*is*"_fix"],cty_set = ["F"])
        std_list[cty*"_"*is*"_fix"], autocorr_list[cty*"_"*is*"_fix"],corr_list[cty*"_"*is*"_fix"] = std_corr_list1(Cov_list[cty*"_"*is*"_fix"])
    end
end



plot_model_two_fun(d_list["F_Risk"],d_list["F_Risk_fix"],
country_list =["F"],Tplot=20,label1="Floaters float",label2="Floaters peg",fig_save=fig_save,fig_name="risk_shock_irf")

plot_model_fun(d_list["F_Risk"],Tplot=100,country_list =["F"],fig_save=0)

plot_model_two_fun(d_list["F_Risk"],d_list["F_Risk_fix"],
country_list =["F"],Tplot=20,label1="Floaters float",label2="Floaters peg",
fig_save=fig_save,fig_name="three_risk_shock_irf",three=1)

plot_model_two_fun(d_list["F_UIP"],d_list["F_UIP_fix"],
country_list =["F"],Tplot=20,label1="Floaters float",label2="Floaters peg",
fig_save=fig_save,fig_name="three_uip_shock_irf",three=1)

second_shock_name = "F_Risk"
optsol = optimize(x-> min_vol(Cov_list["F_UIP"],Cov_list[second_shock_name],x,target = target_vol,target_var = target_vol_var)[1], 0,100)
weightsol_mix = optsol.minimizer
gdp_vol  = Cov_list["F_UIP"]["dGDP_dGDP"] + weightsol_mix*Cov_list[second_shock_name]["dGDP_dGDP"]
UIP_weight = gdp_std_data^2/gdp_vol;
Investment_weight = weightsol_mix*UIP_weight
~,std_list["F_UIP_I_mix"],autocorr_list["F_UIP_I_mix"],corr_list["F_UIP_I_mix"] = min_vol(Cov_list["F_UIP"],Cov_list[second_shock_name],Investment_weight,weight1 = UIP_weight )
std_list["F_UIP_I_mix"]["dGDP"]






~,std_list["F_UIP_I_mix_fix"],autocorr_list["F_UIP_I_mix_fix"],corr_list["F_UIP_I_mix_fix"] = min_vol(Cov_list["F_UIP_fix"],Cov_list[second_shock_name*"_fix"],Investment_weight,weight1 = UIP_weight )
std_list["F_UIP_I_mix_fix"]["dGDP"]

target_Mussa = std_list["F_UIP_I_mix"][target_vol_var]/std_list["F_UIP_I_mix"]["dGDP"]


optsol = optimize(x-> min_vol(Cov_list["F_UIP"],Cov_list["F_TFP"],x,target = target_Mussa,target_var = target_vol_var)[1], 0,100)
weightsol_mix = optsol.minimizer
gdp_vol  = Cov_list["F_UIP"]["dGDP_dGDP"] + weightsol_mix*Cov_list["F_TFP"]["dGDP_dGDP"]
overall_weight = gdp_std_data^2/gdp_vol;
~,std_list["F_UIP_TFP_mix"],autocorr_list["F_UIP_TFP_mix"],corr_list["F_UIP_TFP_mix"] = min_vol(Cov_list["F_UIP"],Cov_list["F_TFP"],weightsol_mix*overall_weight,weight1 = overall_weight )

~,std_list["F_UIP_TFP_mix_fix"],autocorr_list["F_UIP_TFP_mix_fix"],corr_list["F_UIP_TFP_mix_fix"] = min_vol(Cov_list["F_UIP_fix"],Cov_list["F_TFP_fix"],weightsol_mix*overall_weight,weight1 = overall_weight )
std_list["F_UIP_TFP_mix_fix"]["dGDP"]


# for \bar s = 0 
optsol = optimize(x-> min_vol(Cov_list["F_UIP_nos"],Cov_list["F_TFP_nos"],x,target = target_Mussa,target_var = target_vol_var)[1], 0,100)
weightsol_mix = optsol.minimizer
gdp_vol  = Cov_list["F_UIP_nos"]["dGDP_dGDP"] + weightsol_mix*Cov_list["F_TFP_nos"]["dGDP_dGDP"]
overall_weight = gdp_std_data^2/gdp_vol;
~,std_list["F_UIP_TFP_mix_nos"],autocorr_list["F_UIP_TFP_mix_nos"],corr_list["F_UIP_TFP_mix_nos"] =
 min_vol(Cov_list["F_UIP_nos"],Cov_list["F_TFP_nos"],weightsol_mix*overall_weight,weight1 = overall_weight )

~,std_list["F_UIP_TFP_mix_fix_nos"],autocorr_list["F_UIP_TFP_mix_fix_nos"],corr_list["F_UIP_TFP_mix_fix_nos"] = 
min_vol(Cov_list["F_UIP_fix_nos"],Cov_list["F_TFP_fix_nos"],weightsol_mix*overall_weight,weight1 = overall_weight )
std_list["F_UIP_TFP_mix_fix_nos"]["dGDP"]






std_write = Dict{String,Any}()
stdv_list = ["dNER","dRER","dC","dNX_GDP","di","dI"]
shockv_list = ["UIP","Risk","TFP","MP","UIP_I_mix","UIP_TFP_mix","UIP_TFP_mix_nos"]
for v in stdv_list
    for shockv in shockv_list
        std_write[v*"_"*shockv] = @sprintf("%.3f",std_list["F_"*shockv][v]/std_list["F_"*shockv]["dGDP"]*gdp_std_data );
    end
end


corr_write = Dict{String,Any}()
corrY_write = Dict{String,Any}()
corrv_list = ["dNER","dGDP","dC","dNX_GDP","di","dI"]
for v in corrv_list
    for shockv in shockv_list
        corr_write[v*"_"*shockv] = @sprintf("%.3f",corr_list["F_"*shockv]["dRER_"*v] );
        corrY_write[v*"_"*shockv] = @sprintf("%.3f",corr_list["F_"*shockv]["dGDP_"*v] );
    end
end

autocorr_write = Dict{String,Any}()
corrv_list = ["dNER","dGDP","dC","dNX_GDP","di","dI"]
for v in corrv_list
    for shockv in shockv_list
        autocorr_write[v*"_"*shockv] = @sprintf("%.3f",autocorr_list["F_"*shockv][v] );
    end
end

include("./write_business_cycle_moments.jl")




##########################################################################################
# Change country size
###########################################################################

d_size_list =  Dict{String,Any}()
Cov_size_list = Dict{String,Any}()
std_size_list = Dict{String,Any}()
autocorr_size_list = Dict{String,Any}()
corr_size_list = Dict{String,Any}()
shock_list = ["UIP"]
smallopen_size = 0.5
for is in shock_list
    for cty in ["F"]
        ~,d_size_list[cty*"_"*is] = wrapper_GMM(x,Shock_Var = cty*" "*is*" shock",scaling=1,smallopen=smallopen_size)
        Cov_size_list[cty*"_"*is] = second_moments_list(d_size_list[cty*"_"*is],cty_set = ["F"])
        std_size_list[cty*"_"*is], autocorr_size_list[cty*"_"*is], corr_size_list[cty*"_"*is] = std_corr_list1(Cov_size_list[cty*"_"*is])

    end
end

shock_list = ["Risk"]
for is in shock_list
    for cty in ["F"]
        ~,d_size_list[cty*"_"*is] = wrapper_GMM(x,Shock_Var = cty*" "*is*" shock",scaling=1,smallopen=smallopen_size,GammaD=GammaD_set)
        Cov_size_list[cty*"_"*is] = second_moments_list(d_size_list[cty*"_"*is],cty_set = ["F"])
        std_size_list[cty*"_"*is], autocorr_size_list[cty*"_"*is],corr_size_list[cty*"_"*is] = std_corr_list1(Cov_size_list[cty*"_"*is])
    end
end

relative_size = range(0.5,2,length=20)
corr_grid = zeros(length(relative_size))
for i in eachindex(relative_size)
    second_shock_name = "F_Risk"
    ~,std_size_list["F_UIP_I_mix"],autocorr_size_list["F_UIP_I_mix"],corr_size_list["F_UIP_I_mix"] = 
    min_vol(Cov_size_list["F_UIP"],Cov_size_list[second_shock_name],Investment_weight*relative_size[i],weight1 = UIP_weight )
    corr_grid[i] = corr_size_list["F_UIP_I_mix"]["dNX_GDP_dRER"]
end

plot(relative_size,corr_grid,lw = 7,label=:none)
plot!(grid = :y)
plot!(ylabel="Corr(ΔRER, ΔNX)",xlabel="Relative Volatility of ζ Shock to ψ Shock")
plot!(titlefontfamily = "Times Roman",
#xguidefontfamily = "Times Roman",
#yguidefontfamily = "Times Roman",
legendfontfamily =  "Times Roman")
if fig_save == 1
    fig_name_save = string(file_overleaf,"/size_corr_rer_nx_model.pdf")
    savefig(fig_name_save)
end

##########################################################################################
# Mussa
###########################################################################

std_mussa_write = Dict{String,Any}()
stdv_list = ["dGDP","dNER","dRER","dC","dNX_GDP","di"]
shockv_list = ["UIP","TFP","MP","UIP_I_mix","UIP_TFP_mix","Risk"]
for v in stdv_list
    for shockv in shockv_list
        if shockv == "UIP"
            weight_write = UIP_weight;
        elseif shockv == "Risk"
            weight_write = Investment_weight;
        else
            weight_write = 1.0;
        end
        std_mussa_write[v*"_"*shockv] = @sprintf("%.3f",std_list["F_"*shockv][v]*sqrt(weight_write) );
        std_mussa_write[v*"_"*shockv*"_fix"] = @sprintf("%.3f",std_list["F_"*shockv*"_fix"][v]*sqrt(weight_write) );
    end
end


corr_mussa_write = Dict{String,Any}()
corrv_list = ["dNER","dGDP","dC","dNX_GDP","di"]
for v in corrv_list
    for shockv in shockv_list
        corr_mussa_write[v*"_"*shockv] = @sprintf("%.2f",corr_list["F_"*shockv]["dRER_"*v] );
        corr_mussa_write[v*"_"*shockv*"_fix"] = @sprintf("%.2f",corr_list["F_"*shockv*"_fix"]["dRER_"*v] );
    end
end

io = open(tables_overleaf*"/mussa_table.txt", "w");
write(io, "\\quad std(\$ \\Delta NER\$) "
*"&&"*std_mussa_write["dNER_UIP_I_mix"]*" & "*std_mussa_write["dNER_UIP_I_mix_fix"]
*"&&"*std_mussa_write["dNER_UIP"]*" & "*std_mussa_write["dNER_UIP_fix"]
*"&&"*std_mussa_write["dNER_Risk"]*" & "*std_mussa_write["dNER_Risk_fix"]
*"&&"*std_mussa_write["dNER_UIP_TFP_mix"]*" & "*std_mussa_write["dNER_UIP_TFP_mix_fix"]
* "\\\\ \n");

write(io, "\\quad std(\$ \\Delta RER\$) "
*"&&"*std_mussa_write["dRER_UIP_I_mix"]*" & "*std_mussa_write["dRER_UIP_I_mix_fix"]
*"&&"*std_mussa_write["dRER_UIP"]*" & "*std_mussa_write["dRER_UIP_fix"]
*"&&"*std_mussa_write["dRER_Risk"]*" & "*std_mussa_write["dRER_Risk_fix"]
*"&&"*std_mussa_write["dRER_UIP_TFP_mix"]*" & "*std_mussa_write["dRER_UIP_TFP_mix_fix"]
* "\\\\ \n");

write(io, "\\quad std(\$ \\Delta GDP\$) "
*"&&"*std_mussa_write["dGDP_UIP_I_mix"]*" & "*std_mussa_write["dGDP_UIP_I_mix_fix"]
*"&&"*std_mussa_write["dGDP_UIP"]*" & "*std_mussa_write["dGDP_UIP_fix"]
*"&&"*std_mussa_write["dGDP_Risk"]*" & "*std_mussa_write["dGDP_Risk_fix"]
*"&&"*std_mussa_write["dGDP_UIP_TFP_mix"]*" & "*std_mussa_write["dGDP_UIP_TFP_mix_fix"]
* "\\\\ \n");

write(io, "\\quad std(\$ \\Delta C\$) "
*"&&"*std_mussa_write["dC_UIP_I_mix"]*" & "*std_mussa_write["dC_UIP_I_mix_fix"]
*"&&"*std_mussa_write["dC_UIP"]*" & "*std_mussa_write["dC_UIP_fix"]
*"&&"*std_mussa_write["dC_Risk"]*" & "*std_mussa_write["dC_Risk_fix"]
*"&&"*std_mussa_write["dC_UIP_TFP_mix"]*" & "*std_mussa_write["dC_UIP_TFP_mix_fix"]
* "\\\\ \n");

write(io, "\\quad std(\$ \\Delta NX\$) "
*"&&"*std_mussa_write["dNX_GDP_UIP_I_mix"]*" & "*std_mussa_write["dNX_GDP_UIP_I_mix_fix"]
*"&&"*std_mussa_write["dNX_GDP_UIP"]*" & "*std_mussa_write["dNX_GDP_UIP_fix"]
*"&&"*std_mussa_write["dNX_GDP_Risk"]*" & "*std_mussa_write["dNX_GDP_Risk_fix"]
*"&&"*std_mussa_write["dNX_GDP_UIP_TFP_mix"]*" & "*std_mussa_write["dNX_GDP_UIP_TFP_mix_fix"]
* "\\\\ \n");

write(io, "\\quad std(\$ \\Delta (1+i)\$) "
*"&&"*std_mussa_write["di_UIP_I_mix"]*" & "*std_mussa_write["di_UIP_I_mix_fix"]
*"&&"*std_mussa_write["di_UIP"]*" & "*std_mussa_write["di_UIP_fix"]
*"&&"*std_mussa_write["di_Risk"]*" & "*std_mussa_write["di_Risk_fix"]
*"&&"*std_mussa_write["di_UIP_TFP_mix"]*" & "*std_mussa_write["di_UIP_TFP_mix_fix"]
* "\\\\ \\hline \n");
close(io);



#############################################
# Robustness PCP DCP
#############################################
~,d_eta1,scaling_fix = wrapper_GMM(x,eta=1.5)

~,d_PCP_eta1,scaling_fix = wrapper_GMM(x,eta=1.5,theta_F_to_U_dollar=0,theta_U_to_F_dollar=1)

~,d_DCP_eta1,scaling_fix = wrapper_GMM(x,eta=1.5,theta_F_to_U_dollar=1,theta_U_to_F_dollar=1,theta_F_to_F_dollar=1)
plot_result_fun3(d_eta1,d_DCP_eta1,d_PCP_eta1,d1_label="LCP",d2_label="DCP",d3_label="PCP",
fig_save=fig_save,fig_name="Pricing",d1_ls=:solid,d2_ls=:dash,d3_ls=:dot)


#############################################
# Robustness tradable non-tradable
#############################################
~,d = wrapper_GMM(x)
target_T_share = 0.5
~,d_T_NT = wrapper_GMM(x,Tradable_share = target_T_share,T_NT_elasticity = 1.0, alph = 0.4*(1-omega)./target_T_share)
plot_result_fun2(d,
    d_T_NT,
    d2_label ="Two Sectors",
    T_NT = 1,
    fig_save = fig_save,
    fig_name = "")


#############################################
# Robustness HtM
#############################################
~,d = wrapper_GMM(x)
~,d_HtM = wrapper_GMM(x,HtMshare = 0.3)
plot_result_fun2(d_HtM,
    d,
    d2_label = "Hand to Mouth",
    HtM = 1,
    fig_save = fig_save,
    fig_name = "")




#############################################
# Robustness Price Stickiness
#############################################

deltap_alt = deltap/2
deltaw_alt = deltaw/2
kappap_alt = (1-deltap_alt)*(1-beta*deltap_alt)/deltap
kappaw_alt = (1-deltaw_alt)*(1-beta*deltaw_alt)/deltaw
x_alt = [kappap_alt,kappaw_alt,x[3]]
~,d_alt_price_sticky,scaling_fix = wrapper_GMM(x_alt)
plot_result_fun(d,data_irf,fig_all=1)
plot_result_fun2(d,
d_alt_price_sticky,
    d2_label = "Half Wage/Price Stickiness",
    price_stickiness = 1,
    fig_save = fig_save,
    fig_name = "alt_price_stickiness")
