function set_parameters(;
    N = 4,
    T = 200,
    eta = 0.5,
    sig = 2,
    bars = 0.0,
    gamma_w = 1.0,
    alph = 0.2,
    nu = 1,
    Zss_in = "",
    betass_in = "",
    first_order=1,
    Taylor = 0,
    betashock = zeros(N,T),
    UIPshock = zeros(N,T),
    dlnrshock = zeros(N,T),
    terminal_condition = "Qzero",
    phi_pi = 1.5,
    phi_beta = 0.8,
    size = 1 ./N*ones(N)
    )

    P = Dict{String,Any}()
    P["N"] = N;
    P["autodiff"] = 0;
    P["alph"] = alph;
    P["bars"] = bars;
    P["gamma"] = 10;
    if Zss_in == ""
        P["Zss"] = ones(P["N"]);
    else
        P["Zss"] = Zss_in;
    end
    P["first_order"] = first_order;

    if betass_in == ""
        beta_ss = 0.96
        P["beta_ss"] = beta_ss;
        P["betass"] = beta_ss*ones(P["N"]);
    else
        P["betass"] = betass_in;
    end
    P["T"] = T;
    P["sig"] = sig;
    P["eta"] = eta;
    P["nu"] = nu;
    P["kappa_w"] = (1-gamma_w)/gamma_w.*(1-beta_ss.*gamma_w)
    P["terminal_condition"] = terminal_condition;
    P["Taylor"] = Taylor;
    P["phi_pi"] = phi_pi;
    P["phi_beta"] = phi_beta;
    
    Ztemp = []
    betatemp = [];
    MP_shock_temp = [];
    UIP_shock_temp = [];
    dlnr_shock_temp = [];

    rho_Z = 0.5;
    rho_MP = 0.5;
    initial_Z = 0.000;
    initial_MP_shock = 0.001;



    for t = 1:P["T"]
        Zinput = copy(P["Zss"]);
        Zinput[1] = P["Zss"][1]*exp(initial_Z*rho_Z^(t-1));
        MP_shock_input = zeros(P["N"]);
        MP_shock_input[1] = initial_MP_shock*rho_MP^(t-1);
        betainput = P["betass"].*exp.(betashock[:,t]);
        UIPinput = UIPshock[:,t];
        dlnrinput = dlnrshock[:,t];
        push!(Ztemp,Zinput)
        push!(betatemp,betainput)
        push!(MP_shock_temp,MP_shock_input)
        push!(UIP_shock_temp,UIPinput)
        push!(dlnr_shock_temp,dlnrinput)
    end
    P["Z"] = Ztemp;
    P["beta"] = betatemp;
    P["dlnr_shock"] = dlnr_shock_temp;
    P["MP_shock"] = MP_shock_temp;
    P["UIP_shock"] = UIP_shock_temp;
    P["speed"] = 1.0;
    P["solve_terminal"] = 1
    P["barv"] = 1.0;
    P["Taylor"] = Taylor;
    P["rss"] = 1 ./P["betass"] .- 1
    P["size"] = size;

    return P
end