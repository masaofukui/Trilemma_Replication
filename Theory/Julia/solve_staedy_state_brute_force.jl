function solve_steady_state(P,w,R,C,Xi)
    alph_const = 1/(P["alph"]^P["alph"]*(1-P["alph"])^(1-P["alph"]))



    p_mc = alph_const./P["Zss"].*w.^(1-P["alph"]).*Xi.^P["alph"];
    pij_mat = p_mc.*P["tauss"]
    Price = Price_index_fun(P,pij_mat);
    lambda_mat = lambda_fun(P,pij_mat);

    L = (uprime(P,C).*w./Price./P["barv"]).^(1/P["nu"])


    Rij_mat = R./P["kappass"]
    portfolio_mat = portfolio_fun(P,Rij_mat);

    Rp = Return_index_fun(P,Rij_mat);
    Profit = zeros(P["N"]);
    A = (Price.*C  .- w.*L .- (1-P["omega"])*Profit )./(Rp .-1);

    Q = (Xi .+ P["omega"].*Profit./P["K"])./(R .-1);

    F = zeros(P["N"])
    for i = 1:P["N"]
        F[i] = sum( portfolio_mat[i,:].*(Rij_mat[i,:].*P["kappass"][i,:] - Rij_mat[i,:]) )*A[i]
    end

    Labor_clearing = zeros(P["N"])
    Capital_clearing = zeros(P["N"])
    Asset_clearing = zeros(P["N"])
    Euler = zeros(P["N"])
    for i = 1:P["N"]
        Labor_clearing[i] = (1-P["alph"]).*sum( lambda_mat[i,:].*(Price.*C + F)) - w[i].*L[i]
        Capital_clearing[i] = P["alph"].*sum( lambda_mat[i,:].*(Price.*C + F) ) - Xi[i].*P["K"][i]
        Asset_clearing[i] =  sum(portfolio_mat[:,i].*A)- Q[i]*P["K"][i]
        Euler[i] = P["betass"][i]*Rp[i] - 1;
    end

    eval_return = vcat(Labor_clearing,Capital_clearing,Asset_clearing,Euler)
    eval_return[1] = w[1] - 1;
    others  = (L = L, Q = Q, A=A, Rp=Rp, Profit=Profit, p_mc=p_mc, pij_mat = pij_mat, Rij_mat = Rij_mat,
    Price = Price,F=F,portfolio_mat=portfolio_mat,lambda_mat = lambda_mat)
    return eval_return,others
end

function solve_steady_state_in(P,x)
    w = exp.(x[1:P["N"]])
    R = exp.(x[(P["N"]+1):(2*P["N"])])
    C = exp.(x[(2*P["N"]+1):(3*P["N"])])
    Xi = exp.(x[(3*P["N"]+1):(4*P["N"])])

    eval_return, others = solve_steady_state(P,w,R,C,Xi)


    all_var = (others..., w = w, R = R, C = C, Xi = Xi)

    return eval_return, all_var
end

function steady_state_wrapper(P)
    C = ones(P["N"])
    R = 1.2*ones(P["N"]);
    Xi = 1.0*ones(P["N"]);
    w = 1.0*ones(P["N"]);
    P["ss"] = 1
    P["t"] = 0;
    x = vcat(log.(w),log.(R),log.(C),log.(Xi))
    result = nlsolve(x-> solve_steady_state_in(P,x)[1],x,xtol=1e-11,ftol=1e-11)
    x = result.zero

    all_var = solve_steady_state_in(P,x)[2]

    ss0_init = vcat(
        log.(all_var.C),
        log.(all_var.L),
        log.(all_var.Price),
        log.(all_var.w),
        log.(all_var.A),
        log.(all_var.Rp),
        log.(all_var.Xi),
        all_var.F,
        log.(all_var.R),
        zeros(P["N"]),
        zeros(P["N"]),
        log.(all_var.Q),
        all_var.Profit,
        log.(all_var.p_mc),
        log.(all_var.pij_mat[:]),
        zeros(P["N"]*P["N"]),
        log.(all_var.Rij_mat[:])
    )

    aux_var = (
        portfolio_mat = all_var.portfolio_mat,
        lambda_mat = all_var.lambda_mat
    )

    return ss0_init,aux_var

end