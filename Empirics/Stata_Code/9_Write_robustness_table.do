cd "/Users/fukui/Dropbox (Personal)/Trilemma/Trilemma_Replication/Empirics"
clear
clear matrix
clear mata
set maxvar 30000
*capture log close
*log using mylog.log, replace
global fig_slide_folder "./Figures"
global fig_slide_folder "./Figures"
global fig_table_folder "./Tables"



local var RGDP_WB

local h = 4
local i_row = `h' + 4

local spec = 9
use ./Stored_Result/IRF_coef/IRF_`spec'_`var',replace
local bh =  string(bh_spec[`i_row'], "%9.2f")
local seh = string(seh_spec[`i_row'], "%9.2f")

local spec = 9
use ./Stored_Result/IRF_coef/IRF_`spec'_`var',replace
local bh_GDP = string(bh_spec[`i_row'], "%9.2f")
local seh_GDP = string(seh_spec[`i_row'], "%9.2f")

local bh_store_GDP =string(bh_store[`i_row'], "%9.2f")
local seh_store_GDP = string(seh_spec[`i_row'], "%9.2f")

local bh_nopeg_GDP = string(bh_store_nopeg[`i_row'], "%9.2f")
local seh_nopeg_GDP = string(seh_store_nopeg[`i_row'], "%9.2f")

local spec = 20
use ./Stored_Result/IRF_coef/IRF_`spec'_`var',replace
local bh_com = string(bh_spec[`i_row'], "%9.2f")
local seh_com = string(seh_spec[`i_row'], "%9.2f")

local bh_store_com = string(bh_store[`i_row'], "%9.2f")
local seh_store_com = string(seh_spec[`i_row'], "%9.2f")

local bh_nopeg_com = string(bh_store_nopeg[`i_row'], "%9.2f")
local seh_nopeg_com = string(seh_store_nopeg[`i_row'], "%9.2f")

local spec = 22
use ./Stored_Result/IRF_coef/IRF_`spec'_`var',replace
local bh_GFC = string(bh_spec[`i_row'], "%9.2f")
local seh_GFC = string(seh_spec[`i_row'], "%9.2f")

local bh_store_GFC = string(bh_store[`i_row'], "%9.2f")
local seh_store_GFC = string(seh_spec[`i_row'], "%9.2f")

local bh_nopeg_GFC = string(bh_store_nopeg[`i_row'], "%9.2f")
local seh_nopeg_GFC = string(seh_store_nopeg[`i_row'], "%9.2f")

local spec = 24
use ./Stored_Result/IRF_coef/IRF_`spec'_`var',replace
local bh_ka = string(bh_spec[`i_row'], "%9.2f")
local seh_ka = string(seh_spec[`i_row'], "%9.2f")

local bh_store_ka= string(bh_store[`i_row'], "%9.2f")
local seh_store_ka = string(seh_spec[`i_row'], "%9.2f")

local bh_nopeg_ka = string(bh_store_nopeg[`i_row'], "%9.2f")
local seh_nopeg_ka = string(seh_store_nopeg[`i_row'], "%9.2f")





capture file close myfile
file open myfile using "$fig_table_folder/Table_3.txt", write replace
file write myfile "Peg\$\times \Delta\$USD && `bh' &&  & `bh_GDP' &&  & `bh_com' && & `bh_GFC'  \\" _n
file write myfile " && (`seh') &&  & (`seh_GDP') &&  & (`seh_com') && & (`seh_GFC')   \\" _n
file write myfile "Peg\$\times \Delta\$(US GDP) &&  && `bh_nopeg_GDP' & `bh_store_GDP' &&  &  && &  \\" _n
file write myfile " &&  && (`seh_nopeg_GDP') & (`seh_store_GDP') &&  &  && &   \\" _n
file write myfile "Peg\$\times \Delta\$(Com. P.) &&  &&  &  && `bh_nopeg_com' & `bh_store_com' && &  \\" _n
file write myfile " &&  &&  &  && (`seh_nopeg_com') & (`seh_store_com') && &   \\" _n
file write myfile "Peg\$\times \Delta\$GFC &&  &&  &  &&  &  && `bh_nopeg_GFC' & `bh_store_GFC' \\" _n
file write myfile " &&  &&  &  &&  &  && (`seh_nopeg_GFC') &  (`seh_store_GFC')  \\" _n
file close myfile



