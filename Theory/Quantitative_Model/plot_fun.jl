
function plot_result_fun(d,
    data_irf;
    fig_save = 0,
    fig_name = "",
    fig_all = 0,
    d2 = 0,
    d2_label ="",
    d2_fig_save = 0,
    d3 = 0,
    split = 0,
    UIP_deviation= 1)

    gridonoff = :y
    gridalph = 0.05;
    xlabel_name = "Years"
    titlefontsize_set = 20;
    legendfontsize_set = 15;

    cur_colors = get_color_palette(:auto, plot_color(:white))
    colplot_blue = palette(:Blues_3)

    Tplot = 9;
    ms = 7;
    lw = 7;
    tplot = 0:(T-1)

    tshort = 0:(Tplot)
    xticks_label = 0:max(floor(Tplot/10),1):Tplot


    yl1 = "% deviation from s.s."
    yl2 = "% of s.s. GDP"
    yl3 = "p.p. deviation from s.s."

    plt_data_list = ["lnominal","lreal","RGDP_WB","consumption_WB","inflation_WB","bloomberg_rate_all",
    "real_rate_all_bloomberg","lexport_price_WB","limport_price_WB","lTerms_of_trade_WB","exports_WB",
    "imports_WB","net_exports_WB","investment_WB","UIP_deviation"]
    plt_var_list = ["NER","RER","Y","C","pi","i","r","exp_price",
    "imp_price","ToT","exp","imp","netexp","I","UIP_deviation"]
    plt_title_list = ["Nominal Exchange Rate","Real Exchange Rate","GDP","Consumption","Inflation","Nominal Interest Rate",
    "Real Interest Rate","Export Price","Import price","Terms of Trade", "Exports", "Imports", "Net Exports","Investment","Ex-Post UIP Deviation"]
    ylab_list = [yl1,yl1,yl2,yl2,yl3,yl3,yl3,yl1,yl1,yl1,yl2,yl2,yl2,yl2,yl3]
    plt_list = Dict()

    for iv in 1:length(plt_data_list)
        idata = plt_data_list[iv]
        imodel = plt_var_list[iv]
        data_irf_plot =  data_irf[idata]
        title = plt_title_list[iv]
        model_irf_plot = d["relative_"*imodel]
        #plt_list[title] = plot(tshort,data_irf_plot[!,:up95],fillrange = data_irf_plot[!,:low95],fillalpha = 0.08,label = :false,c=1,lw=0,linealpha = 0.1)
        plt_list[title] =          plot(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
        plot!(tshort,data_irf_plot[!,:up95],linewidth = lw,c=colplot_blue[3],linestyle=:dot,label=:false)
        plot!(tshort,data_irf_plot[!,:low95],linewidth = lw,c=colplot_blue[3],linestyle=:dot,label=:false)

        plot!(tshort,data_irf_plot[!,:bh],label = "Data",linewidth = lw,linestyle=:solid,c=colplot_blue[3])
        plot!(tplot,model_irf_plot,label= "Model",linewidth = lw,marker = :circle,markersize = ms,c=cur_colors[2])
        #plot!(tshort,data_irf_plot[!,:low95],label = :false,linewidth = lw,linestyle=:dot,linecolor=cur_colors[2])
        plot!(title= title)
        plot!(xlims!(0,Tplot))
        plot!(xticks = xticks_label)
        plot!(grid = gridonoff)
        plot!(gridalpha = gridalph)
        plot!(xlabel = xlabel_name)
        plot!(ylabel = ylab_list[iv])
        plot!(margin = 1mm)
        if iv == 1 || imodel == "UIP_deviation"
            plot!(legend=:bottomleft)
        else
            plot!(legend=:false)
        end
    end


    if split == 0   
        plt = plot(
            plt_list["Nominal Exchange Rate"],
            plt_list["Real Exchange Rate"],
            plt_list["GDP"],
            plt_list["Consumption"],
            plt_list["Net Exports"],
            plt_list["Nominal Interest Rate"],
            plt_list["Investment"],
            plt_list["Exports"],
            plt_list["Imports"],
            #rel_exp_price_plot,
            #rel_imp_price_plot,
            plt_list["Terms of Trade"],
            plt_list["Inflation"],
            plt_list["Real Interest Rate"],
            size=(1500,1500),
        layout = (4,3))
        plot!(titlefontfamily = "Times Roman",
        xguidefontfamily = "Times Roman",
        yguidefontfamily = "Times Roman",
        legendfontfamily =  "Times Roman")
        plot!(left_margin=8mm)
        plot!(thickmarker_scale=2)
        plot!(legendfontsize=legendfontsize_set,
        titlefontsize = titlefontsize_set,
        xlabelfontsize = titlefontsize_set*0.75,
        ylabelfontsize = titlefontsize_set*0.75)
        
        display(plt)
        if fig_save == 1
            fig_name_save = string("../../../writing/Figures/Model/fig_all_",fig_name,".pdf")
            fig_name_save = string(file_overleaf,"/fig_all_",fig_name,".pdf")
            savefig(fig_name_save)
        end
    else
        plt1 = plot(
        plt_list["Nominal Exchange Rate"],
        plt_list["Real Exchange Rate"],
        plt_list["GDP"],
        plt_list["Consumption"],
        plt_list["Net Exports"],
        plt_list["Nominal Interest Rate"],
        size=(1500,750),
        layout = (2,3))
        plot!(titlefontfamily = "Times Roman",
        xguidefontfamily = "Times Roman",
        yguidefontfamily = "Times Roman",
        legendfontfamily =  "Times Roman")
        plot!(left_margin=8mm)
        plot!(bottom_margin=8mm)
        plot!(thickmarker_scale=2)
        plot!(legendfontsize=legendfontsize_set,
        titlefontsize = titlefontsize_set,
        xlabelfontsize = titlefontsize_set*0.75,
        ylabelfontsize = titlefontsize_set*0.75)
        display(plt1)
        if fig_save == 1
            fig_name_save = string(file_overleaf,"/fig_all_split_1",fig_name,".pdf")
            savefig(fig_name_save)
        end

        plt2 = plot(    
        plt_list["Investment"],
        plt_list["Exports"],
        plt_list["Imports"],
        plt_list["Terms of Trade"],
        plt_list["Inflation"],
        plt_list["Real Interest Rate"],
        size=(1500,750),
        layout = (2,3))

        plot!(titlefontfamily = "Times Roman",
        xguidefontfamily = "Times Roman",
        yguidefontfamily = "Times Roman",
        legendfontfamily =  "Times Roman")
        plot!(left_margin=8mm)
        plot!(bottom_margin=8mm)
        plot!(thickmarker_scale=2)
        plot!(legendfontsize=legendfontsize_set,
        titlefontsize = titlefontsize_set,
        xlabelfontsize = titlefontsize_set*0.75,
        ylabelfontsize = titlefontsize_set*0.75)
        if fig_save == 1
            fig_name_save = string(file_overleaf,"/fig_all_split_2",fig_name,".pdf")
            savefig(fig_name_save)
        end
    end

    if UIP_deviation == 1
        plot_UIP = plot(plt_list["Ex-Post UIP Deviation"],size=(600,350))
        display(plot_UIP)
        if fig_save == 1
            fig_name_save = string(file_overleaf,"/Data_Model_UIP_deviation_",fig_name,".pdf")
            savefig(fig_name_save)
        end
    end

end




function plot_result_fun2(d,
    d2;
    fig_save = 0,
    fig_name = "",
    d2_label ="",
    d2_fig_save = 0,
    tpre = 0,
    T_NT = 0,
    HtM = 0,
    price_stickiness = 0)


    gridonoff = :y
    gridalph = 0.05;
    xlabel_name = "Years"
    titlefontsize_set = 12;
    legendfontsize_set = 10;


    cur_colors = get_color_palette(:auto, plot_color(:white))
    colplot_blue = palette(:Blues_3)

    Tplot = 9;
    ms = 10;
    lw = 10;
    tplot = (-tpre):(T-1)
    tshort = (-tpre):(Tplot)
    xticks_label = (-tpre):max(floor(Tplot/10),1):Tplot


    yl1 = "% deviation from s.s."
    yl2 = "% of s.s. GDP"
    yl3 = "p.p. deviation from s.s."

    plt_var_list = ["NER","RER","Y","C","pi","i","r","exp_price",
    "imp_price","ToT","exp","imp","netexp","I","risk_premium","T_GDP","NT_GDP","rp"]
    plt_title_list = ["Nominal Exchange Rate","Real Exchange Rate","GDP","Consumption","Inflation","Nominal Interest Rate",
    "Real Interest Rate","Export Price","Import price","Terms of Trade", "Exports", "Imports",
     "Net Exports","Investment","Equity Premium","Tradable GDP","Non-tradable GDP","HH and Firm Financial Discounts"]
    ylab_list = [yl1,yl1,yl2,yl2,yl3,yl3,yl3,yl1,yl1,yl1,yl2,yl2,yl2,yl2,yl3,yl2,yl2,yl3]
    plt_list = Dict()

    for iv in 1:length(plt_var_list)
        imodel = plt_var_list[iv]
        #data_irf_plot =  data_irf[idata]
        title = plt_title_list[iv]
        model_irf_plot = [zeros(tpre); d["relative_"*imodel]]
        model_irf_plot2 = [zeros(tpre); d2["relative_"*imodel]]
        plt_list[title] = plot()
        plot!(tplot,model_irf_plot2,label= d2_label,linewidth = lw,marker = :none,markersize = ms,c=3,linecolor = colplot_blue[3])
        if imodel != "T_GDP" &&  imodel != "NT_GDP"
            plot!(tplot,model_irf_plot,label= "Baseline",linewidth = lw,marker = :none,markersize = ms,c=2,linestyle=:dash,linecolor = colplot_blue[2])
        else
            plot!(ylims=(-0.05,0.3))
        end
        #plot(tshort,data_irf_plot[!,:up95],fillrange = data_irf_plot[!,:low95],fillalpha = 0.08,label = :false,c=1,lw=0,linealpha = 0.1)
        #plot!(tshort,data_irf_plot[!,:bh],label = "Data",linewidth = lw,linestyle=:solid,markersize = ms,marker = :circle,c=cur_colors[1])
        #plot!(tshort,data_irf_plot[!,:low95],label = :false,linewidth = lw,linestyle=:dot,linecolor=cur_colors[2])
        plot!(title= title)
        plot!(xlims!(-tpre,Tplot))
        plot!(xticks = xticks_label)
        plot!(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
        plot!(grid = gridonoff)
        plot!(gridalpha = gridalph)
        plot!(xlabel = xlabel_name)
        plot!(titlefontsize = titlefontsize_set)
        plot!(ylabel = ylab_list[iv])
        plot!(margin = 1mm)
        if imodel == "RER" && T_NT == 0 && HtM == 0 && price_stickiness == 0
            plot!(legend=:topright)
        elseif imodel == "NER" && (T_NT == 1 || HtM == 1)
            plot!(legend=:bottomright)
        elseif imodel == "NER" && price_stickiness == 1
            plot!(legend=:topleft)
        else
            plot!(legend=:false)
        end
    end


    if T_NT == 0 && HtM == 0 && price_stickiness ==0
        plt = plot(
            plt_list["Real Exchange Rate"],
            plt_list["HH and Firm Financial Discounts"],
            plt_list["GDP"],
            plt_list["Net Exports"],
            size=(800,800*0.75),
            layout = (2,2))
            plot!(titlefontfamily = "Times Roman",
            xguidefontfamily = "Times Roman",
            yguidefontfamily = "Times Roman",
        legendfontfamily =  "Times Roman")
        plot!(margin=4mm)
        plot!(legendfontsize=legendfontsize_set,
        titlefontsize = titlefontsize_set,
        xlabelfontsize = titlefontsize_set*0.75,
        ylabelfontsize = titlefontsize_set*0.75)
    elseif T_NT == 1
        plt = plot(
            plt_list["Nominal Exchange Rate"],
            plt_list["Real Exchange Rate"],
            plt_list["GDP"],
            plt_list["Net Exports"],
            plt_list["Tradable GDP"],
            plt_list["Non-tradable GDP"],
            size=(800*3/2,800*0.75),
            layout = (2,3))
            plot!(titlefontfamily = "Times Roman",
            xguidefontfamily = "Times Roman",
            yguidefontfamily = "Times Roman",
            legendfontfamily = "Times Roman")
            plot!(margin=4mm)
            plot!(legendfontsize=legendfontsize_set,
            titlefontsize = titlefontsize_set,
            xlabelfontsize = titlefontsize_set*0.75,
            ylabelfontsize = titlefontsize_set*0.75)
    elseif HtM == 1
        plt = plot(
            plt_list["Nominal Exchange Rate"],
            plt_list["Real Exchange Rate"],
            plt_list["GDP"],
            plt_list["Consumption"],
            plt_list["Investment"],
            plt_list["Net Exports"],
            size=(800*3/2,800*0.75),
            layout = (2,3))
            plot!(titlefontfamily = "Times Roman",
            xguidefontfamily = "Times Roman",
            yguidefontfamily = "Times Roman",
            legendfontfamily = "Times Roman")
            plot!(margin=4mm)
            plot!(legendfontsize=legendfontsize_set,
            titlefontsize = titlefontsize_set,
            xlabelfontsize = titlefontsize_set*0.75,
            ylabelfontsize = titlefontsize_set*0.75)
    elseif price_stickiness == 1
            plt = plot(
                plt_list["Nominal Exchange Rate"],
                plt_list["Real Exchange Rate"],
                plt_list["GDP"],
                plt_list["Inflation"],
                plt_list["Nominal Interest Rate"],
                plt_list["Real Interest Rate"],
                size=(800*3/2,800*0.75),
                layout = (2,3))
                plot!(titlefontfamily = "Times Roman",
                xguidefontfamily = "Times Roman",
                yguidefontfamily = "Times Roman",
                legendfontfamily = "Times Roman")
                plot!(margin=4mm)
                plot!(legendfontsize=legendfontsize_set,
                titlefontsize = titlefontsize_set,
                xlabelfontsize = titlefontsize_set*0.75,
                ylabelfontsize = titlefontsize_set*0.75)
    end

    display(plt)
    if fig_save == 1
        if T_NT == 0 && HtM == 0
            fig_name_save = string(file_overleaf,"/risk_",fig_name,".pdf")
        elseif T_NT == 1
            fig_name_save = string(file_overleaf,"/T_NT_",fig_name,".pdf")
        elseif HtM == 1
            fig_name_save = string(file_overleaf,"/HtM_",fig_name,".pdf")
        end
        savefig(fig_name_save)
    end

end



function plot_result_fun3(d,
    d2,d3;
    fig_save = 0,
    fig_name = "",
    d1_label="",
    d2_label ="",
    d3_label ="",
    d2_fig_save = 0,
    tpre = 0,
    s_share_plot = 0,
    d1_ls = :solid,
    d2_ls = :solid,
    d3_ls = :solid)

    colplot = palette(:Blues_4)

    gridonoff = :y
    xlabel_name = "Years"
    titlefontsize_set = 12;
    legendfontsize_set = 10;

    cur_colors = get_color_palette(:auto, plot_color(:white))

    Tplot = 9;
    ms = 10;
    lw = 8;
    tplot = (-tpre):(T-1)
    tshort = (-tpre):(Tplot)
    xticks_label = (-tpre):max(floor(Tplot/10),1):Tplot


    yl1 = "% deviation from s.s."
    yl2 = "% of s.s. GDP"
    yl3 = "p.p. deviation from s.s."

    plt_var_list = ["NER","RER","Y","C","pi","i","r","exp_price",
    "imp_price","ToT","exp","imp","netexp","I","risk_premium","rp"]
    plt_title_list = ["Nominal Exchange Rate","Real Exchange Rate","GDP","Consumption","Inflation","Nominal Interest Rate",
    "Real Interest Rate","Export Price","Import price","Terms of Trade", "Exports", "Imports",
    "Net Exports","Investment","Equity Premium","Household and Firm Financial Discounts"]
    ylab_list = [yl1,yl1,yl2,yl2,yl3,yl3,yl3,yl1,yl1,yl1,yl2,yl2,yl2,yl2,yl3,yl3]
    plt_list = Dict()

    for iv in 1:length(plt_var_list)
        imodel = plt_var_list[iv]
        #data_irf_plot =  data_irf[idata]
        plot(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
        title = plt_title_list[iv]
        model_irf_plot = [zeros(tpre); d["relative_"*imodel]]
        model_irf_plot2 = [zeros(tpre); d2["relative_"*imodel]]
        model_irf_plot3 = [zeros(tpre); d3["relative_"*imodel]]

        plt_list[title] =  plot!(tplot,model_irf_plot,label= d1_label,linewidth = lw,marker = :none,markersize = ms,
        linestyle=:solid,linecolor = colplot[4],ls = d1_ls)

        #plot(tshort,data_irf_plot[!,:up95],fillrange = data_irf_plot[!,:low95],fillalpha = 0.08,label = :false,c=1,lw=0,linealpha = 0.1)
        #plot!(tshort,data_irf_plot[!,:bh],label = "Data",linewidth = lw,linestyle=:solid,markersize = ms,marker = :circle,c=cur_colors[1])
        plot!(tplot,model_irf_plot2,label= d2_label,linewidth = lw,
        marker = :none,markersize = ms,linecolor = colplot[3],ls = d2_ls)
        plot!(tplot,model_irf_plot3,label= d3_label,linewidth = lw,
        marker = :none,markersize = ms,linecolor = colplot[2],ls = d3_ls)

        #plot!(tshort,data_irf_plot[!,:low95],label = :false,linewidth = lw,linestyle=:dot,linecolor=cur_colors[2])
        plot!(title= title)
        plot!(xlims!(-tpre,Tplot))
        plot!(xticks = xticks_label)
        plot!(grid = gridonoff)
        plot!(gridalpha = 0.05)
        plot!(xlabel = xlabel_name)
        plot!(titlefontsize = titlefontsize_set)
        plot!(ylabel = ylab_list[iv])
        plot!(margin = 1mm)
        if imodel == "netexp" && s_share_plot == 0
            plot!(legend=:topright)
            plot!( thickness_scaling = 1)

        elseif imodel == "RER" && s_share_plot == 1
            plot!(legend=:topright)
        else
            plot!(legend=:false)
        end
    end

    
    if s_share_plot == 0
        plt = plot(
            plt_list["Net Exports"],
            plt_list["Terms of Trade"],
            layout = (1,2),
            size = (800,800*0.5*0.75))
            plot!(titlefontfamily = "Times Roman",
            xguidefontfamily = "Times Roman",
            yguidefontfamily = "Times Roman",
            legendfontfamily =  "Times Roman")
            plot!(margin=4mm)
            plot!(legendfontsize=legendfontsize_set,
            titlefontsize = titlefontsize_set,
            xlabelfontsize = titlefontsize_set*0.75,
            ylabelfontsize = titlefontsize_set*0.75)
    elseif s_share_plot == 1
        plt = plot(
            plt_list["Real Exchange Rate"],
            plt_list["Household and Firm Financial Discounts"],
            plt_list["GDP"],
            plt_list["Net Exports"],
            size=(800,800*0.75),
            layout = (2,2))
            plot!(titlefontfamily = "Times Roman",
            xguidefontfamily = "Times Roman",
            yguidefontfamily = "Times Roman")
            plot!(margin=4mm)
            plot!(legendfontsize=legendfontsize_set,
            titlefontsize = titlefontsize_set,
            xlabelfontsize = titlefontsize_set*0.75,
            ylabelfontsize = titlefontsize_set*0.75)
    end

    display(plt)
    if fig_save == 1 && s_share_plot == 0
        #fig_name_save = string("../../../writing/Figures/Model/Pricing_",fig_name,".pdf")
        fig_name_save = string(file_overleaf,"/Pricing_",fig_name,".pdf")
        savefig(fig_name_save)
    else fig_save == 1 & s_share_plot == 1
        fig_name_save = string(file_overleaf,"/GammaD_",fig_name,".pdf")
        savefig(fig_name_save)
    end

end



function plot_model_fun(d;country_list = ["U","P","F"],
    fig_save = 0,fig_name = "", 
    Tplot = 100,Shock_Var = Shock_Var,
    two_shock = 0, subset = 0 )


    ms = 8;
    lw = 7;
    Tpre = 3;
    tplot = (-Tpre):(T-1)
    cur_colors = get_color_palette(:auto, plot_color(:white));

    scaling = 1.0;
    tshort = (-Tpre):(Tplot)
    xticks_label = -Tpre:max(floor(Tplot/10),1):Tplot
    if subset == 1
        xticks_label = -0:5:Tplot
        scaling = 1/d["RER_F"][1]
    end

    linemarker_list = Dict()
    if length(country_list) > 1
        linemarker_list["U"] = :square
        linemarker_list["P"] = :circle
        linemarker_list["F"] = :diamond
    else
        linemarker_list["U"] = :none
        linemarker_list["P"] = :none
        linemarker_list["F"] = :none
    end


  
    if two_shock == 0
        Shock_plot = plot()
        plot!(tplot,[zeros(Tpre); d["Shock"]],linewidth = lw,markersize = ms)
        plot!(title="Shock")
        plot!(xlims!(-Tpre,Tplot))
        plot!(xticks = xticks_label)
        plot!(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)

    else
        Shock_plot = plot()
        plot!(tplot,d["UIP shock path"],linewidth = lw,markersize = ms,label="UIP")
        plot!(tplot,d["MP shock path"],linewidth = lw,markersize = ms,label="MP")
        plot!(title="Shock")
        plot!(xlims!(-Tpre,Tplot))
        plot!(xticks = xticks_label)
        plot!(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
    end




            
    yl1 = "% deviation from s.s."
    yl2 = "% of s.s. GDP"
    yl3 = "p.p. deviation from s.s."

    plt_var_list = ["NER","RER","GDP","C_GDP","I_GDP","NX_GDP","exp_price","imp_price",
    "r","EXP_GDP","IMP_GDP","P","i","pi","NFA","q","D","RealY","K","risky","rp","risk_premium"]
    plt_title_list = ["NER","RER","GDP","Consumption","Investment","Net exports",
    "Export price","Import price","Real rate", "Exports", "Imports", "Price level",
    "Nominal interest rate","Inflation", "NFA","Asset price","Dividend", "Real Y","K","Risky rate","rp",
    "Equity premium"]
    plt_ylabel_list = [yl1,yl1,yl1,yl2,yl2,yl2,yl3,yl1,yl3,yl2,yl2,yl2,yl1,yl3,yl3,yl3,yl1,yl1,yl1,yl1,yl3,yl3]

    plt_list = Dict()

    iiv = 0;
    for iv in plt_var_list
        
        iiv +=1
        plt_list[iv] = plot(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:dash,linecolor=:gray,label=:false)
        for ctry = country_list
            plot_var = iv*"_"*ctry
            if iv == "rp"
                d[plot_var][1] = 0.0;
            end
            dplot = [zeros(Tpre,1); d[plot_var]].*scaling
            plot!(tplot,dplot,label= ctry,linewidth = lw,marker = linemarker_list[ctry],markersize = ms,
            lc = cur_colors[1])
        end
        plot!(title=plt_title_list[iiv])
        plot!(xlims!(-Tpre,Tplot))
        plot!(xticks = xticks_label)
        plot!(ylabel = plt_ylabel_list[iiv])
        plot!(grid = :y)

        if length(country_list) == 1
            plot!(legend=:none)
        end
    end





    if SI > 100
        plt = plot(plt_list["NER"],plt_list["RER"],plt_list["GDP"],plt_list["C_GDP"],
        plt_list["pi"],plt_list["i"],plt_list["r"],
        plt_list["exp_price"],plt_list["imp_price"],
        plt_list["EXP_GDP"],plt_list["IMP_GDP"],plt_list["NX_GDP"],plt_list["P"],
        plt_list["risky"],plt_list["q"],plt_list["D"],plt_list["RealY"],
        plt_list["NFA"],plt_list["rp"],Shock_plot,size=(1600,1200))
    else
        plt = plot(plt_list["NER"],plt_list["RER"],plt_list["GDP"],plt_list["C_GDP"],
        plt_list["I_GDP"],plt_list["K"],
        plt_list["pi"],plt_list["i"],plt_list["r"],
        plt_list["exp_price"],plt_list["imp_price"],
        plt_list["EXP_GDP"],plt_list["IMP_GDP"],plt_list["NX_GDP"],plt_list["P"],
        plt_list["risky"],plt_list["q"],plt_list["D"],plt_list["RealY"],
        plt_list["NFA"],plt_list["rp"],Shock_plot,size=(1600,1200))
        plot!(ylabel="")
        plot!(titlefontfamily = "Times Roman",
        xguidefontfamily = "Times Roman",
        yguidefontfamily = "Times Roman",
        legendfontfamily =  "Times Roman")

    end
    display(plt)

    #if fig_save == 1
   #     #fig_name_save = string("../../../writing/Figures/Model/relative_irf_",paramet_spec,"_Pricing_",pricing,".pdf")
    #    fig_name_save = string("../../../writing/Figures/Model/",fig_name,".pdf")

   #     savefig(fig_name_save)
    #end

    if subset == 1
        plt = plot(plt_list["RER"],plt_list["GDP"],
        plt_list["NX_GDP"],
        plt_list["risk_premium"],size=(700,600),
        margin=0Plots.mm)
        plot!(xlabel="Years")
        plot!(titlefontfamily = "Times Roman",
        xguidefontfamily = "Times Roman",
        yguidefontfamily = "Times Roman",
        legendfontfamily =  "Times Roman")
        display(plt)


        if fig_save == 1

            fig_name_save = string(file_overleaf,"/",fig_name,".pdf")
            savefig(fig_name_save)
        end
    end

end




function plot_NIIPA(d,d2,label2; fig_save = 0)
    gridonoff = :y
    xlabel_name = "Years"
    titlefontsize_set = 20;
    legendfontsize_set = 12;

    cur_colors = get_color_palette(:auto, plot_color(:white))

    Tplot = 9;
    ms = 10;
    lw = 7;
    tplot = 0:(T-1)

    tshort = 0:(Tplot)
    xticks_label = 0:max(floor(Tplot/10),1):Tplot


    data_irf_plot =  data_irf["RGDP_WB"]
    rel_Y_plot = plot(tplot,d["relative_Y"],label= "Baseline",linewidth = lw,marker = :none,markersize = ms)
    plot!(tplot,d2["relative_Y"],label= label2,linewidth = lw,marker = :none,markersize = ms,color = cur_colors[3],linestyle = :dash)
    plot!(tshort,data_irf_plot[!,:bh],label = "Data",linewidth = lw,linestyle=:solid,markersize = ms,marker = :diamond,color = cur_colors[2])
    #plot!(tshort,data_irf_plot[!,:up95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    #plot!(tshort,data_irf_plot[!,:low95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    plot!(title="GDP")
    plot!(legend=:topleft)
    plot!(xlims!(0,Tplot))
    plot!(xticks = xticks_label)
    plot!(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
    plot!(grid = gridonoff)
    plot!(xlabel = xlabel_name)
    plot!(titlefontsize = titlefontsize_set)
    plot!(legendfontsize=legendfontsize_set)

    data_irf_plot =  data_irf["consumption_WB"]
    rel_C_plot = plot(tplot,d["relative_C"],label= "Baseline",linewidth = lw,marker = :none,markersize = ms)
    plot!(tplot,d2["relative_C"],label= label2,linewidth = lw,marker = :none,markersize = ms,color = cur_colors[3],linestyle = :dash)
    plot!(tshort,data_irf_plot[!,:bh],label = "Data",linewidth = lw,linestyle=:solid,markersize = ms,marker = :diamond,color = cur_colors[2])
    #plot!(tshort,data_irf_plot[!,:up95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    #plot!(tshort,data_irf_plot[!,:low95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    plot!(title="Consumption")
    #plot!(legend=:topleft)
    plot!(xlims!(0,Tplot))
    plot!(xticks = xticks_label)
    plot!(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
    plot!(grid = gridonoff)
    plot!(xlabel = xlabel_name)
    plot!(titlefontsize = titlefontsize_set)
    plot!(legend=:none)


    data_irf_plot =  data_irf["investment_WB"]
    rel_I_plot = plot(tplot,d["relative_I"],label= "Baseline",linewidth = lw,marker = :none,markersize = ms)
    plot!(tplot,d2["relative_I"],label= label2,linewidth = lw,marker = :none,markersize = ms,color = cur_colors[3],linestyle = :dash)
    plot!(tshort,data_irf_plot[!,:bh],label = "Data",linewidth = lw,linestyle=:solid,markersize = ms,marker = :diamond,color = cur_colors[2])
    #plot!(tshort,data_irf_plot[!,:up95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    #plot!(tshort,data_irf_plot[!,:low95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    plot!(title="Investment")
    plot!(legend=:none)
    plot!(xlims!(0,Tplot))
    plot!(xticks = xticks_label)
    plot!(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
    plot!(grid = gridonoff)
    plot!(xlabel = xlabel_name)
    plot!(titlefontsize = titlefontsize_set)


    data_irf_plot =  data_irf["net_exports_WB"]
    rel_NX_plot = plot(tplot,d["relative_netexp"],label= "Baseline",linewidth = lw,marker = :none,markersize = ms)
    plot!(tplot,d2["relative_netexp"],label= label2,linewidth = lw,marker = :none,markersize = ms,color = cur_colors[3],linestyle = :dash)
    plot!(tshort,data_irf_plot[!,:bh],label = "Data",linewidth = lw,linestyle=:solid,markersize = ms,marker = :diamond,color = cur_colors[2])
    #plot!(tshort,data_irf_plot[!,:up95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    #plot!(tshort,data_irf_plot[!,:low95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    plot!(title="Net Exports")
    plot!(legend=:none)
    plot!(xlims!(0,Tplot))
    plot!(xticks = xticks_label)
    plot!(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
    plot!(grid = gridonoff)
    plot!(xlabel = xlabel_name)
    plot!(titlefontsize = titlefontsize_set)


    plt = plot(
        rel_Y_plot,
        rel_C_plot,
        rel_I_plot,
        rel_NX_plot,
        size=(1000,700))
    plot!(titlefontfamily = "Times Roman",
        xguidefontfamily = "Times Roman",
        yguidefontfamily = "Times Roman",
        legendfontfamily =  "Times Roman")
    if label2 == "No Investment"
        plt = plot(
            rel_C_plot,
            rel_NX_plot,
            size = (1200,400),
            margin=5Plots.mm)
    end
    display(plt)
    if fig_save == 1
        if label2 == L"$\Gamma^D \to 0$"
            label2 = "GammaD"
        end
        fig_name_save = string(file_overleaf,"/NIIPA",label2,".pdf")

        savefig(fig_name_save)
    end
end



function plot_ToT(d,d2,d3,label2,label3; fig_save = 0)
    gridonoff = :y
    xlabel_name = "Years"
    titlefontsize_set = 20;
    legendfontsize_set = 12;

    cur_colors = get_color_palette(:auto, plot_color(:white))

    Tplot = 9;
    ms = 10;
    lw = 7;
    tplot = 0:(T-1)

    tshort = 0:(Tplot)
    xticks_label = 0:max(floor(Tplot/10),1):Tplot



    data_irf_plot =  data_irf["RGDP_WB"]
    rel_Y_plot = plot(tplot,d["relative_Y"],label= "Baseline",linewidth = lw,marker = :circle,markersize = ms)
    plot!(tplot,d2["relative_Y"],label= label2,linewidth = lw,marker = :dtriangle,markersize = ms,color = cur_colors[3])
    plot!(tplot,d3["relative_Y"],label= label3,linewidth = lw,marker = :hex,markersize = ms,color = cur_colors[4])
    plot!(tshort,data_irf_plot[!,:bh],label = "Data",linewidth = lw,linestyle=:dash,markersize = ms,marker = :diamond,color = cur_colors[2])
    #plot!(tshort,data_irf_plot[!,:up95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    #plot!(tshort,data_irf_plot[!,:low95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    plot!(title="GDP")
    plot!(legend=:topleft)
    plot!(xlims!(0,Tplot))
    plot!(xticks = xticks_label)
    plot!(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
    plot!(grid = gridonoff)
    plot!(xlabel = xlabel_name)
    plot!(titlefontsize = titlefontsize_set)
    plot!(legendfontsize=legendfontsize_set)



    data_irf_plot =  data_irf["lTerms_of_trade_WB"]
    rel_tot_plot = plot(tplot,d["relative_ToT"],label= "Baseline",linewidth = lw,marker = :circle,markersize = ms)
    plot!(tplot,d2["relative_ToT"],label= label2,linewidth = lw,marker = :dtriangle,markersize = ms,color = cur_colors[3])
    plot!(tplot,d3["relative_ToT"],label= label3,linewidth = lw,marker = :hex,markersize = ms,color = cur_colors[4])
    plot!(tshort,data_irf_plot[!,:bh],label = "Data",linewidth = lw,linestyle=:dash,markersize = ms,marker = :diamond,color = cur_colors[2])
    #plot!(tshort,data_irf_plot[!,:up95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    #plot!(tshort,data_irf_plot[!,:low95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    plot!(title="Terms of Trade")
    plot!(legend=:topright)
    plot!(xlims!(0,Tplot))
    plot!(xticks = xticks_label)
    plot!(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
    plot!(grid = gridonoff)
    plot!(xlabel = xlabel_name)
    plot!(titlefontsize = titlefontsize_set)
    plot!(legendfontsize=legendfontsize_set)
    plot!(legend=:none)


    plt = plot(
        rel_Y_plot,
        rel_tot_plot,
        size = (1200,400),
        margin=5Plots.mm)
  
    display(plt)
    if fig_save == 1
        fig_name_save = string(file_overleaf,"/ToT_",label2,"_",label3,".pdf")

        savefig(fig_name_save)
    end
end



function write_table_ner_i(data_irf,d_UIP,d_MP,d_Tech,d_Inv;fig_save=0)
    ln_impact = @sprintf("%.2f",data_irf["lnominal"][1,2] );
    li_impact = @sprintf( "%.2f",data_irf["bloomberg_rate_all"][1,2]);
    ln5_impact = @sprintf("%.2f",mean(data_irf["lnominal"][1:5,2]) );
    li5_impact = @sprintf( "%.2f",mean( data_irf["bloomberg_rate_all"][1:5,2]));

    ln_impact_UIP = @sprintf("%.2f",d_UIP["relative_NER"][1] );
    li_impact_UIP = @sprintf( "%.2f",d_UIP["relative_i"][1]);
    ln5_impact_UIP = @sprintf("%.2f",mean(d_UIP["relative_NER"][1:5]) );
    li5_impact_UIP = @sprintf( "%.2f",mean( d_UIP["relative_i"][1:5]));

    ln_impact_risk = @sprintf("%.2f",d_Inv["relative_NER"][1] );
    li_impact_risk = @sprintf( "%.2f",d_Inv["relative_i"][1]);
    ln5_impact_risk = @sprintf("%.2f",mean(d_Inv["relative_NER"][1:5]) );
    li5_impact_risk = @sprintf( "%.2f",mean( d_Inv["relative_i"][1:5]));

    ln_impact_MP = @sprintf("%.2f",d_MP["relative_NER"][1] );
    li_impact_MP = @sprintf( "%.2f",d_MP["relative_i"][1]);
    ln5_impact_MP = @sprintf("%.2f",mean(d_MP["relative_NER"][1:5]) );
    li5_impact_MP = @sprintf( "%.2f",mean( d_MP["relative_i"][1:5]));

    ln_impact_Tech = @sprintf("%.2f",d_Tech["relative_NER"][1] );
    li_impact_Tech = @sprintf( "%.2f",d_Tech["relative_i"][1]);
    ln5_impact_Tech = @sprintf("%.2f",mean(d_Tech["relative_NER"][1:5]) );
    li5_impact_Tech = @sprintf( "%.2f",mean( d_Tech["relative_i"][1:5]));

    if fig_save == 1
        io = open(tables_overleaf*"/NER_i_IRF.txt", "w");
        write(io, "Data & "*ln_impact*" & "*li_impact*" && "*ln5_impact*" & "*li5_impact *"\\\\[0.2cm] \n");
        write(io,"Model &&&&& \\\\ \n")
        write(io, "\\quad US UIP Shock & "*ln_impact_UIP*" & "*li_impact_UIP*" && "*ln5_impact_UIP*" & "*li5_impact_UIP *"\\\\ \n");
        write(io, "\\quad US Monetary Policy Shock & "*ln_impact_MP*" & "*li_impact_MP*" && "*ln5_impact_MP*" & "*li5_impact_MP *"\\\\ \n");
        write(io, "\\quad US Technology Shock & "*ln_impact_Tech*" & "*li_impact_Tech*" && "*ln5_impact_Tech*" & "*li5_impact_Tech *"\\\\ \\hline \n");
        close(io);

        io = open(tables_overleaf*"/NER_i_IRF_with_risk.txt", "w");
        write(io, "Data & "*ln_impact*" & "*li_impact*" && "*ln5_impact*" & "*li5_impact *"\\\\[0.2cm] \n");
        write(io,"Model &&&&& \\\\ \n")
        write(io, "\\quad US UIP Shock & "*ln_impact_UIP*" & "*li_impact_UIP*" && "*ln5_impact_UIP*" & "*li5_impact_UIP *"\\\\ \n");
        write(io, "\\quad US Capital Flight Shock & "*ln_impact_risk*" & "*li_impact_risk*" && "*ln5_impact_risk*" & "*li5_impact_risk *"\\\\ \n");
        write(io, "\\quad US Monetary Policy Shock & "*ln_impact_MP*" & "*li_impact_MP*" && "*ln5_impact_MP*" & "*li5_impact_MP *"\\\\ \n");
        write(io, "\\quad US Technology Shock & "*ln_impact_Tech*" & "*li_impact_Tech*" && "*ln5_impact_Tech*" & "*li5_impact_Tech *"\\\\ \\hline \n");
        close(io);
    end
end
function plot_ner_i(data_irf,d_UIP,d_MP,d_Tech,d_Inv; fig_save = 0)

    gridonoff = :y
    xlabel_name = "Years"
    titlefontsize_set = 20;
    legendfontsize_set = 18;

    cur_colors = get_color_palette(:auto, plot_color(:white))

    Tplot = 9;
    ms = 10;
    lw = 7;
    tplot = 0:(T-1)

    tshort = 0:(Tplot)
    xticks_label = 0:max(floor(Tplot/10),1):Tplot

  
    data_irf_plot =  data_irf["lnominal"]
    rel_NER_plot = plot(tplot,d_MP["relative_NER"],label= "MP shock",linewidth = lw,marker = :hex,markersize = ms,color = cur_colors[4])
    plot!(tplot,d_Tech["relative_NER"],label= "TFP shock",linewidth = lw,marker = :dtriangle,markersize = ms,color = cur_colors[6])
    plot!(tshort,data_irf_plot[!,:bh],label = "Data",linewidth = lw,linestyle=:dash,markersize = ms,marker = :diamond,color = cur_colors[2])
    #plot!(tshort,data_irf_plot[!,:up95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    #plot!(tshort,data_irf_plot[!,:low95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    plot!(title="Nominal Exchange Rate")
    plot!(xlims!(0,Tplot))
    plot!(ylims!(-1,1))
    plot!(xticks = xticks_label)
    plot!(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
    plot!(grid = gridonoff)
    plot!(legend = :bottomleft)
    plot!(xlabel = xlabel_name)
    plot!(titlefontsize = titlefontsize_set)
    plot!(legendfontsize=legendfontsize_set)


    data_irf_plot = data_irf["bloomberg_rate_all"]
    rel_i_plot = plot(tplot,d_MP["relative_i"],label= "MP shock",linewidth = lw,marker = :hex,markersize = ms,color = cur_colors[4])
    plot!(tplot,d_Tech["relative_i"],label= "TFP shock",linewidth = lw,marker = :dtriangle,markersize = ms,color = cur_colors[6])
    plot!(tshort,data_irf_plot[!,:bh],label = "Data",linewidth = lw,linestyle=:dash,markersize = ms,marker = :diamond,color = cur_colors[2])
    #plot!(tshort,data_irf_plot[!,:up95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    #plot!(tshort,data_irf_plot[!,:low95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    plot!(title="Nominal Interest Rate")
    plot!(xlims!(0,Tplot))
    plot!(xticks = xticks_label)
    plot!(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
    plot!(grid = gridonoff)
    plot!(titlefontsize = titlefontsize_set)
    plot!(legendfontsize=legendfontsize_set)
    plot!(legend = :none)
    plot!(xlabel = xlabel_name)


    plt = plot(
            rel_NER_plot,
            rel_i_plot,
            layout=(1,2),size = (1400,500),
            margin=5Plots.mm)
    display(plt)


    fig_name_save = string(file_overleaf*"/NER_i_MP_shock.pdf")
    if fig_save == 1
        savefig(fig_name_save)
    end


    data_irf_plot =  data_irf["lnominal"]
    rel_NER_plot_uip = plot(tplot,d_UIP["relative_NER"],label= "UIP shock",linewidth = lw,marker = :hex,markersize = ms,color = cur_colors[4])
    plot!(tplot,d_Inv["relative_NER"],label= "Risk preimum shock",linewidth = lw,marker = :dtriangle,markersize = ms,color = cur_colors[6])
    plot!(tshort,data_irf_plot[!,:bh],label = "Data",linewidth = lw,linestyle=:dash,markersize = ms,marker = :diamond,color = cur_colors[2])
    #plot!(tshort,data_irf_plot[!,:up95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    #plot!(tshort,data_irf_plot[!,:low95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    plot!(title="Nominal Exchange Rate")
    plot!(xlims!(0,Tplot))
    plot!(ylims!(-1,1))
    plot!(xticks = xticks_label)
    plot!(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
    plot!(grid = gridonoff)
    plot!(legend = :bottomleft)
    plot!(xlabel = xlabel_name)
    plot!(titlefontsize = titlefontsize_set)
    plot!(legendfontsize=legendfontsize_set)
    

    data_irf_plot = data_irf["bloomberg_rate_all"]
    rel_i_plot_uip = plot(tplot,d_UIP["relative_i"],label= "UIP shock",linewidth = lw,marker = :hex,markersize = ms,color = cur_colors[4])
    plot!(tplot,d_Inv["relative_i"],label= "Risk premium shock",linewidth = lw,marker = :dtriangle,markersize = ms,color = cur_colors[6])
    plot!(tshort,data_irf_plot[!,:bh],label = "Data",linewidth = lw,linestyle=:dash,markersize = ms,marker = :diamond,color = cur_colors[2])
    #plot!(tshort,data_irf_plot[!,:up95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    #plot!(tshort,data_irf_plot[!,:low95],label = :false,linewidth = lw,linestyle=:dot,linecolor=:green)
    plot!(title="Nominal Interest Rate")
    plot!(xlims!(0,Tplot))
    plot!(xticks = xticks_label)
    plot!(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
    plot!(grid = gridonoff)
    plot!(titlefontsize = titlefontsize_set)
    plot!(legendfontsize=legendfontsize_set)
    plot!(legend = :none)
    plot!(xlabel = xlabel_name)


    plt = plot(
            rel_NER_plot_uip,
            rel_i_plot_uip,
            layout=(1,2),size = (1400,500),
            margin=5Plots.mm)
    display(plt)

    fig_name_save = string(file_overleaf*"/NER_i_UIP_shock.pdf")
    if fig_save == 1
        savefig(fig_name_save)
    end


    data_irf_plot =  data_irf["lnominal"]
    rel_NER_plot_slide = plot(tplot,d_MP["relative_NER"],label= "MP shock",linewidth = lw,marker = :hex,markersize = ms,color = cur_colors[4])
    plot!(tplot,d_UIP["relative_NER"],label= "UIP shock",linewidth = lw,marker = :dtriangle,markersize = ms,color = cur_colors[6])
    plot!(tshort,data_irf_plot[!,:bh],label = "Data",linewidth = lw,linestyle=:dash,markersize = ms,marker = :diamond,color = cur_colors[2])
    plot!(tshort,data_irf_plot[!,:up95],label = :false,linewidth = lw,linestyle=:dot,linecolor=cur_colors[2])
    plot!(tshort,data_irf_plot[!,:low95],label = :false,linewidth = lw,linestyle=:dot,linecolor=cur_colors[2])
    plot!(title="Nominal Exchange Rate")
    plot!(xlims!(0,Tplot))
    plot!(ylims!(-1,1.5))
    plot!(xticks = xticks_label)
    plot!(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
    plot!(grid = gridonoff)
    plot!(legend = :bottomleft)
    plot!(xlabel = xlabel_name)
    plot!(titlefontsize = titlefontsize_set)
    plot!(legendfontsize=legendfontsize_set)


    data_irf_plot = data_irf["bloomberg_rate_all"]
    rel_i_plot_slide = plot(tplot,d_MP["relative_i"],label= "MP shock",linewidth = lw,marker = :hex,markersize = ms,color = cur_colors[4])
    plot!(tplot,d_UIP["relative_i"],label= "UIP shock",linewidth = lw,marker = :dtriangle,markersize = ms,color = cur_colors[6])
    plot!(tshort,data_irf_plot[!,:bh],label = "Data",linewidth = lw,linestyle=:dash,markersize = ms,marker = :diamond,color = cur_colors[2])
    plot!(tshort,data_irf_plot[!,:up95],label = :false,linewidth = lw,linestyle=:dot,linecolor=cur_colors[2])
    plot!(tshort,data_irf_plot[!,:low95],label = :false,linewidth = lw,linestyle=:dot,linecolor=cur_colors[2])
    plot!(title="Nominal Interest Rate")
    plot!(xlims!(0,Tplot))
    plot!(xticks = xticks_label)
    plot!(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:solid,linecolor=:gray,label=:false)
    plot!(grid = gridonoff)
    plot!(titlefontsize = titlefontsize_set)
    plot!(legendfontsize=legendfontsize_set)
    plot!(legend = :none)
    plot!(xlabel = xlabel_name)

    plt = plot(
        rel_NER_plot_slide,
        rel_i_plot_slide,
        layout=(1,2),size = (1400,500),
        margin=5Plots.mm)
    display(plt)

    fig_name_save = string(file_overleaf*"/NER_i_slide_UIP_MP_shock.pdf")
    if fig_save == 1
        savefig(fig_name_save)
    end

end






function plot_model_two_fun(d1,d2;country_list = ["U","P","F"],
    fig_save = 0,fig_name = "", 
    Tplot = 9,Shock_Var = Shock_Var,
    two_shock = 0, smallopen = 0 ,
    label1="",label2="",
    three = 0)


    ms = 8;
    lw = 7;
    Tpre = 3;
    tplot = (-Tpre):(T-1)
    cur_colors = get_color_palette(:auto, plot_color(:white));
    colplot_blue = palette(:Blues_3)

    scaling = 1.0;
    tshort = (-Tpre):(Tplot)
    xticks_label = -Tpre:max(floor(Tplot/10),1):Tplot


    xticks_label = -0:5:Tplot
    scaling = 1/d1["NER_F"][1]

    linemarker_list = Dict()
    if length(country_list) > 1
        linemarker_list["U"] = :square
        linemarker_list["P"] = :circle
        linemarker_list["F"] = :diamond
    else
        linemarker_list["U"] = :none
        linemarker_list["P"] = :none
        linemarker_list["F"] = :none
    end


 




            
    yl1 = "% deviation from s.s."
    yl2 = "% of s.s. GDP"
    yl3 = "p.p. deviation from s.s."

    plt_var_list = ["NER","RER","GDP","C_GDP","I_GDP","NX_GDP","exp_price","imp_price",
    "r","EXP_GDP","IMP_GDP","P","i","pi","NFA","q","D","RealY","K","risky","rp"]
    plt_title_list = ["Nominal Exchange Rate","Real Exchange Rate","GDP","Consumption","Investment","Net exports",
    "Export price","Import price","Real rate", "Exports", "Imports", "Price level",
    "Nominal interest rate","Inflation", "NFA","Asset price","Dividend", "Real Y","K","Risky rate",
    "rp"]
    plt_ylabel_list = [yl1,yl1,yl1,yl2,yl2,yl2,yl3,yl1,yl3,yl2,yl2,yl2,yl3,yl3,yl3,yl3,yl1,yl1,yl1,yl1,yl3]

    plt_list = Dict()

    iiv = 0;
    for iv in plt_var_list
        iiv +=1
        plt_list[iv] = plot(tshort,zeros(length(tshort)),linewidth = lw/2,linestyle=:dash,linecolor=:gray,label=:false)
        for ctry = country_list
            plot_var = iv*"_"*ctry
            dplot = [zeros(Tpre,1); d1[plot_var]].*scaling
            plot!(tplot,dplot,linewidth = lw,marker = linemarker_list[ctry],markersize = ms,
            lc = colplot_blue[3],label = label1)
            dplot = [zeros(Tpre,1); d2[plot_var]].*scaling
            plot!(tplot,dplot,linewidth = lw,marker = linemarker_list[ctry],markersize = ms,
            lc = colplot_blue[2],linestyle = :dash,label = label2)
            if iv == "NER"
                if fig_name == "three_uip_shock_irf"
                    plot!(legend=:bottomright)
                else
                    plot!(legend=:topright)
                end
            else
                plot!(legend=:none)
            end
        end
        plot!(title=plt_title_list[iiv])
        plot!(xlims!(-Tpre,Tplot))
        plot!(xticks = xticks_label)
        plot!(ylabel = plt_ylabel_list[iiv])
        plot!(grid = :y)
        plot!(gridalpha = 0.05)

    end




    if three == 0
        plt = plot(plt_list["NER"],plt_list["i"],
        plt_list["GDP"],plt_list["C_GDP"],size=(800,600),
        margin=4Plots.mm)
        plot!(xlabel="Years")
        plot!(legendfontsize=15)
        

    else
        plt = plot(plt_list["NER"],plt_list["i"],
        plt_list["GDP"], size=(1000,300), layout=(1,3),
        margin=6Plots.mm)
        plot!(xlabel="Years")
        plot!(legendfontsize=15)
        
    end


    plot!(titlefontfamily = "Times Roman",
    xguidefontfamily = "Times Roman",
    yguidefontfamily = "Times Roman",
        legendfontfamily =  "Times Roman")
    plot!(legendfontsize=12)
    display(plt)


    if fig_save == 1
        fig_name_save = string(file_overleaf,"/",fig_name,".pdf")
        savefig(fig_name_save)
    end

end
