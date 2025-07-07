io = open(tables_overleaf*"/disconnect_table.txt", "w");
write(io, "\\textbf{A. Volatility }& && & & \\\\ \n");
write(io, "\\quad std(\$ \\Delta NER\$) & "*
data_write["std_dNER"]*"&&"*std_write["dNER_UIP_I_mix"]*
" & "*std_write["dNER_UIP_TFP_mix"]*
" & "*std_write["dNER_UIP"]*" & "*std_write["dNER_Risk"]*
" & "*std_write["dNER_TFP"]*" & "*std_write["dNER_MP"]* 
" & "*std_write["dNER_UIP_TFP_mix_nos"]* "\\\\ \n");
write(io, "\\quad std(\$ \\Delta RER\$) & "*
data_write["std_dRER"]*"&&"*std_write["dRER_UIP_I_mix"]*
" & "*std_write["dRER_UIP_TFP_mix"]*
" & "*std_write["dRER_UIP"]*" & "*std_write["dRER_Risk"]*
" & "*std_write["dRER_TFP"]*" & "*std_write["dRER_MP"]* 
" & "*std_write["dRER_UIP_TFP_mix_nos"]*"\\\\ \n");
write(io, "\\quad std(\$ \\Delta GDP\$) & "*
gdp_std_write*"&&"*gdp_std_write*
" & "*gdp_std_write*
" & "*gdp_std_write*" & "*gdp_std_write*
" & "*gdp_std_write*" & "*gdp_std_write* 
" & "*gdp_std_write* "\\\\ \n");

#write(io, "\\quad std(\$ \\Delta GDP\$) && "*data_mat[4,3]*"&&"*std_write["dC_UIP_I_mix"]*" & "*std_write["dC_UIP"]*" & "*std_write["dC_Risk"]* "\\\\ \n");
write(io, "\\quad std(\$ \\Delta C\$) & "*data_write["std_dC"]*
"&&"*std_write["dC_UIP_I_mix"]*
" & "*std_write["dC_UIP_TFP_mix"]*
" & "*std_write["dC_UIP"]*" & "*std_write["dC_Risk"]*
" & "*std_write["dC_TFP"]*" & "*std_write["dC_MP"]*
" & "*std_write["dC_UIP_TFP_mix_nos"]* "\\\\ \n");

write(io, "\\quad std(\$ \\Delta NX\$) & "*data_write["std_dNX_GDP"]*
"&&"*std_write["dNX_GDP_UIP_I_mix"]*
" & "*std_write["dNX_GDP_UIP_TFP_mix"]*
" & "*std_write["dNX_GDP_UIP"]*" & "*std_write["dNX_GDP_Risk"]* 
" & "*std_write["dNX_GDP_TFP"]*" & "*std_write["dNX_GDP_MP"]*
" & "*std_write["dNX_GDP_UIP_TFP_mix_nos"]* "\\\\ \n");

write(io, "\\quad std(\$ \\Delta (1+i)\$) & "*data_write["std_di"]*
"&&"*std_write["di_UIP_I_mix"]*
" & "*std_write["di_UIP_TFP_mix"]*
" & "*std_write["di_UIP"]*" & "*std_write["di_Risk"]* 
" & "*std_write["di_TFP"]*" & "*std_write["di_MP"]* 
" & "*std_write["di_UIP_TFP_mix_nos"]*"\\\\ \n");

write(io, "\\\\ \n");
write(io, "\\textbf{B. Correlation }& && & & \\\\ \n");
write(io, "\\quad corr(\$ \\Delta RER,\\Delta NER \$) & "*data_write["corr_dNER"]*
" && "*corr_write["dNER_UIP_I_mix"]*
" & "*corr_write["dNER_UIP_TFP_mix"]*
" & "*corr_write["dNER_UIP"]*" & "*corr_write["dNER_Risk"] *
" & "*corr_write["dNER_TFP"]*" & "*corr_write["dNER_MP"]* 
" & "*corr_write["dNER_UIP_TFP_mix_nos"]*"\\\\ \n");

write(io, "\\quad corr(\$ \\Delta RER,\\Delta GDP \$)  & "*data_write["corr_dGDP"]*
" && "*corr_write["dGDP_UIP_I_mix"]*
" & "*corr_write["dGDP_UIP_TFP_mix"]*
" & "*corr_write["dGDP_UIP"]*" & "*corr_write["dGDP_Risk"] *
" & "*corr_write["dGDP_TFP"]*" & "*corr_write["dGDP_MP"]* 
" & "*corr_write["dGDP_UIP_TFP_mix_nos"]*"\\\\ \n");
write(io, "\\quad corr(\$ \\Delta RER,\\Delta C \$)  & "*data_write["corr_dC"]*
" && "*corr_write["dC_UIP_I_mix"]*
" & "*corr_write["dC_UIP_TFP_mix"]*
" & "*corr_write["dC_UIP"]*" & "*corr_write["dC_Risk"] *
" & "*corr_write["dC_TFP"]*" & "*corr_write["dC_MP"]* 
" & "*corr_write["dC_UIP_TFP_mix_nos"]*"\\\\ \n");

write(io, "\\quad corr(\$ \\Delta RER,\\Delta NX \$)  & "*data_write["corr_dNX_GDP"]*
" && "*corr_write["dNX_GDP_UIP_I_mix"]*
" & "*corr_write["dNX_GDP_UIP_TFP_mix"]*
" & "*corr_write["dNX_GDP_UIP"]*" & "*corr_write["dNX_GDP_Risk"] *
" & "*corr_write["dNX_GDP_TFP"]*" & "*corr_write["dNX_GDP_MP"]* 
" & "*corr_write["dNX_GDP_UIP_TFP_mix_nos"]*"\\\\  \n");


write(io, "\\quad corr(\$ \\Delta RER,\\Delta (1+i)\$)  & "*data_write["corr_di"]*
" && "*corr_write["di_UIP_I_mix"]*
" & "*corr_write["di_UIP_TFP_mix"]*
" & "*corr_write["di_UIP"]*" & "*corr_write["di_Risk"] *
" & "*corr_write["di_TFP"]*" & "*corr_write["di_MP"]* 
" & "*corr_write["di_UIP_TFP_mix_nos"]*"\\\\ \\hline \n");

close(io);
