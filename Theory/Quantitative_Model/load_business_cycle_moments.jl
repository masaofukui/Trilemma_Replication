data_mat = readdlm("Empirics/Tables/Table_4.tex",'&')
float_col = 4;
gdp_std_data = data_mat[4,float_col];
data_write = Dict{String,Any}()
data_write["std_dNER"] = @sprintf("%.3f",data_mat[2,float_col]);
data_write["std_dRER"] =  @sprintf("%.3f",data_mat[3,float_col]);
data_write["std_dC"] = @sprintf("%.3f",data_mat[5,float_col]);
data_write["std_dNX_GDP"] = @sprintf("%.3f",data_mat[6,float_col]);
data_write["std_di"] = @sprintf("%.3f",data_mat[7,float_col]);

data_write["corr_dNER"] = @sprintf("%.3f",data_mat[10,float_col]);
data_write["corr_dGDP"] =  @sprintf("%.3f",data_mat[11,float_col]);
data_write["corr_dC"] = @sprintf("%.3f",data_mat[12,float_col]);
data_write["corr_dNX_GDP"] = @sprintf("%.3f",data_mat[13,float_col]);
data_write["corr_di"] = @sprintf("%.3f",data_mat[14,float_col]);
gdp_std_write = @sprintf("%.3f",gdp_std_data);

target_vol_var = "dNER"
if target_vol_var == "dRER"
    target_vol = parse(Float64,data_write["std_dRER"])/gdp_std_data;
elseif target_vol_var == "dNER"
    target_vol = parse(Float64,data_write["std_dNER"])/gdp_std_data;
end







data_mat_others = readdlm(tables_overleaf*"/Business_cycle_moments_others.tex",'&')
float_col = 4;
data_write_others = Dict{String,Any}()
data_write_others["std_dI"] = @sprintf("%.3f",data_mat_others[1,float_col]);
data_write_others["corrY_dC"] = @sprintf("%.3f",data_mat_others[2,float_col]);
data_write_others["corrY_dI"] = @sprintf("%.3f",data_mat_others[3,float_col]);
data_write_others["corrY_dNX_GDP"] = @sprintf("%.3f",data_mat_others[4,float_col]);
data_write_others["corrY_di"] = @sprintf("%.3f",data_mat_others[5,float_col]);
data_write_others["rho_dRER"] = @sprintf("%.3f",data_mat_others[6,float_col]);
data_write_others["rho_dNER"] = @sprintf("%.3f",data_mat_others[7,float_col]);
data_write_others["rho_dGDP"] = @sprintf("%.3f",data_mat_others[8,float_col]);
data_write_others["rho_dC"] = @sprintf("%.3f",data_mat_others[9,float_col]);
data_write_others["rho_dI"] = @sprintf("%.3f",data_mat_others[10,float_col]);
data_write_others["rho_dNX_GDP"] = @sprintf("%.3f",data_mat_others[11,float_col]);
data_write_others["rho_di"] = @sprintf("%.3f",data_mat_others[12,float_col]);