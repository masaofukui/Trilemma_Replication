# this is the Jacobian Algorithm

function steady_state(guess,references_ss,P,set_functions_ss,leng)
    @assert (length(guess) == sum(leng["input"]));
    @assert (length(guess) == sum(leng["function"].*leng["output"]));

    x = guess;
    count = 0;


    maxcount = 200;
    while count < maxcount    # shouldn't take too many iterations!
        count = count + 1;
        # In the steady state, x stays the same for _m1, 0, _p1 (the third argument of input_mat)
        input_mat = repeat(x',outer = [1 1 3]);
        outputs,ders = all_computations(input_mat,references_ss,P,set_functions_ss,leng,ss=1)
        
        

        J = dropdims( sum(ders,dims = 4), dims=(1,4))
        J = sparse(J)
     
        y = outputs[:];


        error = maximum(abs.(y))
        println("error  = ",error)
        if error < 1E-10
            println("SS Found")
            break
        end
        println("Inverting...")
        xupdate = x - J\y;
        #update_index = 7:8 # update slowly only ell but not other variables (have to change for general N_D, K)
        #update_vec = ones(length(x))
        #update_vec[update_index] .= P["speed"]
        #x = update_vec.*xupdate + (ones(length(x))- update_vec).*x

        # make sure ell is bounded between zero and one
        #temp = xupdate[7:8]
        #temp[temp .>= 1] .= 1
        #temp[temp .<= 0] .= 0
        #xupdate[7:8] = temp
        
        x = P["speed"]*xupdate + (1 - P["speed"])*x
        #println(x)
        println("Inversion done")

    end
    
    @assert (count < maxcount)
    if count == maxcount
        println("Did not converge")
    end
    return x
end


# this is the Caliendo Dvorkin Parro Algorithm
function steady_state_Viter(P; Vold= 0)
    P["t"] = "ss"
    chi = P["chiss"]
    policy = P["policy"]
    if Vold == 0
        Vold = zeros(P["N_D"])
    end
    count_outer = 0
    max_outer = 1000
    W = []
    C = []
    Price = []
    Lumpsum = []
    R = []
    ell = []
    V = []
    Delta = []
    Vnew = []
    
    while count_outer < max_outer
        count_outer += 1
        mu_mat = mu_fun(P,Vold,chi)
        chain = DiscreteMarkovChain(mu_mat)
        ell = stationary_distribution(chain)
        ell[ell .< 0 ]  .= 1e-10
        ell = ell./sum(ell)
        NN = P["K"]*P["N_D"]
        lW = zeros(NN)
        Lumpsum = 1.0
        R = 1/P["beta"]
        lC = zeros(NN)

        # BE CAREFUL!!! THIS CODE IS NOT INCORPORATING HOUSING
        housing = zeros(NN)


        if policy == 0
            result = nlsolve(x -> ss_eqm_given_ell(P,ell,x[1:(end-1)],x[end],zeros(NN),mu_mat,policy =0)[1]
                ,[lW;Lumpsum],autodiff=:forward)
            @assert NLsolve.converged(result)
            lW = result.zero[1:(NN)]
            W = exp.(lW)
            R = 0
            Lumpsum = result.zero[NN+1]
            Price = Price_fun(P,W,ell);
            x = result.zero
            Delta = ss_eqm_given_ell(P,ell,x[1:(end-1)],x[end],zeros(NN),mu_mat,policy =0)[2]

            # saving rate
            phi = P["saving_phi"];
            eta = P["saving_eta"];
            PostTTIncome = W.*P["taxratess"].*Lumpsum;
            SNormalize = sum(ell .* PostTTIncome) / sum(ell .* (PostTTIncome .^ phi) .* exp.(eta));
            S = PostTTIncome .- (PostTTIncome .^ phi) .* exp.(eta) .* SNormalize;
            C = (W.*P["taxratess"] .* Lumpsum .- S)./Price;


        elseif policy == 1
            result = nlsolve(x -> ss_eqm_given_ell(P,ell,x[1:NN],x[NN+1],x[(NN+2):end],mu_mat,policy =1)[1]
                ,[lW;R;lC],autodiff=:forward)
            @assert NLsolve.converged(result)
            lW = result.zero[1:(NN)]
            W = exp.(lW)
            R = result.zero[NN+1]
            Lumpsum = 0
            Price = Price_fun(P,W,ell);
            lC = result.zero[(NN+2):end]
            C = exp.(lC)
            x = result.zero
            Delta =ss_eqm_given_ell(P,ell,x[1:NN],x[NN+1],x[(NN+2):end],mu_mat,policy =1)[2]
        end
        
        Viter_old = zeros(P["N_D"]*P["K"])
        count = 0
        maxcount_Viter = 1e4
        while count < maxcount_Viter
            count += 1
            Viter_new = V_fun(P,Viter_old,C,housing,chi);
            err = maximum(abs.(Viter_new - Viter_old))
            Viter_old = copy(Viter_new)
            if err < 1e-6
                println("V converged in iteration "*string(count))
                break
            end
        end
        @assert (count < maxcount_Viter)
        Vnew = copy(Viter_old)
        Verr = maximum(abs.(Vnew - Vold))
        println("Verr = "*string(Verr))

 

        Vold = P["speed"].*Vnew + (1-P["speed"])*Vold
        
        if Verr < 1e-6
            V = copy(Vnew)
            println("Steady State Equilibirum found")
            break
        end
    end

    @assert count_outer < max_outer

    #"lC,lPrice,lW,ell,V,Delta,R,Lumpsum"
    lC = log.(C)
    lPrice = log.(Price)
    lW = log.(W)


    ss_vec = [lC;lPrice;lW;ell;V;Delta;R;Lumpsum]
    
    return ss_vec

end





function ss_eqm_given_ell(P,ell,lW,Lumpsum_or_R,lC,mu_mat; policy = 1)
    W = exp.(lW)
    if P["t"] == "ss"
        taxrate = P["taxratess"]
    else
        taxrate = P["taxrate"][P["t"]]
    end
    Price = Price_fun(P,W,ell);
    Delta = []
    if policy == 0
        Lumpsum = Lumpsum_or_R
    else
        R = Lumpsum_or_R
    end

    if policy == 0

        # saving rate
        phi = P["saving_phi"];
        eta = P["saving_eta"];

        PostTTIncome = W.*taxrate.*Lumpsum;
        # make all PostTTIncome to avoid error
        #PostTTIncome[PostTTIncome .< 0] .= 1e-10
        SNormalize = sum(ell .* PostTTIncome) / sum(ell .* (PostTTIncome .^ phi) .* exp.(eta));
        S = PostTTIncome .- (PostTTIncome .^ phi) .* exp.(eta) .* SNormalize;

        # if any(isnan.(S)) == true
        #     S = zeros(P["N_D"]);
        # end

        C = (W.*ell.*taxrate .* Lumpsum - S.*ell)./(Price.*ell);
    else
        C = exp.(lC)
    end
    Wmat = reshape(W,P["K"],P["N_D"])
    ellmat = reshape(ell,P["K"],P["N_D"])

    L_demand = zeros(eltype(W),P["K"],P["N_D"])
    for k = 1:P["K"]
        lambda_mat = lambda_fun(P,Wmat[k,:],ellmat[k,:],k);
        x_k = export_fun(P,Wmat[k,:],k);

        domestic_demand = lambda_mat*(P["alph"][k,:].*Price.*C.*ell)
        if P["N_F"] >=1 
            L_demand[k,:] = domestic_demand + x_k;
        else
            L_demand[k,:] = copy(domestic_demand)
        end
    end
    NN = P["K"]*P["N_D"]

    # obtain housing supply
    H_bar = P["H_bar_ss"]
    h = H_bar ./ ell

    if policy == 0
        eval = zeros(eltype(W),NN+1)
        eval[1:(end-1)] = W.*ell - vec(reshape(L_demand,P["N_D"]*P["K"],1));
        eval[1] = Price[1] - 1;
        eval[end] = sum(Price.*C.*ell) - sum(W.*ell)
        Delta = inv(Diagonal(ones(NN)) - P["beta"].*mu_mat)*(W.*(1+P["gammaP"]) + Price./uprime(P,C,h).*P["gammaA"] -Price.*C)
    else
        eval = zeros(eltype(W),NN+1+NN)
        eval[1:NN] = W.*ell - vec(reshape(L_demand,P["N_D"]*P["K"],1));
        eval[1] = Price[1] - 1;
        eval[NN+1] = sum(Price.*C.*ell) - sum(W.*ell)

      
        Delta = inv(Diagonal(ones(NN)) - (1/R).*mu_mat)*(W.*(1+P["gammaP"]) + Price./uprime(P,C,h).*P["gammaA"]  -Price.*C)

        LHS = zeros(eltype(W),NN)
        RHS = zeros(eltype(W),NN)
        for id = 1:NN
            dlogmu_dV = -repeat(mu_mat[:,id], 1, NN);
            dlogmu_dV[:,id] .= dlogmu_dV[:,id] .+ 1;
            dmu_dV = P["theta"] * mu_mat.*dlogmu_dV;
            LHS[id] = sum(ell.*(dmu_dV*Delta));
            RHS1 = sum(ell.*mu_mat[:,id]).*Price[id]./(uprime(P,C[id],h[id])) ;
            RHS2 = -P["beta"].*R.*sum(ell.*mu_mat[:,id].*Price./uprime(P,C,h));
            RHS[id] = RHS1 + RHS2;
        end
       
        eval[(NN+2):end] = (LHS .- RHS)
        #eval[end] = Lumpsum

    end

    return eval,Delta
end


