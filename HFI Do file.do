//do file for regression
import excel "C:\Users\jackk\OneDrive\Desktop\Trade\Final Project\Data Set Human Freedom.xlsx", sheet("Sheet1") firstrow

//country coding
ssc install Kountry, replace
kountry Country, from(iso3c)to(iso3n)
encode Country, generate(country_id)

//reworking variables
rename HumanFreedom hfi
rename EconFreedom efi
rename Populationgrowth popgrowth
rename Inflation inflation
rename Unemployment unemployment
rename GDPpercapitagrowth gdpcapita
rename FDI fdi
rename Year year
gen ln_fdi = ln(fdi)

//initial fe and re
xtset country_id year
xtreg gdpcapita hfi efi unemployment popgrowth fdi, fe
estimates store fe_model

xtreg gdpcapita hfi efi unemployment popgrowth fdi
estimates store re_model

//hausman test
hausman fe_model re_model, sigmamore

//install xttest3 for heteroskedasticity
ssc install xttest3, replace
xtreg gdpcapita hfi efi unemployment popgrowth fdi, fe
xttest3

//heteroskedasticity robust errors
xtreg gdpcapita hfi efi unemployment popgrowth ln_fdi, fe vce(robust)
xttest3
sum gdpcapita hfi efi unemployment popgrowth fdi

//calc means of hfi
preserve
collapse (mean) hfi, by(year)
restore

corr efi hfi






