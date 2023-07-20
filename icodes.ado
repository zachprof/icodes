*! Title:       icodes.ado   
*! Version:     1.0 published July 20, 2023
*! Author:      Zachary King 
*! Email:       zacharyjking90@gmail.com
*! Description: Convert SIC codes to numeric 1, 2, 3, and 4 digit SIC codes and
*!              numeric Fama-French industry codes

program def icodes 

	* Ensure Stata runs icodes using version 17 syntax
	
	version 17
	
	* Define syntax
	
	syntax varlist(max=1) [, suffix(string) SHORT NOMISSING]
	
	* Determine if any variables already exist
	
	tempname alreadyexists
	
	local `alreadyexists' = 0
	
	foreach v in sic1`suffix' sic2`suffix' sic3`suffix' sic4`suffix' ///
	ff5`suffix' ff10`suffix' ff12`suffix' ff17`suffix' ff30`suffix' ///
	ff38`suffix' ff48`suffix' ff49`suffix' {
		
		cap confirm variable `v' , exact
		
		if _rc == 0 {
			
			di as error "A variable {bf:icodes} wants to create, {bf:`v'}, already exists"
			local `alreadyexists' = 1
			
		}
		
	}
	
	if ``alreadyexists'' == 1 {
		di as error "Use {bf:suffix} option or delete variables listed above"
		exit 110
	}
	
	* Determine if sic codes are numeric or string
	
	tempname isstring
	
	local `isstring' = -1
	
	qui: ds `varlist' , has(type string)
	if "`r(varlist)'" != "" local `isstring' = 1
	
	qui: ds `varlist' , has(type numeric)
	if "`r(varlist)'" != "" local `isstring' = 0
	
	if ``isstring'' == -1 {
		di as error "{bf:`varlist'} not string or numeric"
		exit 198
	}
	
	* Convert sic codes to numeric and display warning if non-numeric values exist
	
	tempvar sic_num
	
	if ``isstring'' == 1 {
		qui: g `sic_num' = real(`varlist')
		qui: count if `sic_num' == . & `varlist' != "" & `varlist' != "."
		if r(N) != 0 {
			di as error "Warning: some observations set to missing due to non-numeric values"
		}
	}
	
	else g `sic_num' = `varlist'
	
	* Set sic codes to missing and display warning if sic codes < 0 or > 9999
	
	qui: sum `sic_num'
	
	if r(min) < 0 | r(max) > 9999 {
		di as error "Warning: some observations set to missing because < 0 or > 9999"
		qui: replace `sic_num' = . if `sic_num' < 0 | `sic_num' > 9999
	}
	
	* Convert sic codes to string with leading zeros
	
	tempvar sic_str
	
	qui: g `sic_str' = strofreal(`sic_num', "%04.0f")
	
	* Generate 1, 2, 3, and 4 digit numeric sic codes
	
	foreach n in 1 2 3 4 {
		qui: g sic`n'`suffix' = real(substr(`sic_str',1,`n'))
		label variable sic`n'`suffix' "`n'-Digit SIC Code"
	}
	
	* Generate variables containing Fama-French industry codes
	
	foreach ffn of numlist 5 10 12 17 30 38 48 49 {
	
		preserve
	
		sysuse ff`ffn'sics, clear
		
		mkmat ff_code sic_low sic_high, matrix(ffsics)
	
		forvalues i = 1/`ffn' {
			if "`short'" != "" qui: levelsof short_name if ff_code == `i', clean
			else qui: levelsof long_name if ff_code == `i', clean
			local labl`i' = "`r(levels)'"
		}
	
		restore
	
		tempname clusters
		local `clusters' = rowsof(ffsics)
	
		qui: g ff`ffn'`suffix' = .
		forvalues i = 1/``clusters'' {
			if ffsics[`i',2] == . & ffsics[`i',3] == . & `i' == ``clusters'' {
				qui: replace ff`ffn'`suffix' = ffsics[`i',1] if ff`ffn'`suffix' == . & sic4`suffix' != .
				continue, break
			}
			qui: replace ff`ffn'`suffix' = ffsics[`i',1] if sic4`suffix' >= ffsics[`i',2] & sic4`suffix' <= ffsics[`i',3] & sic4`suffix' != .
		}
		
		if "`nomissing'" != "" qui: replace ff`ffn'`suffix' = ffsics[``clusters'',1] if ff`ffn'`suffix' == . & sic4`suffix' != .
	
		forvalues i = 1/`ffn' {
			label define ff`ffn'`suffix'label `i' "`labl`i''", modify
		}
		
		label values ff`ffn'`suffix' ff`ffn'`suffix'label
		label variable ff`ffn'`suffix' "Fama-French `ffn' Industry Code"
	
	}
	
	* Reorder variables so numeric sic codes are after input sic code
	
	order sic1`suffix' sic2`suffix' sic3`suffix' sic4`suffix' ff5`suffix' ///
	ff10`suffix' ff12`suffix' ff17`suffix' ff30`suffix' ff38`suffix'     ///
	ff48`suffix' ff49`suffix', after(`varlist')

end