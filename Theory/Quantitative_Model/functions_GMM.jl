
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
