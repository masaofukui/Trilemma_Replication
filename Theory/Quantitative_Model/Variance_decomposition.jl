
Investment_weight_in = 0.0;
UIP_weight_in = copy(UIP_weight);
~,std_list["F_UIP_only"],autocorr_list["F_UIP_only"],corr_list["F_UIP_only"] = min_vol(Cov_list["F_UIP"],Cov_list[second_shock_name],Investment_weight_in,weight1 = UIP_weight_in )

Investment_weight_in = copy(Investment_weight);
UIP_weight_in = 0.0;
~,std_list["F_Risk_only"],autocorr_list["F_Risk_only"],corr_list["F_Risk_only"] = min_vol(Cov_list["F_UIP"],Cov_list[second_shock_name],Investment_weight_in,weight1 = UIP_weight_in )

Write_share = Dict{String,Any}()
for iv in ["dNER", "dRER","dC", "dGDP", "dNX_GDP", "di"]
    Write_share["UIP_"*iv] = std_list["F_UIP_only"][iv].^2/(std_list["F_UIP_only"][iv].^2 + std_list["F_Risk_only"][iv].^2)
    Write_share["Risk_"*iv] = 1-Write_share["UIP_"*iv];

    Write_share["UIP_"*iv] = @sprintf("%.2f",Write_share["UIP_"*iv]*100 )*"\\%";
    Write_share["Risk_"*iv] = @sprintf("%.2f",Write_share["Risk_"*iv]*100 )*"\\%";
end


io = open(tables_overleaf*"/variance_decomposition.txt", "w");
write(io, " \$\\Delta NER \$ && "*
Write_share["UIP_dNER"]*"&"*Write_share["Risk_dNER"]*"\\\\ \n");
write(io, " \$\\Delta RER \$ && "*
Write_share["UIP_dRER"]*"&"*Write_share["Risk_dRER"]*"\\\\ \n");
write(io, " \$\\Delta C \$ && "*
Write_share["UIP_dC"]*"&"*Write_share["Risk_dC"]*"\\\\ \n");
write(io, " \$\\Delta GDP \$ && "*
Write_share["UIP_dGDP"]*"&"*Write_share["Risk_dGDP"]*"\\\\ \n");
write(io, " \$\\Delta NX \$ && "*
Write_share["UIP_dNX_GDP"]*"&"*Write_share["Risk_dNX_GDP"]*"\\\\ \n");
write(io, " \$\\Delta (1+i) \$ && "*
Write_share["UIP_di"]*"&"*Write_share["Risk_di"]*"\\\\ \n");
close(io)
