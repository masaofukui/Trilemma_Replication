function compute_second_moments_diff(d,var1,var2;var1_lag = 1,var2_lag = 1)
    
    diff_v1 = [d[var1][var1_lag]; d[var1][(1+var1_lag):end] - d[var1][1:(end-var1_lag)]]
    diff_v2 = [d[var2][var2_lag]; d[var2][(1+var2_lag):end] - d[var2][1:(end-var2_lag)]]

    #diff_v2 = [d[var2][1]; diff(d[var2])]
    maxlength = min(length(diff_v1),length(diff_v2))
    second_moment = (sum(diff_v1[1:maxlength].*diff_v2[1:maxlength]))
    return second_moment
end

function compute_second_moments(d,var1,var2)
    #diff_v2 = [d[var2][1]; diff(d[var2])]
    second_moment = (sum(d[var1][1:end].*d[var2][1:end]))
    return second_moment
end

function compute_autocov(d,var1;auto_lag = 1)
    
    dv = d[var1]
    maxlength = length(dv) - auto_lag
    auto_cov = (sum(dv[1:maxlength].*dv[(auto_lag+1):end]))
    return auto_cov
end

function compute_autocov_diff(d,var1;auto_lag = 1,var1_lag=1)
    
    diff_v1 = [d[var1][var1_lag]; d[var1][(1+var1_lag):end] - d[var1][1:(end-var1_lag)]]

    #diff_v2 = [d[var2][1]; diff(d[var2])]
    maxlength = length(diff_v1) - auto_lag
    auto_cov = (sum(diff_v1[1:maxlength].*diff_v1[(auto_lag+1):end]))

    return auto_cov
end
function compute_autocorrelation(d,var1;auto_lag = 1)
    
    dv = d[var1]
    maxlength = length(dv) - auto_lag
    auto_cov = (sum(dv[1:maxlength].*dv[(auto_lag+1):end]))
    second_moment = (sum(dv[1:end].*dv[1:end]))

    auto_corr = auto_cov/second_moment
    return auto_corr
end

function compute_autocorrelation_diff(d,var1;auto_lag = 1,var1_lag=1)
    
    diff_v1 = [d[var1][var1_lag]; d[var1][(1+var1_lag):end] - d[var1][1:(end-var1_lag)]]

    #diff_v2 = [d[var2][1]; diff(d[var2])]
    maxlength = length(diff_v1) - auto_lag
    auto_cov = (sum(diff_v1[1:maxlength].*diff_v1[(auto_lag+1):end]))
    second_moment = (sum(diff_v1[1:end].*diff_v1[1:end]))

    auto_corr = auto_cov/second_moment
    return auto_corr
end


function second_moments_list(d_Disconnect;cty_set = ["U","P","F"])
    Covmat =  Dict{String,Any}()
    var_list_second = ["NER", "RER","C","GDP","I","NX_GDP","i"]
    for ctry in ["U","P","F"]
        for ivar1 in var_list_second
            ivar1_ctry = ivar1*"_"*ctry
            for ivar2 in var_list_second
                ivar2_ctry = ivar2*"_"*ctry
                Covmat[ivar1*"_"*ivar2*"_"*ctry] =  compute_second_moments(d_Disconnect,ivar1_ctry,ivar2_ctry)
                Covmat["d"*ivar1*"_d"*ivar2*"_"*ctry] =  compute_second_moments_diff(d_Disconnect,ivar1_ctry,ivar2_ctry)
                
                
            end
            Covmat["auto_"*ivar1*"_"*ctry] = compute_autocov(d_Disconnect,ivar1_ctry)
            Covmat["auto_d"*ivar1*"_"*ctry] = compute_autocov_diff(d_Disconnect,ivar1_ctry)
        end
    end
    for ivar1 in var_list_second
        for ivar2 in var_list_second
            Covmat[ivar1*"_"*ivar2] = 0.0;
            Covmat["d"*ivar1*"_d"*ivar2] = 0.0;
            for cc in cty_set
                Covmat[ivar1*"_"*ivar2]  += Covmat[ivar1*"_"*ivar2*"_"*cc] 
                Covmat["d"*ivar1*"_d"*ivar2] += Covmat["d"*ivar1*"_d"*ivar2*"_"*cc]
            end    
        end
        Covmat["auto_"*ivar1] = 0;
        Covmat["auto_d"*ivar1]  = 0;
        for cc in cty_set
            Covmat["auto_"*ivar1] += Covmat["auto_"*ivar1*"_"*cc]
            Covmat["auto_d"*ivar1] += Covmat["auto_d"*ivar1*"_"*cc] 
        end
    end
    return Covmat
end

function std_corr_list1(cov1)
    std_list = Dict{String,Any}()
    autocorr_list = Dict{String,Any}()
    var_list = ["GDP","C","I","NX_GDP","dNX_GDP","dNER","dGDP","dRER","RER","dC","dI","NER","di"]
    for var1 in var_list
        std_list[var1] = sqrt( cov1[var1*"_"*var1] )
        autocorr_list[var1] = ( cov1["auto_"*var1] )/(std_list[var1]^2)
    end

    var_list = ["GDP","C","NX_GDP","RER","I"]
    corr_list = Dict{String,Any}()
    for var1 in var_list
        for var2 in var_list
            corr_list[var1*"_"*var2] = ( cov1[var1*"_"*var2]  )/(std_list[var1]*std_list[var2])
            
        end

    end
    var_list = ["dGDP","dC","dRER","dI","dNX_GDP","dNER","di"]
    for var1 in var_list
        for var2 in var_list
            corr_list[var1*"_"*var2] = ( cov1[var1*"_"*var2]  )/(std_list[var1]*std_list[var2])
        end
    end

    return std_list, autocorr_list,corr_list
end
function std_corr_list2(cov1,cov2;weight1=1,weight2=1)
    cov3 = Dict{String,Any}()
    for (key,value) in cov1
        cov3[key] = weight1*cov1[key] + weight2*cov2[key]
    end
    std_list, autocorr_list,corr_list = std_corr_list1(cov3)
    return std_list, autocorr_list,corr_list,cov3
end

function std_corr_list3(cov1,cov2,cov3;weight1=1,weight2=1,weight3=1)
    cov4 = Dict{String,Any}()
    for (key,value) in cov1
        cov4[key] = weight1*cov1[key] + weight2*cov2[key] + weight3*cov3[key]
    end
    std_list, autocorr_list,corr_list = std_corr_list1(cov4)
    return std_list, autocorr_list,corr_list,cov4
end



function min_vol(cov1,cov2,weight2;target = 2.89,weight1=1,target_var = "dRER")

    std_mix,autocorr_mix,corr_mix = std_corr_list2(cov1,cov2,weight1 =weight1, weight2=weight2)
    rel_vol_RER_GDP = std_mix[target_var]/std_mix["dGDP"]


    obj = (rel_vol_RER_GDP - target).^2

    return obj,std_mix,autocorr_mix,corr_mix
end

function min_corr(cov1,cov2,weight2;target = -0.20,weight1 = 1)

    std_mix,autocorr_mix,corr_mix = std_corr_list2(cov1,cov2,weight1 =weight1, weight2=weight2)
    rel_vol_RER_GDP = std_mix["dNER"]/std_mix["dGDP"]

    rel_corr_RER_GDP = corr_mix["dC_dRER"]

    obj = (rel_corr_RER_GDP - target).^2

    return obj,std_mix,autocorr_mix,corr_mix
end



function match_vol_and_corr(d_DomesticDemand,d_DomesticUIP,rel_vol,rel_cov)
    d_correlated = Dict{String,Any}()
    for item in d_DomesticUIP
        d_correlated[item.first] = rel_cov.*d_DomesticDemand[item.first] + 
        rel_vol.*d_DomesticUIP[item.first]
    end

    Cov_correlated = second_moments_list(d_correlated)
    Cov_DomesticUIP = second_moments_list(d_DomesticUIP)

    Cov_correlated_combined = Dict{String,Any}()
    for item in Cov_DomesticUIP
        Cov_correlated_combined[item.first] = Cov_correlated[item.first] .+  
            Cov_DomesticUIP[item.first] 
    end
    rel_vol_RER_GDP = (sqrt(Cov_correlated_combined["dNER_dNER"])/sqrt(Cov_correlated_combined["dGDP_dGDP"]))

    rel_corr_RER_GDP = Cov_correlated_combined["dGDP_dRER"] / (sqrt(Cov_correlated_combined["dRER_dRER"])*sqrt(Cov_correlated_combined["dGDP_dGDP"]))

    if rel_vol != 0
        obj = (rel_vol_RER_GDP - 3).^2 + (rel_corr_RER_GDP+0.17).^2
    else
        obj = (rel_vol_RER_GDP - 3).^2;
    end
    return obj,Cov_correlated_combined,d_correlated
end



function Choose_GammaD(cov1,GammaD,x;smallopen = 0, corr_target = 0.0,vol_target = 2.89,weight1=1,
    target_var = "dRER",cty = "F",is="Risk",corr_target_var = "GDP")

    ~,d2_temp = wrapper_GMM(x,GammaD = GammaD,Shock_Var = cty*" "*is*" shock",scaling=1,smallopen=smallopen)

    cov2 = second_moments_list(d2_temp,cty_set = ["F"])

    weight2_choice = optimize(x-> min_vol(cov1,cov2,x,target = vol_target,target_var = target_var)[1], 0,100)
    weight2 = weight2_choice.minimizer

    std_mix,autocorr_mix,corr_mix = std_corr_list2(cov1,cov2,weight1 =weight1, weight2=weight2)
    rel_vol_RER_GDP = std_mix[target_var]/std_mix["dGDP"]
    corr_RER_GDP = corr_mix["dRER_d"*corr_target_var]

    println("Corr = ",corr_RER_GDP)
    println("std(dNER)/std(dGDP) = ", std_mix[target_var]/std_mix["dGDP"])


    obj =  (corr_RER_GDP - corr_target).^2

    return obj,std_mix,autocorr_mix,corr_mix
end
