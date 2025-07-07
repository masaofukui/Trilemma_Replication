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
file_overleaf = "./Theory/Quantitative_Model/figures"
tables_overleaf = "./Theory/Quantitative_Model/tables"
stored_results = "Empirics/Stored_Result"
include("./functions_SSJ_solver.jl")
include("./functions_load_data.jl")
include("./functions_plot.jl")
include("./functions_solve_ss.jl")
include("./functions_cov_fun.jl")
include("./functions_construct_IRF.jl")
include("./functions_model_equations.jl")
include("./functions_set_other_parameters.jl")
include("./functions_Shock_constructor.jl")
include("./functions_compute_steady_state.jl")
include("./functions_GMM.jl")

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
#scaling = "matchIRF"
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
# Figures E1 and E2
###############################################################

list_model = ["relative_NER","relative_RER","relative_Y", "relative_C", "relative_I",
"relative_pi","relative_i" ,"relative_exp","relative_imp","relative_ToT"]

list_data = ["lnominal","lreal", "RGDP_WB", "consumption_WB",  "investment_WB", 
"inflation_WB","bloomberg_rate_all","exports_WB","imports_WB","lTerms_of_trade_WB"]

nvar = Int(length(varargin)/2);
allinputs = replace(allinputs_string,"\n" => "")
allinputs = split(allinputs,',');


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

~,d,scaling_fix = wrapper_GMM(x)

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

if fig_save == 1
    fig_name_old = string(file_overleaf,"/fig_all_split_1.pdf")
    fig_name_new = string(file_overleaf,"/Figure_E1.pdf")
    cp(fig_name_old, fig_name_new,force=true)
    fig_name_old = string(file_overleaf,"/fig_all_split_2.pdf")
    fig_name_new = string(file_overleaf,"/Figure_E2.pdf")
    cp(fig_name_old, fig_name_new,force=true)
end


###############################################################
# Table E1 and Figure G5
###############################################################

~,d_UIP,scaling_fix = wrapper_GMM(x)
~,d_MP,scaling_fix = wrapper_GMM(x,Shock_Var = "U MP shock")
~,d_Tech,scaling_fix = wrapper_GMM(x,Shock_Var = "U TFP shock")
~,d_Inv,scaling_fix = wrapper_GMM(x,Shock_Var = "U Risk shock")

write_table_ner_i(data_irf,d_UIP,d_MP,d_Tech,d_Inv;fig_save=fig_save)
if fig_save == 1
    table_name_old = string(tables_overleaf,"/NER_i_IRF.txt")
    table_name_new = string(tables_overleaf,"/Table_E1.txt")
    cp(table_name_old, table_name_new,force=true)
end

plot_result_fun(d_Inv,
    data_irf;
    fig_save = fig_save,
    fig_name = "Risk_shock",
    fig_all = 1)
if fig_save == 1
    fig_name_old = string(file_overleaf,"/fig_all_Risk_shock.pdf")
    fig_name_new = string(file_overleaf,"/Figure_G5.pdf")
    cp(fig_name_old, fig_name_new,force=true)
end



###############################################################
# Figure E3
###############################################################

~,d_no_s = wrapper_GMM(x,s_share = 0.0)

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

if fig_save == 1
    fig_name_old = string(file_overleaf,"/GammaD_no_GammaD.pdf")
    fig_name_new = string(file_overleaf,"/Figure_E3.pdf")
    cp(fig_name_old, fig_name_new,force=true)
end

##########################################################################################
# Table E2
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
if fig_save == 1
    table_name_old = string(tables_overleaf,"/Falsify.txt")
    table_name_new = string(tables_overleaf,"/Table_E2.txt")
    cp(table_name_old, table_name_new,force=true)
end

##########################################################################################
# Figure F1
###########################################################################
smallopen_set = 0;
corr_target_var = "GDP"

include("./load_business_cycle_moments.jl")



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
country_list =["F"],Tplot=20,label1="Floaters float",label2="Floaters peg",
fig_save=fig_save,fig_name="three_risk_shock_irf",three=1)

plot_model_two_fun(d_list["F_UIP"],d_list["F_UIP_fix"],
country_list =["F"],Tplot=20,label1="Floaters float",label2="Floaters peg",
fig_save=fig_save,fig_name="three_uip_shock_irf",three=1)

if fig_save == 1
    fig_name_old = string(file_overleaf,"/three_uip_shock_irf.pdf")
    fig_name_new = string(file_overleaf,"/Figure_F1_1.pdf")
    cp(fig_name_old, fig_name_new,force=true)
    fig_name_old = string(file_overleaf,"/three_risk_shock_irf.pdf")
    fig_name_new = string(file_overleaf,"/Figure_F1_2.pdf")
    cp(fig_name_old, fig_name_new,force=true)
end




##########################################################################################
# Table F1
###########################################################################

second_shock_name = "F_Risk"
optsol = optimize(x-> min_vol(Cov_list["F_UIP"],Cov_list[second_shock_name],x,target = target_vol,target_var = target_vol_var)[1], 0,100)
weightsol_mix = optsol.minimizer
gdp_vol  = Cov_list["F_UIP"]["dGDP_dGDP"] + weightsol_mix*Cov_list[second_shock_name]["dGDP_dGDP"]
UIP_weight = gdp_std_data^2/gdp_vol;
Investment_weight = weightsol_mix*UIP_weight
~,std_list["F_UIP_I_mix"],autocorr_list["F_UIP_I_mix"],corr_list["F_UIP_I_mix"] = min_vol(Cov_list["F_UIP"],Cov_list[second_shock_name],Investment_weight,weight1 = UIP_weight )
~,std_list["F_UIP_I_mix_fix"],autocorr_list["F_UIP_I_mix_fix"],corr_list["F_UIP_I_mix_fix"] = min_vol(Cov_list["F_UIP_fix"],Cov_list[second_shock_name*"_fix"],Investment_weight,weight1 = UIP_weight )

target_Mussa = std_list["F_UIP_I_mix"][target_vol_var]/std_list["F_UIP_I_mix"]["dGDP"]


optsol = optimize(x-> min_vol(Cov_list["F_UIP"],Cov_list["F_TFP"],x,target = target_Mussa,target_var = target_vol_var)[1], 0,100)
weightsol_mix = optsol.minimizer
gdp_vol  = Cov_list["F_UIP"]["dGDP_dGDP"] + weightsol_mix*Cov_list["F_TFP"]["dGDP_dGDP"]
overall_weight = gdp_std_data^2/gdp_vol;
~,std_list["F_UIP_TFP_mix"],autocorr_list["F_UIP_TFP_mix"],corr_list["F_UIP_TFP_mix"] = min_vol(Cov_list["F_UIP"],Cov_list["F_TFP"],weightsol_mix*overall_weight,weight1 = overall_weight )

~,std_list["F_UIP_TFP_mix_fix"],autocorr_list["F_UIP_TFP_mix_fix"],corr_list["F_UIP_TFP_mix_fix"] = min_vol(Cov_list["F_UIP_fix"],Cov_list["F_TFP_fix"],weightsol_mix*overall_weight,weight1 = overall_weight )


# for \bar s = 0 
optsol = optimize(x-> min_vol(Cov_list["F_UIP_nos"],Cov_list["F_TFP_nos"],x,target = target_Mussa,target_var = target_vol_var)[1], 0,100)
weightsol_mix = optsol.minimizer
gdp_vol  = Cov_list["F_UIP_nos"]["dGDP_dGDP"] + weightsol_mix*Cov_list["F_TFP_nos"]["dGDP_dGDP"]
overall_weight = gdp_std_data^2/gdp_vol;
~,std_list["F_UIP_TFP_mix_nos"],autocorr_list["F_UIP_TFP_mix_nos"],corr_list["F_UIP_TFP_mix_nos"] =
 min_vol(Cov_list["F_UIP_nos"],Cov_list["F_TFP_nos"],weightsol_mix*overall_weight,weight1 = overall_weight )

~,std_list["F_UIP_TFP_mix_fix_nos"],autocorr_list["F_UIP_TFP_mix_fix_nos"],corr_list["F_UIP_TFP_mix_fix_nos"] = 
min_vol(Cov_list["F_UIP_fix_nos"],Cov_list["F_TFP_fix_nos"],weightsol_mix*overall_weight,weight1 = overall_weight )

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

if fig_save == 1
    table_name_old = string(tables_overleaf,"/disconnect_table.txt")
    table_name_new = string(tables_overleaf,"/Table_F2.txt")
    cp(table_name_old, table_name_new,force=true)
end



##########################################################################################
# Figure H2
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
    fig_name_save = string(file_overleaf,"/Figure_H2.pdf")
    savefig(fig_name_save)
end

##########################################################################################
# Table F3
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

if fig_save == 1
    table_name_old = string(tables_overleaf,"/mussa_table.txt")
    table_name_new = string(tables_overleaf,"/Table_F3.txt")
    cp(table_name_old, table_name_new,force=true)
end


#############################################
# Figure G2
#############################################
~,d_eta1,scaling_fix = wrapper_GMM(x,eta=1.5)

~,d_PCP_eta1,scaling_fix = wrapper_GMM(x,eta=1.5,theta_F_to_U_dollar=0,theta_U_to_F_dollar=1)

~,d_DCP_eta1,scaling_fix = wrapper_GMM(x,eta=1.5,theta_F_to_U_dollar=1,theta_U_to_F_dollar=1,theta_F_to_F_dollar=1)
plot_result_fun3(d_eta1,d_DCP_eta1,d_PCP_eta1,d1_label="LCP",d2_label="DCP",d3_label="PCP",
fig_save=fig_save,fig_name="Pricing",d1_ls=:solid,d2_ls=:dash,d3_ls=:dot)

if fig_save == 1
    fig_name_old = string(file_overleaf,"/Pricing_Pricing.pdf")
    fig_name_new = string(file_overleaf,"/Figure_G2.pdf")
    cp(fig_name_old, fig_name_new,force=true)
end


#############################################
# Figure G3
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
if fig_save == 1
    fig_name_old = string(file_overleaf,"/T_NT_.pdf")
    fig_name_new = string(file_overleaf,"/Figure_G3.pdf")
    cp(fig_name_old, fig_name_new,force=true)
end

#############################################
# Figure G4
#############################################
~,d = wrapper_GMM(x)
~,d_HtM = wrapper_GMM(x,HtMshare = 0.3)
plot_result_fun2(d_HtM,
    d,
    d2_label = "Hand to Mouth",
    HtM = 1,
    fig_save = fig_save,
    fig_name = "")

if fig_save == 1
    fig_name_old = string(file_overleaf,"/HtM_.pdf")
    fig_name_new = string(file_overleaf,"/Figure_G4.pdf")
    cp(fig_name_old, fig_name_new,force=true)
end


#############################################
# Robustness Price Stickiness
#############################################

deltap_alt = deltap/2
deltaw_alt = deltaw/2
kappap_alt = (1-deltap_alt)*(1-beta*deltap_alt)/deltap
kappaw_alt = (1-deltaw_alt)*(1-beta*deltaw_alt)/deltaw
x_alt = [kappap_alt,kappaw_alt,x[3]]
~,d_alt_price_sticky,scaling_fix = wrapper_GMM(x_alt)
plot_result_fun2(d,
d_alt_price_sticky,
    d2_label = "Half Wage/Price Stickiness",
    price_stickiness = 1,
    fig_save = fig_save,
    fig_name = "alt_price_stickiness")
if fig_save == 1
    fig_name_old = string(file_overleaf,"/risk_alt_price_stickiness.pdf")
    fig_name_new = string(file_overleaf,"/Figure_G5.pdf")
    cp(fig_name_old, fig_name_new,force=true)
end