function Shock_constructor(Shock_Var,Tshock,rho_shock,Tnews,auxillary_inputs)
    @unpack T = auxillary_inputs
    Shock_Path = zeros(T);
    Shock_Path[1] = shock_size;
    if Shock_Var != "F MP shock" && Shock_Var != "P MP shock" && Shock_Var != "U MP shock"
        for t = 1:(Tshock-1)
            Shock_Path[t+1] = rho_shock*Shock_Path[t];
        end
    end

    Shock_Path_before = zeros(T)
    Shock_Path_after = zeros(T)



    if Shock_Var == "F AR2 shock"
        Shock_Path_temp = zeros(T);
        Shock_Path_temp[1] = shock_size;
        for t = 1:((Tshock-1) )
            Shock_Path_temp[t+1] = rho_shock*Shock_Path_temp[t];
        end

        Shock_Path = zeros(T)
        for t = 1:((Tshock-1) )
            Shock_Path[t+1] = 0.1*Shock_Path_temp[t] + 0.9*Shock_Path[t];
        end

        Shock_Var = "F TFP shock";
    end

    if Shock_Var == "F AR2 News shock"
        Shock_Path_temp = zeros(T);
        Shock_Path_temp[Tnews] = shock_size;
        for t = Tnews:((Tshock-1) )
            Shock_Path_temp[t+1] = rho_shock*Shock_Path_temp[t];
        end

        Shock_Path = zeros(T)
        for t = 1:((Tshock-1) )
            Shock_Path[t+1] = 0.1*Shock_Path_temp[t] + 0.9*Shock_Path[t];
        end

        Shock_Var = "F TFP shock";
    end

    if Shock_Var == "F News shock"
        Shock_Path = zeros(T);
        Shock_Path[Tnews] = shock_size;
        for t = Tnews:((Tshock-1) )
            Shock_Path[t+1] = rho_shock*Shock_Path[t];
        end
        Shock_Var = "F TFP shock";
    end


    if Shock_Var == "F Investment News shock"
        Shock_Path = zeros(T);
        Shock_Path[Tnews] = shock_size;
        for t = Tnews:((Tshock-1) )
            Shock_Path[t+1] = rho_shock*Shock_Path[t];
        end
        Shock_Var = "F Investment shock";
    end


    for sv = ["U" "P" "F"]

        if Shock_Var == sv*" Trend shock"
            Shock_Path = zeros(T);
            Shock_Path[Tnews] = shock_size;
            for t = Tnews:((Tshock-1) )
                Shock_Path[t+1] = rho_shock*Shock_Path[t];
            end
            Shock_Path = cumsum(Shock_Path)
            Shock_Var = sv*" TFP shock";
            Shock_Path = Shock_Path .- Shock_Path[end]

            Shock_Path = 0.1*Shock_Path;

            #Shock_Path = ones(T)
            Shock_Path_before = Shock_Path[1]*ones(T)
            Shock_Path_after = Shock_Path[end]*ones(T)

            #Shock_Path[1] = Shock_Path[1] - 0.05
            break
        else
            Shock_Path_before = zeros(T)
            Shock_Path_after = zeros(T)
    
        end
    end


    return Shock_Path, Shock_Var,Shock_Path_before,Shock_Path_after

end