# Set working directory to the project root
cd("/Users/fukui/Dropbox (Personal)/Trilemma/Trilemma_Replication/Theory/Julia")

include("load_packages.jl")
include("set_parameters.jl")

fig_save = 1
colplot = palette(:Blues_4);
colplot_green = palette(:Greens_4);
colplot_blue = palette(:Blues_3);
colplot_orange = palette(:Oranges_4);
colplot_accent = palette(:Accent_3);

file_overleaf = "././figures"
#tables_overleaf = "/Users/fukui/Dropbox (Personal)/Apps/Overleaf/Trilemma -- Paper/Tables"
#stored_results = "/Users/fukui/Dropbox (Personal)/Trilemma/Result"
P = set_parameters(N=4);
T = P["T"];

include("./Sequence_Space_Solver.jl")
include("./compute_steady_state.jl")
include("./Model_equations.jl")
include("./construct_IRF.jl")
include("./plot_functions.jl")
include("./solve_staedy_state_brute_force.jl")
ss0_init = zeros(sum(leng["input"] ))

rho_UIP = 0.8;
rho_beta = 0.5;
rho_beta_US = 0.9;
rho_r = 0.5;
rho_r_US = 0.7;
initial_beta_shock_size = 0.6;
initial_beta_shock_size_US = 0.6;
initial_UIP_shock_size = 0.5;
initial_r_shock_size = 0.08;
initial_r_shock_size_US = 0.5;
UIPshock = zeros(P["N"],P["T"])
betashock = zeros(P["N"],P["T"])
betashock_US_only = zeros(P["N"],P["T"])
dlnrshock = zeros(P["N"],P["T"])
dlnrshock_US_only = zeros(P["N"],P["T"])
for t=1:P["T"]
    UIPshock[1:2,t] .= rho_UIP.^(t-1).*(1-rho_UIP).*initial_UIP_shock_size;
    UIPshock[3:4,t] .= -rho_UIP.^(t-1).*(1-rho_UIP).*initial_UIP_shock_size;

    betashock[:,t] .= rho_beta.^(t-1).*initial_beta_shock_size;
    betashock_US_only[1,t] = rho_beta_US.^(t-1).*initial_beta_shock_size_US;
    dlnrshock[:,t] .= -P["phi_beta"].*betashock[:,t];
    dlnrshock_US_only[1:2,t] = -2 .*UIPshock[1:2,t];
end

bars = 0.5;
sig = bars/1.5;

#=
##########################################
# Illustrate Diff-in-Diff (UIP + global beta)
##########################################


P = set_parameters(UIPshock = UIPshock,bars=bars,sig=sig);
ss0 = steady_state(ss0_init,references_ss,P,set_functions_ss,leng)
xfull = system_solve(ss0,ss0,references,P,set_functions,P["T"],leng, trate = 0.06);
d1 = construct_IRF(P,xfull,allinputs,leng; ss = 0)

P = set_parameters(UIPshock = UIPshock,bars=bars,sig=sig,betashock=betashock,dlnrshock=dlnrshock);
ss0 = steady_state(ss0_init,references_ss,P,set_functions_ss,leng)
xfull = system_solve(ss0,ss0,references,P,set_functions,P["T"],leng, trate = 0.06);
d2 = construct_IRF(P,xfull,allinputs,leng; ss = 0)



plt_shock_list = shock_plot(UIPshock,betashock,dlnrshock
    ,label1="UIP Shock",label2="Discount Factor / UIP Shock")
plot(plt_shock_list["UIPshock"],plt_shock_list["dlnrshock"],plt_shock_list["betashock"],layout=(1,3),size=(1350,300))
plot!(margin=6mm)
if fig_save == 1
    savefig(file_overleaf*"/shock_series.pdf")
end

plt_list = create_plot(d1,d2
,label1="UIP Shock",label2="Discount Factor / UIP Shock")
plot(
plt_list["dlnr"],plt_list["dlnQ"],plt_list["dlnY"],layout=(1,3),size=(1350,300))
plot!(margin=6mm)
if fig_save == 1
    savefig(file_overleaf*"/dlnr_dlnQ_dlnY_beta.pdf")
end
plot(plt_list["nabla_dlnr"],plt_list["nabla_dlnQ"],plt_list["nabla_dlnY"],layout=(1,3),size=(1350,300))
plot!(margin=6mm)
if fig_save == 1
    savefig(file_overleaf*"/nabla_dlnr_dlnQ_dlnY_beta.pdf")
end




##########################################
# Illustrate Diff-in-Diff (r shock)
##########################################
P = set_parameters(UIPshock = UIPshock,bars=bars,sig=sig);
ss0 = steady_state(ss0_init,references_ss,P,set_functions_ss,leng)
xfull = system_solve(ss0,ss0,references,P,set_functions,P["T"],leng, trate = 0.06);
d1_r = construct_IRF(P,xfull,allinputs,leng; ss = 0)

P = set_parameters(bars=bars,sig=sig,dlnrshock=dlnrshock_US_only);
ss0 = steady_state(ss0_init,references_ss,P,set_functions_ss,leng)
xfull = system_solve(ss0,ss0,references,P,set_functions,P["T"],leng, trate = 0.06);
d2_r = construct_IRF(P,xfull,allinputs,leng; ss = 0)

plt_shock_list = shock_plot(UIPshock,betashock,dlnrshock_US_only
    ,label1="\\psi",label2="\\psi & \\beta ")
plot(plt_shock_list["UIPshock"],plt_shock_list["dlnrshock"],plt_shock_list["betashock"],layout=(1,3),size=(1350,300))
plot!(margin=6mm)
if fig_save == 1
    savefig(file_overleaf*"/shock_series_r.pdf")
end



plt_list_r = create_plot(d1_r,d2_r,label1="\\psi",label2="r")
plot(
    plt_list_r["dlnr"],plt_list_r["dlnQ"],plt_list_r["dlnY"],layout=(1,3),size=(1350,300))
plot!(margin=6mm)
if fig_save == 1
    savefig(file_overleaf*"/dlnr_dlnQ_dlnY_r.pdf")
end
plot(plt_list_r["nabla_dlnr"],plt_list_r["nabla_dlnQ"],plt_list_r["nabla_dlnY"],layout=(1,3),size=(1350,300))
plot!(margin=6mm)
if fig_save == 1
    savefig(file_overleaf*"/nabla_dlnr_dlnQ_dlnY_r.pdf")
end
=#
##########################################
# Illustrate foreign credit channel
##########################################
P = set_parameters(UIPshock = UIPshock,bars=bars,sig=sig);
ss0 = steady_state(ss0_init,references_ss,P,set_functions_ss,leng)
xfull = system_solve(ss0,ss0,references,P,set_functions,P["T"],leng, trate = 0.06);
d1_bars = construct_IRF(P,xfull,allinputs,leng; ss = 0)

P = set_parameters(UIPshock = UIPshock,bars=0.0,sig=sig);
ss0 = steady_state(ss0_init,references_ss,P,set_functions_ss,leng)
xfull = system_solve(ss0,ss0,references,P,set_functions,P["T"],leng, trate = 0.06);
d2_bars = construct_IRF(P,xfull,allinputs,leng; ss = 0)


plt_list_bars = create_plot(d1_bars,d2_bars,label1="s > 0",label2="s = 0")

plot(plt_list_bars["nabla_dlnQ"],plt_list_bars["nabla_dlnY"],plt_list_bars["nabla_dlnC"],plt_list_bars["nabla_dlnXM"],layout=(2,2),size=(800,500))
plot!(margin=3mm)
if fig_save == 1
    savefig(file_overleaf*"/Figure_11.pdf")
end




##########################################
# Exchange rate disconnect
##########################################
phi_pi = 1.0
phi_beta = 0.6;
sizevec = [0.00001,0.00001,0.000001,0.0000001]
#sizevec = [0.25,0.25,0.25,0.25]
sizevec[end] = 1 - sum(sizevec[1:end-1])
UIPshock_US_only = zeros(P["N"],P["T"])
UIPshock_US_only[1:2,:] .= UIPshock[1:2,:] ;



P = set_parameters(betashock = betashock_US_only,bars=bars,sig=sig, Taylor=1,size=sizevec,terminal_condition="Qzero",phi_pi=phi_pi,phi_beta=phi_beta);
ss0 = steady_state(ss0_init,references_ss,P,set_functions_ss,leng)
xfull = system_solve(ss0,ss0,references,P,set_functions,P["T"],leng, trate = 0.06);
d1_US_beta = construct_IRF(P,xfull,allinputs,leng; ss = 0)

P = set_parameters(betashock = betashock_US_only,bars=bars,sig=sig, Taylor=-1,size=sizevec,terminal_condition="Qzero",phi_pi=phi_pi,phi_beta=phi_beta);
ss0 = steady_state(ss0_init,references_ss,P,set_functions_ss,leng)
xfull = system_solve(ss0,ss0,references,P,set_functions,P["T"],leng, trate = 0.06);
d2_US_beta_peg = construct_IRF(P,xfull,allinputs,leng; ss = 0)


plt_list_US_beta = create_plot_for_unconditional(d1_US_beta,d2=d2_US_beta_peg, shockplot=betashock_US_only,shock_label="\\beta_U",label1="Float", label2="Peg",Tplot=10,lw=7)
plot(plt_list_US_beta["dlnr"],plt_list_US_beta["dlnQ"],plt_list_US_beta["dlnY"],layout=(1,3),size=(1200,300))
plot!(margin=5mm)
if fig_save == 1
    savefig(file_overleaf*"/Figure_12_b.pdf")
end

plot(plt_list_US_beta["pid"])

P = set_parameters(UIPshock = UIPshock_US_only,bars=bars,sig=sig, Taylor=1,size=sizevec,terminal_condition="Qzero",phi_pi=phi_pi,phi_beta=phi_beta);
ss0 = steady_state(ss0_init,references_ss,P,set_functions_ss,leng)
xfull = system_solve(ss0,ss0,references,P,set_functions,P["T"],leng, trate = 0.06);
d1_US_psi = construct_IRF(P,xfull,allinputs,leng; ss = 0)

P = set_parameters(bars=bars,sig=sig);
ss0 = steady_state(ss0_init,references_ss,P,set_functions_ss,leng)
xfull = system_solve(ss0,ss0,references,P,set_functions,P["T"],leng, trate = 0.06);
d2_US_psi_peg = construct_IRF(P,xfull,allinputs,leng; ss = 0)

plt_list_US_psi = create_plot_for_unconditional(d1_US_psi,d2=d2_US_psi_peg,shockplot=betashock_US_only,shock_label="\\psi",
    label1="Float", label2="Peg",lw=7)
plot(plt_list_US_psi["dlnr"],plt_list_US_psi["dlnQ"],plt_list_US_psi["dlnY"],layout=(1,3),size=(1200,300))
plot!(margin=5mm)
if fig_save == 1
    savefig(file_overleaf*"/Figure_12_a.pdf")
end
