
global peg "USD"
local spec = 1
local var lnominal
use "$fig_slide_folder/R2_report_`spec'_${peg}_`var'", clear
keep if horizon >= 0 
capture file close myfile
file open myfile using "$fig_slide_folder/Table_A4.txt", write replace
forval horizon = 0/9{
	local ih = `horizon' + 1
	local R2_write = R2[`ih']
	local R2_write = string(`R2_write', "%9.2f")
	local R2_nopeg_write = R2_nopeg[`ih']
	local R2_nopeg_write = string(`R2_nopeg_write', "%9.2f")

	local R2_adj_write = R2_adj[`ih']
	local R2_adj_write = string(`R2_adj_write', "%9.2f")
	local R2_adj_nopeg_write = R2_nopeg_adj[`ih']
	local R2_adj_nopeg_write = string(`R2_adj_nopeg_write', "%9.2f")


	*file write myfile "`horizon' && `R2_write' & `R2_nopeg_write' && `R2_adj_write' & `R2_adj_nopeg_write' \\" _n
	file write myfile "`horizon' &&  `R2_adj_write' & `R2_adj_nopeg_write' \\" _n
}
file close myfile