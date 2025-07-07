

function data_load()
    data_irf = Dict{String,Any}()

    var_list = ["exports_WB", "imports_WB","RGDP_WB","consumption_WB","lexport_price_WB",
    "limport_price_WB","lTerms_of_trade_WB",
    #"TBill_rate","real_rate_TBill","nominal_interest_rate","real_rate_ni",
    "inflation_WB",
    "lnominal", "lreal","net_exports_WB",
    "lexport_price_WB_local","limport_price_WB_local","investment_WB","bloomberg_rate_all","real_rate_all_bloomberg","UIP_deviation"]
    for variable_name in var_list
        println(variable_name)
        filename = string(stored_results*"/IRF_coef/IRF_1_", variable_name, ".csv")
        data, header = readdlm(filename, ',', header= true);
        df =  DataFrame(data, vec(header));
        df = filter(:horizon => >=(0),df)
        #df_new = identity.( DataFrame(data, vec(header)))
        data_irf[variable_name] = df
    end
    return data_irf
end

function compute_data_minus_irf(data,model)
    Tcut = 10;
    std = ( data[!,:up95] -  data[!,:bh] )./1.96
    std = 1;
    #std = mean(std)
    diff_data_model =  ( data[!,:bh] - model[1:10] ) ./ std
    sumdiff = sum( diff_data_model[1:Tcut].^2);
    return sumdiff
end