
Budget_def = Vector{Function}(undef,1)
Budget_def[1] = function(P,dlnC,dlnY,dlnpP,da,da_m1)

    
    eval = dlnC .+ da .- (dlnY .+ dlnpP .+ (1 .+P["rss"]).*da_m1)

    return eval
end


ToT_def = Vector{Function}(undef,1)
ToT_def[1] = function(P,dlnpP,dlnQ)

    
    eval = dlnpP .- ( - P["alph"]./(1-P["alph"])) .* ( dlnQ  .+ sum(P["size"].*dlnpP) )
 
    return eval
end


dlnrp_def = Vector{Function}(undef,1)
dlnrp_def[1] = function(P,dlnQ,dlnQ_p1,dlnr,dlnrp)
    if P["t"] == P["T"]
        eval = dlnrp .-  (1-P["bars"]).*dlnr .- P["bars"].*( sum(P["size"].*dlnr) .+ dlnQ .- dlnQ)
    else
        eval = dlnrp .-  (1-P["bars"]).*dlnr .- P["bars"].*( sum(P["size"].*dlnr) .+ dlnQ_p1 .- dlnQ)
    end
    return eval
end

Goods_clear_def = Vector{Function}(undef,1)
Goods_clear_def[1] = function(P,dlnQ,dlnC,dlnY,dlnpP)

    eval = dlnY .-  (
        (1-P["alph"]).*dlnC .+ (P["eta"].*P["alph"]./(1-P["alph"]) .+ P["eta"].*P["alph"]).*dlnQ
        .+ P["eta"].*P["alph"]./(1-P["alph"]) .* sum(P["size"].*dlnpP) .+ P["alph"].*sum(P["size"].*dlnC)
    )
    return eval
end

Euler_def = Vector{Function}(undef,1)
Euler_def[1] = function(P,dlnC,dlnC_p1,dlnrp,da,dlnY,dlnpP)
    if P["ss"] == 1
        dlnbeta = zeros(P["N"]);
    else
        dlnbeta = log.(P["beta"][P["t"]] ./P["betass"]);
    end

    if P["t"] == P["T"]
        eval = dlnC .+ da .- (dlnY .+ dlnpP .+ (1 .+P["rss"]).*da)
    else
        eval = -P["sig"].*dlnC -  ( 
            dlnbeta - P["sig"].*dlnC_p1 + dlnrp
        )
    end
    return eval
end

UIP_def = Vector{Function}(undef,1)
UIP_def[1] = function(P,dlnr,dlnQ_p1,dlnQ,piwd)
    if P["ss"] == 1
        UIP_shock = 0;
    else
        UIP_shock = P["UIP_shock"][P["t"]]
    end

    if P["t"] == P["T"]
        if P["terminal_condition"] == "Qzero"
            eval = dlnQ
        elseif P["terminal_condition"] == "pizero"
            eval = piwd
        end
    else
        eval = dlnr .-  ( 
            sum(P["size"].*dlnr) .+ dlnQ_p1 .- dlnQ .+ UIP_shock
        )
    end
    return eval
end

MP_def = Vector{Function}(undef,1)
MP_def[1] = function(P,dlnr,pid_p1,pid)
    if P["ss"] == 1
        eval = dlnr
    elseif P["Taylor"] == 1
        dlnbeta = log.(P["beta"][P["t"]] ./P["betass"]);
        eval = dlnr .+ pid_p1 .- (
            - P["phi_beta"].*dlnbeta .+
            P["phi_pi"].*pid_p1
        )
    elseif P["Taylor"] == -1
        dlnbeta = log.(P["beta"][P["t"]] ./P["betass"]);
        eval = dlnr .+ pid_p1 .- (
            - P["phi_beta"].*sum(P["size"].*dlnbeta) .+
            P["phi_pi"].*sum(P["size"].*pid_p1)
        )
        
    else
        eval = dlnr - P["dlnr_shock"][P["t"]]
    end

    return eval
end

Import_def = Vector{Function}(undef,1)
Import_def[1] = function(P,dlnM,dlnC,dlnQ,dlnpP)


    eval = dlnM .- (
        - P["eta"].*sum(P["size"].*dlnpP) .- P["eta"].*dlnQ 
        .+ dlnC
    ) 
    return eval
end

Export_def = Vector{Function}(undef,1)
Export_def[1] = function(P,dlnX,dlnC,dlnQ,dlnpP)


    eval = dlnX .- (
        - P["eta"].*P["alph"]./(1-P["alph"]).*sum(P["size"].*dlnpP) 
        .+ P["eta"].*P["alph"]./(1-P["alph"]).*dlnQ 
        .+ sum(P["size"].*dlnC) 
    ) 
    return eval
end

NetExport_def = Vector{Function}(undef,1)
NetExport_def[1] = function(P,dlnX,dlnM,dlnXM)


    eval = dlnXM .- ( dlnX .- dlnM)
    return eval
end

NKPCw_def = Vector{Function}(undef,1)
NKPCw_def[1] = function(P,piwd,dlnY,dlnC,dlnpP,piwd_p1)

    if P["t"] == P["T"]
        eval = piwd .- (
            P["kappa_w"].*( P["nu"].*dlnY + P["sig"].*dlnC .- dlnpP)
            .+ P["beta_ss"].*piwd
        )
    else
        eval = piwd .- (
            P["kappa_w"].*( P["nu"].*dlnY + P["sig"].*dlnC .- dlnpP)
            .+ P["beta_ss"].*piwd_p1
        )
    end
    return eval
end


pid_def = Vector{Function}(undef,1)
pid_def[1] = function(P,piwd,pid,dlnpP,dlnpP_m1)

    eval = pid .- ( 
        piwd .- (dlnpP .- dlnpP_m1)
    )
    return eval
end

allinputs_string = "
dlnC,
dlnY,
dlnQ,
dlnpP,
da,
dlnrp,
dlnr,
dlnX,
dlnM,
dlnXM,
piwd,
pid
"

leng = Dict{String,Any}()
leng["input"] = [
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"]
    ];

allinputs = replace(allinputs_string,"\n" => "")
allinputs = replace(allinputs," " => "")
allinputs = split(allinputs,',');

set_functions = vcat(
    Budget_def[:],
    ToT_def[:],
    dlnrp_def[:],
    Goods_clear_def[:],
    Euler_def[:],
    UIP_def[:],
    MP_def[:],
    Export_def[:],
    Import_def[:],
    NetExport_def[:],
    NKPCw_def[:],
    pid_def[:]
)
leng["output"] =  [
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"],
    P["N"]
    ];
leng["function"] = [
    length(Budget_def),
    length(ToT_def),
    length(dlnrp_def),
    length(Goods_clear_def),
    length(Euler_def),
    length(UIP_def),
    length(MP_def),
    length(Export_def),
    length(Import_def),
    length(NetExport_def),
    length(NKPCw_def),
    length(pid_def)
]

leng["out_func"] = vcat(fill.(leng["output"], leng["function"])...)

#varargin = [Euler[1],arg_name.(Euler[1])]

references = process_inputs(allinputs,set_functions,leng)
n = length(references)





set_functions_ss = 
    copy(set_functions)
references_ss = process_inputs(allinputs,set_functions_ss,leng)



