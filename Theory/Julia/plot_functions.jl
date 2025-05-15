# plot impulse response functions for two-location simulation
function plot_result(ss0_list,d,plt_list,ylbl_list;tpre = 5, tplotmax = 30, lw = 4,
    ss0_list_nopol = 0,d_nopol = 0)

    colplot = palette(:Oranges_3);
    colplot_green = palette(:Greens_3);
    colplot_blue = palette(:Blues_3);


    plt = Dict{String,Any}()
    for i in eachindex(plt_list)
        v = plt_list[i]
        println(v)
        plty = [ones(tpre)*ss0_list[v]';d[v]]
        pltx = -tpre*5:5:(T-1)*5
        plt[v] = plot(pltx,plty,linewidth=lw,label=["loc. 1" "loc. 2"],color=colplot_blue[2:3]')
        if d_nopol != 0
            plty_nopol = [ones(tpre)*ss0_list_nopol[v]';d_nopol[v]]
            plot!(pltx,plty_nopol,linewidth=lw,label=["loc. 1 (no pol.)" "loc. 2 (no pol.)"],color=colplot_blue[2:3]',linestyle=:dash)
        end
        plot!(xlim=(-tpre*5,tplotmax*5))
        plot!(xlabel="Year",title=ylbl_list[i],legend=:bottomright)
        if i !=1
            plot!(legend=false)
        end
        vline!([0],label=:none, linestyle=:dot, linecolor=:grey)
        plot!(titlefontfamily = "Times Roman",
        xguidefontfamily = "Times Roman",legendfontfamily = "Times Roman",
        titlefontsize=10,xguidefontsize=8,legendfontsize=8)

    end
    plt_all = plot(plt["Z"],plt["ell"],plt["C"],plt["W"],plt["Transfer"],plt["Price"],size=(800,600))
    plot!(margin = 5mm)
    display(plt_all)
end

# scatter plots with state label
function graph_scatter_single(x, y, xlabel, ylabel, texts = "", hline = "", vline = "";title="")
    
    if texts == ""
        scatter( x, y, label=:none)
    else
        scatter( x, y, label=:none,texts = texts, ms=0)
    end

    lfit_line = Polynomials.fit(x, y, 1)
    plot!(lfit_line,minimum(x),maximum(x),label="slope: $(round(lfit_line.coeffs[2],sigdigits=3))")

    if hline != ""
        plot!([hline], seriestype = :hline, linestyle=:dash, label="", c=:black)
    end
    if vline != ""
        plot!([vline], seriestype = :vline, linestyle=:dash, label="", c=:black)

    end

    plot!(xlabel=xlabel)
    plot!(ylabel=ylabel)
    plot!(title=title)

    
end


# scatter plots with two series with 45 degree line.
# primarily used for projecting income vs consumption (with and without transfer)
function graph_scatter_double_45(x, y_1, y_2, xlabel, ylabel, texts = ""; title="")
    
    scatter(x, y_1, label=:none, c=:red, markershape=:circle)
    scatter!(x, y_2, label=:none, c=:green, markershape=:utriangle)
    
    # 45 degree line
    plot!(x, x, label=:none, c=:grey)

    # state labels
    if texts != ""
        temp_text = [text(x, 10, :bottom) for x in texts]
        annotate!(x, y_1, temp_text)
    end    

    lfit_line = Polynomials.fit(x, y_1, 1)
    plot!(lfit_line,minimum(x),maximum(x),label="slope (consumption expenditure): $(round(lfit_line.coeffs[2],sigdigits=3))", c=:red, linestyle=:dot)

    lfit_line = Polynomials.fit(x, y_2, 1)
    plot!(lfit_line,minimum(x),maximum(x),label="slope (income + public transfer): $(round(lfit_line.coeffs[2],sigdigits=3))", c=:green, linestyle=:dashdot)

    plot!(xlabel=xlabel)
    plot!(ylabel=ylabel)
    plot!(title=title)
    
end

# scatter plots comparing observed and actual outcomes
function graph_scatter_double(x_1, y_1, x_2, y_2, xlabel, ylabel; texts = "", hline = "", vline = "", fourty_five_line = false)
    
    scatter(x_1, y_1, label=:none, c=:red, markershape=:circle)
    if texts != ""
        temp_text = [text(x, 10, :bottom) for x in texts]
        annotate!(x_1, y_1, temp_text, :bottom)
    end
    scatter!(x_2, y_2, label=:none, c=:blue, markershape=:rect)
    quiver!(x_1, y_1, quiver=(x_2 - x_1, y_2 - y_1))

    if fourty_five_line
        plot!(x_1, x_1, label=:none, c=:grey)
    end
    
    lfit_line = Polynomials.fit(x_1, y_1, 1)
    plot!(lfit_line,minimum(x_1),maximum(x_1),label="slope (observed): $(round(lfit_line.coeffs[2],sigdigits=3))", c=:red, linestyle=:dot)

    lfit_line = Polynomials.fit(x_2, y_2, 1)
    plot!(lfit_line,minimum(x_2),maximum(x_2),label="slope  (optimal): $(round(lfit_line.coeffs[2],sigdigits=3))", c=:blue, linestyle=:dashdot)

    if hline != ""
        plot!([hline], seriestype = :hline, linestyle=:dash, label="", c=:black)
    end
    if vline != ""
        plot!([vline], seriestype = :vline, linestyle=:dash, label="", c=:black)

    end

    plot!(xlabel=xlabel)
    plot!(ylabel=ylabel)
    
end

# regression coefficients over time
function graph_reg_over_time(x_obs, x_opt, y_obs, y_opt, hline = "", vline = "")

    coef_obs = []
    coef_opt = []
    for tplot = 1:size(x_obs, 1)
        # observed
        lfit_obs = Polynomials.fit(x_obs[tplot,:], y_obs[tplot,:], 1)
        push!(coef_obs, lfit_obs.coeffs[2])

        # optimal
        lfit_opt = Polynomials.fit(x_opt[tplot,:], y_opt[tplot,:], 1)
        push!(coef_opt, lfit_opt.coeffs[2])

    end

    y_start = 1980;
    y_end = y_start + (size(x_obs, 1) - 1)  * 5;

    plot(y_start:5:y_end, coef_obs, label="observed", c=:red, markershape=:circle)
    plot!(y_start:5:y_end, coef_opt, label="optimal", c=:blue, markershape=:rect, linestyle=:dashdot)

    plot!(xlabel="year")
    plot!(ylabel="regression coefficients")

end

