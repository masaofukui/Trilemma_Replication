
function construct_IRF(P,xfull,allinputs,leng; ss = 0)

    d = Dict{String,Any}()
    n = length(allinputs)
    start_index = 0;
    for i = 1:n
        if ss==0
            d[(allinputs[i])] = zeros(P["T"],leng["input"][i])
        else
            d[(allinputs[i])] = zeros(leng["input"][i])
        end
        for ic = 1:leng["input"][i]
            idx = start_index + ic;
            if ss==0
                d[(allinputs[i])][:,ic] = xfull[:,idx];
            else
                d[(allinputs[i])][ic] = xfull[idx];
            end
        end
        start_index += leng["input"][i]
        if allinputs[i][1:1] == "l"
            d[allinputs[i][2:end]] = exp.(d[allinputs[i]]);
        end
    end
    if ss == 1
        P["t"] = "ss";
    end
    return d
end


function create_plot(d1,d2;label1="",label2="")

    Tplot = 10;
    yvar_list = ["dlnQ","dlnY","dlnC","dlnrp","dlnr","dlnX","dlnM","dlnXM","pid","piwd"]
    title_list = ["Real Effective Exchange Rate","Output","Consumption","Portfolio Return","Real Interest Rate",
    "Export","Import","Net Exports","Inflation","Wage Inflation"]

    plt_list = Dict{String,Any}();
    for (iy,yvar) in enumerate(yvar_list)
        ploty1 = d1[yvar][1:Tplot,:];
        ploty2 = d2[yvar][1:Tplot,:]
        title_label = title_list[iy]

        Tplot = 10;
        lw = 5;
        lw_nabla = 7
        msize = 7;
        ylabel_in = "%"
        tvec = 0:(Tplot-1)
        plt_list[yvar] = plot(tvec,zeros(length(tvec)),linestyle=:solid,lc=:grey,label=:none)

        plot!(tvec,ploty1[:,2],linewidth = lw,color=colplot_blue[3],label=:none)
        scatter!(tvec,ploty1[:,2],linewidth = lw,marker=:square,markersize=msize,color=colplot_blue[3],label="Pegs ("*label1*")")

        plot!(tvec,ploty1[:,4],linewidth = lw,color=colplot_blue[3],label=:none,linestyle=:solid)
        scatter!(tvec,ploty1[:,4],linewidth = lw,marker= :circle,markersize=msize,color=colplot_blue[3],label="Floats ("*label1*")",linestyle=:solid)

        plot!(tvec,ploty2[:,2],linewidth = lw,color=colplot_orange[3],label=:none,linestyle=:dash)
        scatter!(tvec,ploty2[:,2],linewidth = lw,marker=:square,markersize=msize,color=colplot_orange[3],label="Pegs ("*label2*")",linestyle=:dash)

        plot!(tvec,ploty2[:,4],linewidth = lw,color=colplot_orange[3],label=:none,linestyle=:dash)
        scatter!(tvec,ploty2[:,4],linewidth = lw,marker= :circle,markersize=msize,color=colplot_orange[3],label="Floats ("*label2*")",linestyle=:dash)

        
        
        plot!(title = title_label)
        plot!(ylabel = ylabel_in)
        plot!(xlabel = "Year")
        plot!(titlefontfamily = "Computer Modern",
            xguidefontfamily = "Computer Modern",
            yguidefontfamily ="Computer Modern",
            legendfontfamily =  "Computer Modern")
        plot!(grid=:y)
        plot!(legendfontsize=10)
        if yvar != "dlnQ"
            plot!(legend=:none)
        end


        nabla_plot1 = ploty1[:,2] - ploty1[:,4]
        nabla_plot2 = ploty2[:,2] - ploty2[:,4]
        plt_list["nabla_$(yvar)"] = plot(tvec,zeros(length(tvec)),linestyle=:dash,lc=:grey,label=:none)
        plot!(tvec,nabla_plot1,linewidth = lw_nabla,marker=:none,markersize=msize,color=colplot_blue[3],label=label1)
        plot!(tvec,nabla_plot2,linewidth = lw_nabla,marker=:none,markersize=msize,color=colplot_orange[3],label=label2,linestyle=:dash)
        plot!(title = "∇ "*string(title_label))
        plot!(ylabel = ylabel_in)
        plot!(xlabel = "Year")
        plot!(titlefontfamily = "Computer Modern",
            xguidefontfamily = "Computer Modern",
            yguidefontfamily ="Computer Modern",
            legendfontfamily =  "Computer Modern")
        plot!(grid=:y)
        plot!(legendfontsize=12)
        
        if yvar != "dlnQ"
            plot!(legend=:none)
        end
    end
    return plt_list
end




function shock_plot(UIPshock,betashock,dlnrshock;label1="",label2="")

    yvar_list = Dict{String,Any}();
    yvar_list["betashock"] = betashock;
    yvar_list["UIPshock"] = UIPshock;
    yvar_list["dlnrshock"] = dlnrshock;


    plt_var_list = ["UIPshock","betashock","dlnrshock"]
    title_list = ["UIP shock, \\psi", "Discount factor shock, \\beta","Monetary policy shock, i"]
    plt_list = Dict{String,Any}();
    for (iy,plt_var) in enumerate(plt_var_list)
        title_label = title_list[iy]

        Tplot = 10;
        lw = 5;
        msize = 7;
        ylabel_in = "%"
        tvec = 0:(Tplot-1)
        plt_list[plt_var] = plot(tvec,zeros(length(tvec)),linestyle=:solid,lc=:grey,label=:none)
        if plt_var == "UIPshock"
            yvec = yvar_list[plt_var][[1, 3],1:Tplot]
        else
            yvec = zeros(2,Tplot)
        end
        plot!(tvec,yvec[1,:],linewidth = lw,color=colplot_blue[3],label=:none)
        scatter!(tvec,yvec[1,:],linewidth = lw,marker=:square,markersize=msize,color=colplot_blue[3],label="US ( "*label1*" )")
        plot!(tvec,yvec[2,:],linewidth = lw,color=colplot_blue[3],label=:none,linestyle=:solid)
        scatter!(tvec,yvec[2,:],linewidth = lw,marker= :circle,markersize=msize,color=colplot_blue[3],label="Euro ( "*label1*" )",linestyle=:solid)
        plot!(tvec,yvar_list[plt_var][1,1:Tplot],linewidth = lw,linestyle=:dash,color=colplot_orange[3],label=:none)
        scatter!(tvec,yvar_list[plt_var][1,1:Tplot],linewidth = lw,marker=:square,markersize=msize,linestyle=:dash,color=colplot_orange[3],label="US ( "*label2*" )")
        plot!(tvec,yvar_list[plt_var][3,1:Tplot],linewidth = lw,color=colplot_orange[3],label=:none,linestyle=:dash)
        scatter!(tvec,yvar_list[plt_var][3,1:Tplot],linewidth = lw,marker= :circle,markersize=msize,color=colplot_orange[3],label="Euro ( "*label2*" )",linestyle=:dash)
        plot!(title = title_label)
        plot!(ylabel = ylabel_in)
        plot!(xlabel = "Year")
        plot!(titlefontfamily = "Computer Modern",
            xguidefontfamily = "Computer Modern",
            yguidefontfamily ="Computer Modern",
            legendfontfamily =  "Computer Modern")
        plot!(grid=:y)
        plot!(legendfontsize=12)
        if "UIPshock" != plt_var
            plot!(legend=:none)
        end
    end

    return plt_list
end




function create_plot_for_unconditional(d1;shockplot = "", d2="",label1="",label2="",shock_label="",Tplot = 10,lw = 5)

    yvar_list = ["dlnQ","dlnY","dlnC","dlnrp","dlnr","dlnX","dlnM","dlnXM","pid","piwd"]
    title_list = ["Real Effective Exchange Rate","Output","Consumption","Portfolio Return","Real Interest Rate",
    "Export","Import","Net Export","Inflation","Wage Inflation"]
    if shockplot != ""
        yvar_list = push!(yvar_list,"shock")
        title_list = push!(title_list,shock_label)
    end

    scaling = 1/d1["dlnQ"][1,1]
    plt_list = Dict{String,Any}();
    for (iy,yvar) in enumerate(yvar_list)
        println(yvar)
        if yvar != "shock"
            ploty1 = d1[yvar][1:Tplot,:].*scaling;
        else
            ploty1 = shockplot[1,1:Tplot].*scaling
        end
        if d2 != "" && yvar != "shock"
            ploty2 = d2[yvar][1:Tplot,:].*scaling
        end
        title_label = title_list[iy]

        msize = 7;
        ylabel_in = "%"
        tvec = 0:(Tplot-1)
        plt_list[yvar] = plot(tvec,zeros(length(tvec)),linestyle=:solid,lc=:grey,label=:none)

        plot!(tvec,ploty1[:,1],linewidth = lw,color=colplot_blue[3],label=label1)
        #scatter!(tvec,ploty1[:,1],linewidth = lw,marker=:square,markersize=msize,color=colplot_blue[3],label=label1)

        if d2 != "" && yvar != "shock"
            plot!(tvec,ploty2[:,1],linewidth = lw,color=colplot_orange[3],label=label2,linestyle=:dash)
            #scatter!(tvec,ploty2[:,1],linewidth = lw,marker=:circle,markersize=msize,color=colplot_orange[3],label=label2,linestyle=:dash)
        end

      
        plot!(title = title_label)
        plot!(ylabel = ylabel_in)
        plot!(xlabel = "Year")
        plot!(titlefontfamily = "Computer Modern",
            xguidefontfamily = "Computer Modern",
            yguidefontfamily ="Computer Modern",
            legendfontfamily =  "Computer Modern")
        plot!(grid=:y)
        plot!(legendfontsize=14)
        if yvar != "dlnr"
            plot!(legend=:none)
        end

    end
    return plt_list
end



