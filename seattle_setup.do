clear
capture log close
set more off
pause on

//this allows you to specify the file directory where you want your work saved
*cd "K:\UROP\Analysis"

***********NOW LET'S BRING IN 2019**************
//insheet using is the command to open csv files in stata - comma case names keeps the

insheet using "K:\UROP\Data\seattle2019.csv" , comma case names

*LET'S KEEP THIS CONSISTENT WITH THE 2011-2017 HMDA DATA, WHICH STARTS WITH "LOAN TYPE"

*Loan Type
label def loantypel /// //three back slashes is a line extension
1 "Conventional" ///
2 "FHA" ///
3 "VA" ///
4 "FSA/RHS"
label values loan_type loantypel

*Property Type //Not in the 2018-2020 HMDA

*Loan Purpose - this is different from 2011-2017
label def loanpurposel ///
1 "Home purchase" ///
2 "Home improvement" ///
4 "Other purpose" ///
5 "Not applicable" ///
31 "Refinance" ///
32 "Cash-out refinance"
label values loan_purpose loanpurposel

*Owner occupancy - this is different from 2011-2017
label def occupancytypel ///
1 "Principal residence" ///
2 "Second residence" ///
3 "Investment property"
label values occupancy_type occupancytypel
label var occupancy_type "Occupancy type for the dwelling"

*Preapproval
label var preapproval "Whether the applicant requested preapproval"
label def preapprovall ///
1 "Preapproval Requested" ///
2 "Preapproval Not Requested"
label values preapproval preapprovall

*Action Taken
label def actionl ///
1 "Loan originated" ///
2 "Appl approved but not accptd" ///
3 "Appl denied by fin instn" ///
4 "Appl withdrwn by applcnt" ///
5 "File closed b/c incomplete" ///
6 "Loan purchased by instn" ///
7 "Prappve denied by fin instn" ///
8 "Prappve apprvd by not accptd"
label values action_taken actionl

*Ethnicity - this is different from 2011-2017
label def ethnicity2020l ///
1 "Hispanic" ///
2 "Not Hispanc" ///
3 "Not provided" ///
4 "Not applicable" ///
11 "Mexican" ///
12 "Puerto Rican" ///
13 "Cuban" ///
14 "Other Hispanic/Latino"
label values applicant_ethnicity1 ethnicity2020l

*Race - this is different from 2011-2017
label def race2020l ///
1 "Am. Indian" ///
2 "Asian" ///
3 "Black" ///
4 "Nat. Hawaiian" ///
5 "White" ///
6 "Not provided" ///
7 "Not applicable" ///
21 "Asian Indian" ///
22 "Chinese" ///
23 "Filipino" ///
24 "Japanese" ///
25 "Korean" ///
26 "Vietnamese" ///
27 "Other Asian" ///
41 "Nat. Hawaiian" ///
42 "Guamian/Chamorro" ///
43 "Samoan" ///
44 "Other Pacific Islander"

label values applicant_race1 race2020l

*Gender - this is different from 2011-2017
label def gender2020l ///
1 "Male" ///
2 "Female" ///
3 "Not provided" ///
4 "Not applicable" ///
6 "Chose male &amp; female"
label values applicant_sex gender2020l

*Purchaser Type - this is different from 2011-2017
label var purchaser_type "Entity purchasing covered loan"
label def purchasertype2020l ///
0 "Not applicable" ///
1 "Fannie Mae" ///
2 "Ginnie Mae" ///
3 "Freddie Mac" ///
4 "Farmer Mac" ///
5 "Private securitizer" ///
6 "Commercial bank" ///
8 "Affiliate institution" ///
9 "Other purchaser" ///
71 "Credit union" ///
72 "Life insurance company"
label values purchaser_type purchasertype2020l

*Denial Reason
label def denialreason2020l ///
1 "Debt-to-income ratio" ///
2 "Employment history" ///
3 "Credit history" ///
4 "Collateral" ///
5 "Insufficient cash" ///
6 "Unverifiable info" ///
7 "Credit appl incmplt" ///
8 "Mortg Insr Denied" ///
9 "Other" ///
10 "Not applicable" ///
1111 "Exempt"
label values denial_reason1 denialreason2020l

*HOEPA Status - this is different from 2011-2017

label def hoepa2020l ///
1 "High-cost mortgage" ///
2 "Not high-cost mortgage" ///
3 "Not applicable"
label values hoepa_status hoepa2020l

*Lien Status - this is different from 2011-2017
label def lienstatus2020l ///
1 "Secured by 1st lien" ///
2 "Secured by subordinate lien"
label values lien_status lienstatus2020l

*NOW ON TO NEW VARIABLES NOT INCLUDED IN 2011-2017 DATA

*Business or Commercial Purpose
label var business_or_commercial "Whether loan is for business/commercial purpose"
label def businessl ///
1 "Primarily business" ///
2 "Not primarily business"
label values business_or_commercial businessl

*Loan to Value Ratio
*This needs to be cleaned so it's numeric and not a string
replace loan_to_value="" if loan_to_value=="NA" 
//this is telling stata to change the value of the variable to missing
/*

This command alone did not eliminate all non-numeric characters from the variable.
So, I created a new variable to identify the non-numeric variables in the following way:
gen byte notnumeric=real(loan_to_value)==.

Then, to identify which ones are non-numeric, I did this:
list loan_to_value if notnumeric==1
*/
replace loan_to_value="" if loan_to_value=="Exempt"
destring loan_to_value, replace //this is telling stata to make the variable numeric
label var loan_to_value "Ratio of debt amount secured by property to the property value relied on for credit decision"

*Interest Rate
replace interest_rate="" if interest_rate=="NA" | interest_rate=="Exempt" //the | is an "or" statement
destring interest_rate, replace

*Total Loan Costs
replace total_loan_costs="" if total_loan_costs=="NA" | total_loan_costs=="Exempt"
destring total_loan_costs, replace

*Origination Charges
replace origination_charges="" if origination_charges=="NA" | origination_charges=="Exempt"
destring origination_charges, replace

*Discount Points
replace discount_points="" if discount_points=="NA" | discount_points=="Exempt"

destring discount_points, replace

*Lender Credits
replace lender_credits="" if lender_credits=="NA" | lender_credits=="Exempt"
destring lender_credits, replace

*Loan Term
replace loan_term="" if loan_term=="NA" | loan_term=="Exempt"
destring loan_term, replace

*Intro Rate Period
replace intro_rate_period="" if intro_rate_period=="NA" | intro_rate_period=="Exempt"
destring intro_rate_period, replace

*Property Value
replace property_value="" if property_value=="NA" | property_value=="Exempt"
destring property_value, replace

*Age - this is different from 2011-2017--it's a categorical variable in the new data
gen age=. //we're just going to create a numeric variable based off the string variable
replace age=1 if applicant_age=="<25"
replace age=2 if applicant_age=="25-34"
replace age=3 if applicant_age=="35-44"
replace age=4 if applicant_age=="45-54"
replace age=5 if applicant_age=="55-64"
replace age=6 if applicant_age=="65-74"
replace age=7 if applicant_age==">74"
replace age=.n if applicant_age=="8888"

label def age2020l ///
1 "<25" ///
2 "25-34" ///
3 "35-44" ///
4 "45-54" ///
5 "55-64" ///
6 "65-74" ///
7 ">74" ///
.n "8888"
label values age age2020l

*Income
label var income "Gross annual income in thousands"
replace income="" if income=="NA"
destring income, replace

*Debt-to-Income Ratio - this is another categorical variable, so we'll make a numeric replica of it
gen dtiratio=.
label var dtiratio "Ratio of borrower's monthly debt to total monthly income"
replace dtiratio=1 if debt_to_income=="<20%"
replace dtiratio=2 if debt_to_income=="20%-<30%"
replace dtiratio=3 if debt_to_income=="30%-<;36%"
replace dtiratio=4 if debt_to_income=="36"
replace dtiratio=5 if debt_to_income=="37"
replace dtiratio=6 if debt_to_income=="38"
replace dtiratio=7 if debt_to_income=="39"
replace dtiratio=8 if debt_to_income=="40"
replace dtiratio=9 if debt_to_income=="41"
replace dtiratio=10 if debt_to_income=="42"
replace dtiratio=11 if debt_to_income=="43"
replace dtiratio=12 if debt_to_income=="44"
replace dtiratio=13 if debt_to_income=="45"
replace dtiratio=14 if debt_to_income=="46"
replace dtiratio=15 if debt_to_income=="47"
replace dtiratio=16 if debt_to_income=="48"
replace dtiratio=17 if debt_to_income=="49"
replace dtiratio=18 if debt_to_income=="50%-60%"
replace dtiratio=19 if debt_to_income==">60%"
replace dtiratio=.n if debt_to_income=="NA" | debt_to_income=="Exempt"

label def dtiratiol ///
1 "<20%" ///
2 "20%-30%" ///
3 "30%-36%" ///
4 "36" ///
5 "37" ///
6 "38" ///
7 "39" ///
8 "40" ///
9 "41" ///
10 "42" ///
11 "43" ///
12 "44" ///
13 "45" ///
14 "46" ///
15 "47" ///
16 "48" ///
17 "49" ///
18 "50%-60%" ///
19 ">60%" ///
.n "NA or Exempt"
label values dtiratio dtiratiol

*Credit Score Type
rename applicant_credit_score credit_score
label var credit_score "Credit scoring model used to generate the credit score"
replace credit_score=.n if credit_score==1111
label def creditl ///
1 "Equifax Beacon 5.0" ///
2 "Experian Fair Isaac" ///
3 "FICO Risk Score Classic 04" ///
4 "FICO Risk Score Classic 98" ///
5 "VantageScore 2.0" ///
6 "VantageScore 3.0" ///
7 ">1 credit scoring model" ///
8 "Other credit model" ///
9 "Not applicable" ///
.n "Exempt"
label values credit_score creditl

*Initially Payable to Institution
replace initially_payable=.n if initially_payable==1111
label var initially_payable "Whether loan was initially payable to intitution that originated loan"
label def payablel ///
1 "Initially payable to your institution" ///
2 "Not initially payable to your institution" ///
3 "Not applicable" ///
.n "Exempt"
label values initially_payable payablel

*Automated Underwriting System
local aus aus1 aus2 aus3 aus4 aus5 //this creates a macro of these variable
label var aus1 "AUS financial institution used to evaluate the application"
label def ausl ///
1 "Desktop Underwriter" ///
2 "Loan Prospector/Loan Product Advisor" ///
3 "Technology Open to Approved Lenders Scorecard" ///
4 "Guaranteed Underwriting System" ///
5 "Other" ///
6 "Not applicable" ///
.n "Exempt"
*BELOW IS AN EXAMPLE OF LOOPING over the aus macro that we created above
foreach y in `aus' {
replace `y'=.n if `y'==1111
label values `y' ausl
}

*************CENSUS VARIABLES - BY TRACT, 2010 TRACTS******************
label var tract_population "Total population in tract"
label var tract_minority "Percentage of minority population of total population"
rename ffiec_msa_md median_family_income
rename tract_to_msa msa_income_percent
label var msa_income_percent "Percentage of tract median income compared to MSA median income"
rename tract_owner_occupied owner_occupied_units
rename tract_median_age median_housing_age
label var median_housing_age "Tract median age of homes"

*MERGING WITH LENDER NAMES
rename lei lei_2018
merge m:1 lei_2018 using "K:\UROP\Data\arid2017_to_lei_xref_csv.dta", nogen

rename census_tract geo_id //this conforms with the 2011-2017 data
replace geo_id="" if geo_id=="NA"
destring geo_id, replace

save "K:\UROP\Analysis\seattle2019.dta", replace

**********************************************************************************

clear


//this allows you to specify the file directory where you want your work saved
cd "K:\UROP\Analysis"

***********NOW LET'S BRING IN 2020**************
//insheet using is the command to open csv files in stata - comma case names keeps the

insheet using "K:\UROP\Data\seattle2020.csv" , comma case names

*LET'S KEEP THIS CONSISTENT WITH THE 2011-2017 HMDA DATA, WHICH STARTS WITH "LOAN TYPE"

*Loan Type
label def loantypel /// //three back slashes is a line extension
1 "Conventional" ///
2 "FHA" ///
3 "VA" ///
4 "FSA/RHS"
label values loan_type loantypel

*Property Type //Not in the 2018-2020 HMDA

*Loan Purpose - this is different from 2011-2017
label def loanpurposel ///
1 "Home purchase" ///
2 "Home improvement" ///
4 "Other purpose" ///
5 "Not applicable" ///
31 "Refinance" ///
32 "Cash-out refinance"
label values loan_purpose loanpurposel

*Owner occupancy - this is different from 2011-2017
label def occupancytypel ///
1 "Principal residence" ///
2 "Second residence" ///
3 "Investment property"
label values occupancy_type occupancytypel
label var occupancy_type "Occupancy type for the dwelling"

*Preapproval
label var preapproval "Whether the applicant requested preapproval"
label def preapprovall ///
1 "Preapproval Requested" ///
2 "Preapproval Not Requested"
label values preapproval preapprovall

*Action Taken
label def actionl ///
1 "Loan originated" ///
2 "Appl approved but not accptd" ///
3 "Appl denied by fin instn" ///
4 "Appl withdrwn by applcnt" ///
5 "File closed b/c incomplete" ///
6 "Loan purchased by instn" ///
7 "Prappve denied by fin instn" ///
8 "Prappve apprvd by not accptd"
label values action_taken actionl

*Ethnicity - this is different from 2011-2017
label def ethnicity2020l ///
1 "Hispanic" ///
2 "Not Hispanc" ///
3 "Not provided" ///
4 "Not applicable" ///
11 "Mexican" ///
12 "Puerto Rican" ///
13 "Cuban" ///
14 "Other Hispanic/Latino"
label values applicant_ethnicity1 ethnicity2020l

*Race - this is different from 2011-2017
label def race2020l ///
1 "Am. Indian" ///
2 "Asian" ///
3 "Black" ///
4 "Nat. Hawaiian" ///
5 "White" ///
6 "Not provided" ///
7 "Not applicable" ///
21 "Asian Indian" ///
22 "Chinese" ///
23 "Filipino" ///
24 "Japanese" ///
25 "Korean" ///
26 "Vietnamese" ///
27 "Other Asian" ///
41 "Nat. Hawaiian" ///
42 "Guamian/Chamorro" ///
43 "Samoan" ///
44 "Other Pacific Islander"

label values applicant_race1 race2020l

*Gender - this is different from 2011-2017
label def gender2020l ///
1 "Male" ///
2 "Female" ///
3 "Not provided" ///
4 "Not applicable" ///
6 "Chose male &amp; female"
label values applicant_sex gender2020l

*Purchaser Type - this is different from 2011-2017
label var purchaser_type "Entity purchasing covered loan"
label def purchasertype2020l ///
0 "Not applicable" ///
1 "Fannie Mae" ///
2 "Ginnie Mae" ///
3 "Freddie Mac" ///
4 "Farmer Mac" ///
5 "Private securitizer" ///
6 "Commercial bank" ///
8 "Affiliate institution" ///
9 "Other purchaser" ///
71 "Credit union" ///
72 "Life insurance company"
label values purchaser_type purchasertype2020l

*Denial Reason
label def denialreason2020l ///
1 "Debt-to-income ratio" ///
2 "Employment history" ///
3 "Credit history" ///
4 "Collateral" ///
5 "Insufficient cash" ///
6 "Unverifiable info" ///
7 "Credit appl incmplt" ///
8 "Mortg Insr Denied" ///
9 "Other" ///
10 "Not applicable" ///
1111 "Exempt"
label values denial_reason1 denialreason2020l

*HOEPA Status - this is different from 2011-2017

label def hoepa2020l ///
1 "High-cost mortgage" ///
2 "Not high-cost mortgage" ///
3 "Not applicable"
label values hoepa_status hoepa2020l

*Lien Status - this is different from 2011-2017
label def lienstatus2020l ///
1 "Secured by 1st lien" ///
2 "Secured by subordinate lien"
label values lien_status lienstatus2020l

*NOW ON TO NEW VARIABLES NOT INCLUDED IN 2011-2017 DATA

*Business or Commercial Purpose
label var business_or_commercial "Whether loan is for business/commercial purpose"
label def businessl ///
1 "Primarily business" ///
2 "Not primarily business"
label values business_or_commercial businessl

*Loan to Value Ratio
*This needs to be cleaned so it's numeric and not a string
replace loan_to_value="" if loan_to_value=="NA" 
//this is telling stata to change the value of the variable to missing
/*

This command alone did not eliminate all non-numeric characters from the variable.
So, I created a new variable to identify the non-numeric variables in the following way:
gen byte notnumeric=real(loan_to_value)==.

Then, to identify which ones are non-numeric, I did this:
list loan_to_value if notnumeric==1
*/
replace loan_to_value="" if loan_to_value=="Exempt"
destring loan_to_value, replace //this is telling stata to make the variable numeric
label var loan_to_value "Ratio of debt amount secured by property to the property value relied on for credit decision"

*Interest Rate
replace interest_rate="" if interest_rate=="NA" | interest_rate=="Exempt" //the | is an "or" statement
destring interest_rate, replace

*Total Loan Costs
replace total_loan_costs="" if total_loan_costs=="NA" | total_loan_costs=="Exempt"
destring total_loan_costs, replace

*Origination Charges
replace origination_charges="" if origination_charges=="NA" | origination_charges=="Exempt"
destring origination_charges, replace

*Discount Points
replace discount_points="" if discount_points=="NA" | discount_points=="Exempt"

destring discount_points, replace

*Lender Credits
replace lender_credits="" if lender_credits=="NA" | lender_credits=="Exempt"
destring lender_credits, replace

*Loan Term
replace loan_term="" if loan_term=="NA" | loan_term=="Exempt"
destring loan_term, replace

*Intro Rate Period
replace intro_rate_period="" if intro_rate_period=="NA" | intro_rate_period=="Exempt"
destring intro_rate_period, replace

*Property Value
replace property_value="" if property_value=="NA" | property_value=="Exempt"
destring property_value, replace

*Age - this is different from 2011-2017--it's a categorical variable in the new data
gen age=. //we're just going to create a numeric variable based off the string variable
replace age=1 if applicant_age=="<25"
replace age=2 if applicant_age=="25-34"
replace age=3 if applicant_age=="35-44"
replace age=4 if applicant_age=="45-54"
replace age=5 if applicant_age=="55-64"
replace age=6 if applicant_age=="65-74"
replace age=7 if applicant_age==">74"
replace age=.n if applicant_age=="8888"

label def age2020l ///
1 "<25" ///
2 "25-34" ///
3 "35-44" ///
4 "45-54" ///
5 "55-64" ///
6 "65-74" ///
7 ">74" ///
.n "8888"
label values age age2020l

*Income
label var income "Gross annual income in thousands"
replace income="" if income=="NA"
destring income, replace

*Debt-to-Income Ratio - this is another categorical variable, so we'll make a numeric replica of it
gen dtiratio=.
label var dtiratio "Ratio of borrower's monthly debt to total monthly income"
replace dtiratio=1 if debt_to_income=="<20%"
replace dtiratio=2 if debt_to_income=="20%-<30%"
replace dtiratio=3 if debt_to_income=="30%-<;36%"
replace dtiratio=4 if debt_to_income=="36"
replace dtiratio=5 if debt_to_income=="37"
replace dtiratio=6 if debt_to_income=="38"
replace dtiratio=7 if debt_to_income=="39"
replace dtiratio=8 if debt_to_income=="40"
replace dtiratio=9 if debt_to_income=="41"
replace dtiratio=10 if debt_to_income=="42"
replace dtiratio=11 if debt_to_income=="43"
replace dtiratio=12 if debt_to_income=="44"
replace dtiratio=13 if debt_to_income=="45"
replace dtiratio=14 if debt_to_income=="46"
replace dtiratio=15 if debt_to_income=="47"
replace dtiratio=16 if debt_to_income=="48"
replace dtiratio=17 if debt_to_income=="49"
replace dtiratio=18 if debt_to_income=="50%-60%"
replace dtiratio=19 if debt_to_income==">60%"
replace dtiratio=.n if debt_to_income=="NA" | debt_to_income=="Exempt"

label def dtiratiol ///
1 "<20%" ///
2 "20%-30%" ///
3 "30%-36%" ///
4 "36" ///
5 "37" ///
6 "38" ///
7 "39" ///
8 "40" ///
9 "41" ///
10 "42" ///
11 "43" ///
12 "44" ///
13 "45" ///
14 "46" ///
15 "47" ///
16 "48" ///
17 "49" ///
18 "50%-60%" ///
19 ">60%" ///
.n "NA or Exempt"
label values dtiratio dtiratiol

*Credit Score Type
rename applicant_credit_score credit_score
label var credit_score "Credit scoring model used to generate the credit score"
replace credit_score=.n if credit_score==1111
label def creditl ///
1 "Equifax Beacon 5.0" ///
2 "Experian Fair Isaac" ///
3 "FICO Risk Score Classic 04" ///
4 "FICO Risk Score Classic 98" ///
5 "VantageScore 2.0" ///
6 "VantageScore 3.0" ///
7 ">1 credit scoring model" ///
8 "Other credit model" ///
9 "Not applicable" ///
.n "Exempt"
label values credit_score creditl

*Initially Payable to Institution
replace initially_payable=.n if initially_payable==1111
label var initially_payable "Whether loan was initially payable to intitution that originated loan"
label def payablel ///
1 "Initially payable to your institution" ///
2 "Not initially payable to your institution" ///
3 "Not applicable" ///
.n "Exempt"
label values initially_payable payablel

*Automated Underwriting System
local aus aus1 aus2 aus3 aus4 aus5 //this creates a macro of these variable
label var aus1 "AUS financial institution used to evaluate the application"
label def ausl ///
1 "Desktop Underwriter" ///
2 "Loan Prospector/Loan Product Advisor" ///
3 "Technology Open to Approved Lenders Scorecard" ///
4 "Guaranteed Underwriting System" ///
5 "Other" ///
6 "Not applicable" ///
.n "Exempt"
*BELOW IS AN EXAMPLE OF LOOPING over the aus macro that we created above
foreach y in `aus' {
replace `y'=.n if `y'==1111
label values `y' ausl
}

*************CENSUS VARIABLES - BY TRACT, 2010 TRACTS******************
label var tract_population "Total population in tract"
label var tract_minority "Percentage of minority population of total population"
rename ffiec_msa_md median_family_income
rename tract_to_msa msa_income_percent
label var msa_income_percent "Percentage of tract median income compared to MSA median income"
rename tract_owner_occupied owner_occupied_units
rename tract_median_age median_housing_age
label var median_housing_age "Tract median age of homes"

*MERGING WITH LENDER NAMES
rename lei lei_2018
merge m:1 lei_2018 using "K:\UROP\Data\arid2017_to_lei_xref_csv.dta", nogen

rename census_tract geo_id //this conforms with the 2011-2017 data
replace geo_id="" if geo_id=="NA"
destring geo_id, replace

save "K:\UROP\Analysis\seattle2020.dta", replace

******************************************************************************

clear


//this allows you to specify the file directory where you want your work saved
cd "K:\UROP\Analysis"

***********NOW LET'S BRING IN 2021**************
//insheet using is the command to open csv files in stata - comma case names keeps the

insheet using "K:\UROP\Data\seattle2021.csv" , comma case names

*LET'S KEEP THIS CONSISTENT WITH THE 2011-2017 HMDA DATA, WHICH STARTS WITH "LOAN TYPE"

*Loan Type
label def loantypel /// //three back slashes is a line extension
1 "Conventional" ///
2 "FHA" ///
3 "VA" ///
4 "FSA/RHS"
label values loan_type loantypel

*Property Type //Not in the 2018-2020 HMDA

*Loan Purpose - this is different from 2011-2017
label def loanpurposel ///
1 "Home purchase" ///
2 "Home improvement" ///
4 "Other purpose" ///
5 "Not applicable" ///
31 "Refinance" ///
32 "Cash-out refinance"
label values loan_purpose loanpurposel

*Owner occupancy - this is different from 2011-2017
label def occupancytypel ///
1 "Principal residence" ///
2 "Second residence" ///
3 "Investment property"
label values occupancy_type occupancytypel
label var occupancy_type "Occupancy type for the dwelling"

*Preapproval
label var preapproval "Whether the applicant requested preapproval"
label def preapprovall ///
1 "Preapproval Requested" ///
2 "Preapproval Not Requested"
label values preapproval preapprovall

*Action Taken
label def actionl ///
1 "Loan originated" ///
2 "Appl approved but not accptd" ///
3 "Appl denied by fin instn" ///
4 "Appl withdrwn by applcnt" ///
5 "File closed b/c incomplete" ///
6 "Loan purchased by instn" ///
7 "Prappve denied by fin instn" ///
8 "Prappve apprvd by not accptd"
label values action_taken actionl

*Ethnicity - this is different from 2011-2017
label def ethnicity2020l ///
1 "Hispanic" ///
2 "Not Hispanc" ///
3 "Not provided" ///
4 "Not applicable" ///
11 "Mexican" ///
12 "Puerto Rican" ///
13 "Cuban" ///
14 "Other Hispanic/Latino"
label values applicant_ethnicity1 ethnicity2020l

*Race - this is different from 2011-2017
label def race2020l ///
1 "Am. Indian" ///
2 "Asian" ///
3 "Black" ///
4 "Nat. Hawaiian" ///
5 "White" ///
6 "Not provided" ///
7 "Not applicable" ///
21 "Asian Indian" ///
22 "Chinese" ///
23 "Filipino" ///
24 "Japanese" ///
25 "Korean" ///
26 "Vietnamese" ///
27 "Other Asian" ///
41 "Nat. Hawaiian" ///
42 "Guamian/Chamorro" ///
43 "Samoan" ///
44 "Other Pacific Islander"

label values applicant_race1 race2020l

*Gender - this is different from 2011-2017
label def gender2020l ///
1 "Male" ///
2 "Female" ///
3 "Not provided" ///
4 "Not applicable" ///
6 "Chose male &amp; female"
label values applicant_sex gender2020l

*Purchaser Type - this is different from 2011-2017
label var purchaser_type "Entity purchasing covered loan"
label def purchasertype2020l ///
0 "Not applicable" ///
1 "Fannie Mae" ///
2 "Ginnie Mae" ///
3 "Freddie Mac" ///
4 "Farmer Mac" ///
5 "Private securitizer" ///
6 "Commercial bank" ///
8 "Affiliate institution" ///
9 "Other purchaser" ///
71 "Credit union" ///
72 "Life insurance company"
label values purchaser_type purchasertype2020l

*Denial Reason
label def denialreason2020l ///
1 "Debt-to-income ratio" ///
2 "Employment history" ///
3 "Credit history" ///
4 "Collateral" ///
5 "Insufficient cash" ///
6 "Unverifiable info" ///
7 "Credit appl incmplt" ///
8 "Mortg Insr Denied" ///
9 "Other" ///
10 "Not applicable" ///
1111 "Exempt"
label values denial_reason1 denialreason2020l

*HOEPA Status - this is different from 2011-2017

label def hoepa2020l ///
1 "High-cost mortgage" ///
2 "Not high-cost mortgage" ///
3 "Not applicable"
label values hoepa_status hoepa2020l

*Lien Status - this is different from 2011-2017
label def lienstatus2020l ///
1 "Secured by 1st lien" ///
2 "Secured by subordinate lien"
label values lien_status lienstatus2020l

*NOW ON TO NEW VARIABLES NOT INCLUDED IN 2011-2017 DATA

*Business or Commercial Purpose
label var business_or_commercial "Whether loan is for business/commercial purpose"
label def businessl ///
1 "Primarily business" ///
2 "Not primarily business"
label values business_or_commercial businessl

*Loan to Value Ratio
*This needs to be cleaned so it's numeric and not a string
replace loan_to_value="" if loan_to_value=="NA" 
//this is telling stata to change the value of the variable to missing
/*

This command alone did not eliminate all non-numeric characters from the variable.
So, I created a new variable to identify the non-numeric variables in the following way:
gen byte notnumeric=real(loan_to_value)==.

Then, to identify which ones are non-numeric, I did this:
list loan_to_value if notnumeric==1
*/
replace loan_to_value="" if loan_to_value=="Exempt"
destring loan_to_value, replace //this is telling stata to make the variable numeric
label var loan_to_value "Ratio of debt amount secured by property to the property value relied on for credit decision"

*Interest Rate
replace interest_rate="" if interest_rate=="NA" | interest_rate=="Exempt" //the | is an "or" statement
destring interest_rate, replace

*Total Loan Costs
replace total_loan_costs="" if total_loan_costs=="NA" | total_loan_costs=="Exempt"
destring total_loan_costs, replace

*Origination Charges
replace origination_charges="" if origination_charges=="NA" | origination_charges=="Exempt"
destring origination_charges, replace

*Discount Points
replace discount_points="" if discount_points=="NA" | discount_points=="Exempt"

destring discount_points, replace

*Lender Credits
replace lender_credits="" if lender_credits=="NA" | lender_credits=="Exempt"
destring lender_credits, replace

*Loan Term
replace loan_term="" if loan_term=="NA" | loan_term=="Exempt"
destring loan_term, replace

*Intro Rate Period
replace intro_rate_period="" if intro_rate_period=="NA" | intro_rate_period=="Exempt"
destring intro_rate_period, replace

*Property Value
replace property_value="" if property_value=="NA" | property_value=="Exempt"
destring property_value, replace

*Age - this is different from 2011-2017--it's a categorical variable in the new data
gen age=. //we're just going to create a numeric variable based off the string variable
replace age=1 if applicant_age=="<25"
replace age=2 if applicant_age=="25-34"
replace age=3 if applicant_age=="35-44"
replace age=4 if applicant_age=="45-54"
replace age=5 if applicant_age=="55-64"
replace age=6 if applicant_age=="65-74"
replace age=7 if applicant_age==">74"
replace age=.n if applicant_age=="8888"

label def age2020l ///
1 "<25" ///
2 "25-34" ///
3 "35-44" ///
4 "45-54" ///
5 "55-64" ///
6 "65-74" ///
7 ">74" ///
.n "8888"
label values age age2020l

*Income
label var income "Gross annual income in thousands"
replace income="" if income=="NA"
destring income, replace

*Debt-to-Income Ratio - this is another categorical variable, so we'll make a numeric replica of it
gen dtiratio=.
label var dtiratio "Ratio of borrower's monthly debt to total monthly income"
replace dtiratio=1 if debt_to_income=="<20%"
replace dtiratio=2 if debt_to_income=="20%-<30%"
replace dtiratio=3 if debt_to_income=="30%-<;36%"
replace dtiratio=4 if debt_to_income=="36"
replace dtiratio=5 if debt_to_income=="37"
replace dtiratio=6 if debt_to_income=="38"
replace dtiratio=7 if debt_to_income=="39"
replace dtiratio=8 if debt_to_income=="40"
replace dtiratio=9 if debt_to_income=="41"
replace dtiratio=10 if debt_to_income=="42"
replace dtiratio=11 if debt_to_income=="43"
replace dtiratio=12 if debt_to_income=="44"
replace dtiratio=13 if debt_to_income=="45"
replace dtiratio=14 if debt_to_income=="46"
replace dtiratio=15 if debt_to_income=="47"
replace dtiratio=16 if debt_to_income=="48"
replace dtiratio=17 if debt_to_income=="49"
replace dtiratio=18 if debt_to_income=="50%-60%"
replace dtiratio=19 if debt_to_income==">60%"
replace dtiratio=.n if debt_to_income=="NA" | debt_to_income=="Exempt"

label def dtiratiol ///
1 "<20%" ///
2 "20%-30%" ///
3 "30%-36%" ///
4 "36" ///
5 "37" ///
6 "38" ///
7 "39" ///
8 "40" ///
9 "41" ///
10 "42" ///
11 "43" ///
12 "44" ///
13 "45" ///
14 "46" ///
15 "47" ///
16 "48" ///
17 "49" ///
18 "50%-60%" ///
19 ">60%" ///
.n "NA or Exempt"
label values dtiratio dtiratiol

*Credit Score Type
rename applicant_credit_score credit_score
label var credit_score "Credit scoring model used to generate the credit score"
replace credit_score=.n if credit_score==1111
label def creditl ///
1 "Equifax Beacon 5.0" ///
2 "Experian Fair Isaac" ///
3 "FICO Risk Score Classic 04" ///
4 "FICO Risk Score Classic 98" ///
5 "VantageScore 2.0" ///
6 "VantageScore 3.0" ///
7 ">1 credit scoring model" ///
8 "Other credit model" ///
9 "Not applicable" ///
.n "Exempt"
label values credit_score creditl

*Initially Payable to Institution
replace initially_payable=.n if initially_payable==1111
label var initially_payable "Whether loan was initially payable to intitution that originated loan"
label def payablel ///
1 "Initially payable to your institution" ///
2 "Not initially payable to your institution" ///
3 "Not applicable" ///
.n "Exempt"
label values initially_payable payablel

*Automated Underwriting System
local aus aus1 aus2 aus3 aus4 aus5 //this creates a macro of these variable
label var aus1 "AUS financial institution used to evaluate the application"
label def ausl ///
1 "Desktop Underwriter" ///
2 "Loan Prospector/Loan Product Advisor" ///
3 "Technology Open to Approved Lenders Scorecard" ///
4 "Guaranteed Underwriting System" ///
5 "Other" ///
6 "Not applicable" ///
.n "Exempt"
*BELOW IS AN EXAMPLE OF LOOPING over the aus macro that we created above
foreach y in `aus' {
replace `y'=.n if `y'==1111
label values `y' ausl
}

*************CENSUS VARIABLES - BY TRACT, 2010 TRACTS******************
label var tract_population "Total population in tract"
label var tract_minority "Percentage of minority population of total population"
rename ffiec_msa_md median_family_income
rename tract_to_msa msa_income_percent
label var msa_income_percent "Percentage of tract median income compared to MSA median income"
rename tract_owner_occupied owner_occupied_units
rename tract_median_age median_housing_age
label var median_housing_age "Tract median age of homes"

*MERGING WITH LENDER NAMES
rename lei lei_2018
merge m:1 lei_2018 using "K:\UROP\Data\arid2017_to_lei_xref_csv.dta", nogen

rename census_tract geo_id //this conforms with the 2011-2017 data
replace geo_id="" if geo_id=="NA"
destring geo_id, replace

save "K:\UROP\Analysis\seattle2021.dta", replace

****************************************************************************************

clear


//this allows you to specify the file directory where you want your work saved
cd "K:\UROP\Analysis"

***********NOW LET'S BRING IN 2022**************
//insheet using is the command to open csv files in stata - comma case names keeps the

insheet using "K:\UROP\Data\seattle2022.csv" , comma case names

*LET'S KEEP THIS CONSISTENT WITH THE 2011-2017 HMDA DATA, WHICH STARTS WITH "LOAN TYPE"

*Loan Type
label def loantypel /// //three back slashes is a line extension
1 "Conventional" ///
2 "FHA" ///
3 "VA" ///
4 "FSA/RHS"
label values loan_type loantypel

*Property Type //Not in the 2018-2020 HMDA

*Loan Purpose - this is different from 2011-2017
label def loanpurposel ///
1 "Home purchase" ///
2 "Home improvement" ///
4 "Other purpose" ///
5 "Not applicable" ///
31 "Refinance" ///
32 "Cash-out refinance"
label values loan_purpose loanpurposel

*Owner occupancy - this is different from 2011-2017
label def occupancytypel ///
1 "Principal residence" ///
2 "Second residence" ///
3 "Investment property"
label values occupancy_type occupancytypel
label var occupancy_type "Occupancy type for the dwelling"

*Preapproval
label var preapproval "Whether the applicant requested preapproval"
label def preapprovall ///
1 "Preapproval Requested" ///
2 "Preapproval Not Requested"
label values preapproval preapprovall

*Action Taken
label def actionl ///
1 "Loan originated" ///
2 "Appl approved but not accptd" ///
3 "Appl denied by fin instn" ///
4 "Appl withdrwn by applcnt" ///
5 "File closed b/c incomplete" ///
6 "Loan purchased by instn" ///
7 "Prappve denied by fin instn" ///
8 "Prappve apprvd by not accptd"
label values action_taken actionl

*Ethnicity - this is different from 2011-2017
label def ethnicity2020l ///
1 "Hispanic" ///
2 "Not Hispanc" ///
3 "Not provided" ///
4 "Not applicable" ///
11 "Mexican" ///
12 "Puerto Rican" ///
13 "Cuban" ///
14 "Other Hispanic/Latino"
label values applicant_ethnicity1 ethnicity2020l

*Race - this is different from 2011-2017
label def race2020l ///
1 "Am. Indian" ///
2 "Asian" ///
3 "Black" ///
4 "Nat. Hawaiian" ///
5 "White" ///
6 "Not provided" ///
7 "Not applicable" ///
21 "Asian Indian" ///
22 "Chinese" ///
23 "Filipino" ///
24 "Japanese" ///
25 "Korean" ///
26 "Vietnamese" ///
27 "Other Asian" ///
41 "Nat. Hawaiian" ///
42 "Guamian/Chamorro" ///
43 "Samoan" ///
44 "Other Pacific Islander"

label values applicant_race1 race2020l

*Gender - this is different from 2011-2017
label def gender2020l ///
1 "Male" ///
2 "Female" ///
3 "Not provided" ///
4 "Not applicable" ///
6 "Chose male &amp; female"
label values applicant_sex gender2020l

*Purchaser Type - this is different from 2011-2017
label var purchaser_type "Entity purchasing covered loan"
label def purchasertype2020l ///
0 "Not applicable" ///
1 "Fannie Mae" ///
2 "Ginnie Mae" ///
3 "Freddie Mac" ///
4 "Farmer Mac" ///
5 "Private securitizer" ///
6 "Commercial bank" ///
8 "Affiliate institution" ///
9 "Other purchaser" ///
71 "Credit union" ///
72 "Life insurance company"
label values purchaser_type purchasertype2020l

*Denial Reason
label def denialreason2020l ///
1 "Debt-to-income ratio" ///
2 "Employment history" ///
3 "Credit history" ///
4 "Collateral" ///
5 "Insufficient cash" ///
6 "Unverifiable info" ///
7 "Credit appl incmplt" ///
8 "Mortg Insr Denied" ///
9 "Other" ///
10 "Not applicable" ///
1111 "Exempt"
label values denial_reason1 denialreason2020l

*HOEPA Status - this is different from 2011-2017

label def hoepa2020l ///
1 "High-cost mortgage" ///
2 "Not high-cost mortgage" ///
3 "Not applicable"
label values hoepa_status hoepa2020l

*Lien Status - this is different from 2011-2017
label def lienstatus2020l ///
1 "Secured by 1st lien" ///
2 "Secured by subordinate lien"
label values lien_status lienstatus2020l

*NOW ON TO NEW VARIABLES NOT INCLUDED IN 2011-2017 DATA

*Business or Commercial Purpose
label var business_or_commercial "Whether loan is for business/commercial purpose"
label def businessl ///
1 "Primarily business" ///
2 "Not primarily business"
label values business_or_commercial businessl

*Loan to Value Ratio
*This needs to be cleaned so it's numeric and not a string
replace loan_to_value="" if loan_to_value=="NA" 
//this is telling stata to change the value of the variable to missing
/*

This command alone did not eliminate all non-numeric characters from the variable.
So, I created a new variable to identify the non-numeric variables in the following way:
gen byte notnumeric=real(loan_to_value)==.

Then, to identify which ones are non-numeric, I did this:
list loan_to_value if notnumeric==1
*/
replace loan_to_value="" if loan_to_value=="Exempt"
destring loan_to_value, replace //this is telling stata to make the variable numeric
label var loan_to_value "Ratio of debt amount secured by property to the property value relied on for credit decision"

*Interest Rate
replace interest_rate="" if interest_rate=="NA" | interest_rate=="Exempt" //the | is an "or" statement
destring interest_rate, replace

*Total Loan Costs
replace total_loan_costs="" if total_loan_costs=="NA" | total_loan_costs=="Exempt"
destring total_loan_costs, replace

*Origination Charges
replace origination_charges="" if origination_charges=="NA" | origination_charges=="Exempt"
destring origination_charges, replace

*Discount Points
replace discount_points="" if discount_points=="NA" | discount_points=="Exempt"

destring discount_points, replace

*Lender Credits
replace lender_credits="" if lender_credits=="NA" | lender_credits=="Exempt"
destring lender_credits, replace

*Loan Term
replace loan_term="" if loan_term=="NA" | loan_term=="Exempt"
destring loan_term, replace

*Intro Rate Period
replace intro_rate_period="" if intro_rate_period=="NA" | intro_rate_period=="Exempt"
destring intro_rate_period, replace

*Property Value
replace property_value="" if property_value=="NA" | property_value=="Exempt"
destring property_value, replace

*Age - this is different from 2011-2017--it's a categorical variable in the new data
gen age=. //we're just going to create a numeric variable based off the string variable
replace age=1 if applicant_age=="<25"
replace age=2 if applicant_age=="25-34"
replace age=3 if applicant_age=="35-44"
replace age=4 if applicant_age=="45-54"
replace age=5 if applicant_age=="55-64"
replace age=6 if applicant_age=="65-74"
replace age=7 if applicant_age==">74"
replace age=.n if applicant_age=="8888"

label def age2020l ///
1 "<25" ///
2 "25-34" ///
3 "35-44" ///
4 "45-54" ///
5 "55-64" ///
6 "65-74" ///
7 ">74" ///
.n "8888"
label values age age2020l

*Income
label var income "Gross annual income in thousands"
replace income="" if income=="NA"
destring income, replace

*Debt-to-Income Ratio - this is another categorical variable, so we'll make a numeric replica of it
gen dtiratio=.
label var dtiratio "Ratio of borrower's monthly debt to total monthly income"
replace dtiratio=1 if debt_to_income=="<20%"
replace dtiratio=2 if debt_to_income=="20%-<30%"
replace dtiratio=3 if debt_to_income=="30%-<;36%"
replace dtiratio=4 if debt_to_income=="36"
replace dtiratio=5 if debt_to_income=="37"
replace dtiratio=6 if debt_to_income=="38"
replace dtiratio=7 if debt_to_income=="39"
replace dtiratio=8 if debt_to_income=="40"
replace dtiratio=9 if debt_to_income=="41"
replace dtiratio=10 if debt_to_income=="42"
replace dtiratio=11 if debt_to_income=="43"
replace dtiratio=12 if debt_to_income=="44"
replace dtiratio=13 if debt_to_income=="45"
replace dtiratio=14 if debt_to_income=="46"
replace dtiratio=15 if debt_to_income=="47"
replace dtiratio=16 if debt_to_income=="48"
replace dtiratio=17 if debt_to_income=="49"
replace dtiratio=18 if debt_to_income=="50%-60%"
replace dtiratio=19 if debt_to_income==">60%"
replace dtiratio=.n if debt_to_income=="NA" | debt_to_income=="Exempt"

label def dtiratiol ///
1 "<20%" ///
2 "20%-30%" ///
3 "30%-36%" ///
4 "36" ///
5 "37" ///
6 "38" ///
7 "39" ///
8 "40" ///
9 "41" ///
10 "42" ///
11 "43" ///
12 "44" ///
13 "45" ///
14 "46" ///
15 "47" ///
16 "48" ///
17 "49" ///
18 "50%-60%" ///
19 ">60%" ///
.n "NA or Exempt"
label values dtiratio dtiratiol

*Credit Score Type
rename applicant_credit_score credit_score
label var credit_score "Credit scoring model used to generate the credit score"
replace credit_score=.n if credit_score==1111
label def creditl ///
1 "Equifax Beacon 5.0" ///
2 "Experian Fair Isaac" ///
3 "FICO Risk Score Classic 04" ///
4 "FICO Risk Score Classic 98" ///
5 "VantageScore 2.0" ///
6 "VantageScore 3.0" ///
7 ">1 credit scoring model" ///
8 "Other credit model" ///
9 "Not applicable" ///
.n "Exempt"
label values credit_score creditl

*Initially Payable to Institution
replace initially_payable=.n if initially_payable==1111
label var initially_payable "Whether loan was initially payable to intitution that originated loan"
label def payablel ///
1 "Initially payable to your institution" ///
2 "Not initially payable to your institution" ///
3 "Not applicable" ///
.n "Exempt"
label values initially_payable payablel

*Automated Underwriting System
local aus aus1 aus2 aus3 aus4 aus5 //this creates a macro of these variable
label var aus1 "AUS financial institution used to evaluate the application"
label def ausl ///
1 "Desktop Underwriter" ///
2 "Loan Prospector/Loan Product Advisor" ///
3 "Technology Open to Approved Lenders Scorecard" ///
4 "Guaranteed Underwriting System" ///
5 "Other" ///
6 "Not applicable" ///
.n "Exempt"
*BELOW IS AN EXAMPLE OF LOOPING over the aus macro that we created above
foreach y in `aus' {
replace `y'=.n if `y'==1111
label values `y' ausl
}

*************CENSUS VARIABLES - BY TRACT, 2010 TRACTS******************
label var tract_population "Total population in tract"
label var tract_minority "Percentage of minority population of total population"
rename ffiec_msa_md median_family_income
rename tract_to_msa msa_income_percent
label var msa_income_percent "Percentage of tract median income compared to MSA median income"
rename tract_owner_occupied owner_occupied_units
rename tract_median_age median_housing_age
label var median_housing_age "Tract median age of homes"

*MERGING WITH LENDER NAMES
rename lei lei_2018
merge m:1 lei_2018 using "K:\UROP\Data\arid2017_to_lei_xref_csv.dta", nogen

rename census_tract geo_id //this conforms with the 2011-2017 data
replace geo_id="" if geo_id=="NA"
destring geo_id, replace

save "K:\UROP\Analysis\seattle2022.dta", replace

***************************************************************************************


clear


//this allows you to specify the file directory where you want your work saved
cd "K:\UROP\Analysis"

***********NOW LET'S BRING IN 2023**************
//insheet using is the command to open csv files in stata - comma case names keeps the

insheet using "K:\UROP\Data\seattle2023.csv" , comma case names

*LET'S KEEP THIS CONSISTENT WITH THE 2011-2017 HMDA DATA, WHICH STARTS WITH "LOAN TYPE"

*Loan Type
label def loantypel /// //three back slashes is a line extension
1 "Conventional" ///
2 "FHA" ///
3 "VA" ///
4 "FSA/RHS"
label values loan_type loantypel

*Property Type //Not in the 2018-2020 HMDA

*Loan Purpose - this is different from 2011-2017
label def loanpurposel ///
1 "Home purchase" ///
2 "Home improvement" ///
4 "Other purpose" ///
5 "Not applicable" ///
31 "Refinance" ///
32 "Cash-out refinance"
label values loan_purpose loanpurposel

*Owner occupancy - this is different from 2011-2017
label def occupancytypel ///
1 "Principal residence" ///
2 "Second residence" ///
3 "Investment property"
label values occupancy_type occupancytypel
label var occupancy_type "Occupancy type for the dwelling"

*Preapproval
label var preapproval "Whether the applicant requested preapproval"
label def preapprovall ///
1 "Preapproval Requested" ///
2 "Preapproval Not Requested"
label values preapproval preapprovall

*Action Taken
label def actionl ///
1 "Loan originated" ///
2 "Appl approved but not accptd" ///
3 "Appl denied by fin instn" ///
4 "Appl withdrwn by applcnt" ///
5 "File closed b/c incomplete" ///
6 "Loan purchased by instn" ///
7 "Prappve denied by fin instn" ///
8 "Prappve apprvd by not accptd"
label values action_taken actionl

*Ethnicity - this is different from 2011-2017
label def ethnicity2020l ///
1 "Hispanic" ///
2 "Not Hispanc" ///
3 "Not provided" ///
4 "Not applicable" ///
11 "Mexican" ///
12 "Puerto Rican" ///
13 "Cuban" ///
14 "Other Hispanic/Latino"
label values applicant_ethnicity1 ethnicity2020l

*Race - this is different from 2011-2017
label def race2020l ///
1 "Am. Indian" ///
2 "Asian" ///
3 "Black" ///
4 "Nat. Hawaiian" ///
5 "White" ///
6 "Not provided" ///
7 "Not applicable" ///
21 "Asian Indian" ///
22 "Chinese" ///
23 "Filipino" ///
24 "Japanese" ///
25 "Korean" ///
26 "Vietnamese" ///
27 "Other Asian" ///
41 "Nat. Hawaiian" ///
42 "Guamian/Chamorro" ///
43 "Samoan" ///
44 "Other Pacific Islander"

label values applicant_race1 race2020l

*Gender - this is different from 2011-2017
label def gender2020l ///
1 "Male" ///
2 "Female" ///
3 "Not provided" ///
4 "Not applicable" ///
6 "Chose male &amp; female"
label values applicant_sex gender2020l

*Purchaser Type - this is different from 2011-2017
label var purchaser_type "Entity purchasing covered loan"
label def purchasertype2020l ///
0 "Not applicable" ///
1 "Fannie Mae" ///
2 "Ginnie Mae" ///
3 "Freddie Mac" ///
4 "Farmer Mac" ///
5 "Private securitizer" ///
6 "Commercial bank" ///
8 "Affiliate institution" ///
9 "Other purchaser" ///
71 "Credit union" ///
72 "Life insurance company"
label values purchaser_type purchasertype2020l

*Denial Reason
label def denialreason2020l ///
1 "Debt-to-income ratio" ///
2 "Employment history" ///
3 "Credit history" ///
4 "Collateral" ///
5 "Insufficient cash" ///
6 "Unverifiable info" ///
7 "Credit appl incmplt" ///
8 "Mortg Insr Denied" ///
9 "Other" ///
10 "Not applicable" ///
1111 "Exempt"
label values denial_reason1 denialreason2020l

*HOEPA Status - this is different from 2011-2017

label def hoepa2020l ///
1 "High-cost mortgage" ///
2 "Not high-cost mortgage" ///
3 "Not applicable"
label values hoepa_status hoepa2020l

*Lien Status - this is different from 2011-2017
label def lienstatus2020l ///
1 "Secured by 1st lien" ///
2 "Secured by subordinate lien"
label values lien_status lienstatus2020l

*NOW ON TO NEW VARIABLES NOT INCLUDED IN 2011-2017 DATA

*Business or Commercial Purpose
label var business_or_commercial "Whether loan is for business/commercial purpose"
label def businessl ///
1 "Primarily business" ///
2 "Not primarily business"
label values business_or_commercial businessl

*Loan to Value Ratio
*This needs to be cleaned so it's numeric and not a string
replace loan_to_value="" if loan_to_value=="NA" 
//this is telling stata to change the value of the variable to missing
/*

This command alone did not eliminate all non-numeric characters from the variable.
So, I created a new variable to identify the non-numeric variables in the following way:
gen byte notnumeric=real(loan_to_value)==.

Then, to identify which ones are non-numeric, I did this:
list loan_to_value if notnumeric==1
*/
replace loan_to_value="" if loan_to_value=="Exempt"
destring loan_to_value, replace //this is telling stata to make the variable numeric
label var loan_to_value "Ratio of debt amount secured by property to the property value relied on for credit decision"

*Interest Rate
replace interest_rate="" if interest_rate=="NA" | interest_rate=="Exempt" //the | is an "or" statement
destring interest_rate, replace

*Total Loan Costs
replace total_loan_costs="" if total_loan_costs=="NA" | total_loan_costs=="Exempt"
destring total_loan_costs, replace

*Origination Charges
replace origination_charges="" if origination_charges=="NA" | origination_charges=="Exempt"
destring origination_charges, replace

*Discount Points
replace discount_points="" if discount_points=="NA" | discount_points=="Exempt"

destring discount_points, replace

*Lender Credits
replace lender_credits="" if lender_credits=="NA" | lender_credits=="Exempt"
destring lender_credits, replace

*Loan Term
replace loan_term="" if loan_term=="NA" | loan_term=="Exempt"
destring loan_term, replace

*Intro Rate Period
replace intro_rate_period="" if intro_rate_period=="NA" | intro_rate_period=="Exempt"
destring intro_rate_period, replace

*Property Value
replace property_value="" if property_value=="NA" | property_value=="Exempt"
destring property_value, replace

*Age - this is different from 2011-2017--it's a categorical variable in the new data
gen age=. //we're just going to create a numeric variable based off the string variable
replace age=1 if applicant_age=="<25"
replace age=2 if applicant_age=="25-34"
replace age=3 if applicant_age=="35-44"
replace age=4 if applicant_age=="45-54"
replace age=5 if applicant_age=="55-64"
replace age=6 if applicant_age=="65-74"
replace age=7 if applicant_age==">74"
replace age=.n if applicant_age=="8888"

label def age2020l ///
1 "<25" ///
2 "25-34" ///
3 "35-44" ///
4 "45-54" ///
5 "55-64" ///
6 "65-74" ///
7 ">74" ///
.n "8888"
label values age age2020l

*Income
label var income "Gross annual income in thousands"
replace income="" if income=="NA"
destring income, replace

*Debt-to-Income Ratio - this is another categorical variable, so we'll make a numeric replica of it
gen dtiratio=.
label var dtiratio "Ratio of borrower's monthly debt to total monthly income"
replace dtiratio=1 if debt_to_income=="<20%"
replace dtiratio=2 if debt_to_income=="20%-<30%"
replace dtiratio=3 if debt_to_income=="30%-<;36%"
replace dtiratio=4 if debt_to_income=="36"
replace dtiratio=5 if debt_to_income=="37"
replace dtiratio=6 if debt_to_income=="38"
replace dtiratio=7 if debt_to_income=="39"
replace dtiratio=8 if debt_to_income=="40"
replace dtiratio=9 if debt_to_income=="41"
replace dtiratio=10 if debt_to_income=="42"
replace dtiratio=11 if debt_to_income=="43"
replace dtiratio=12 if debt_to_income=="44"
replace dtiratio=13 if debt_to_income=="45"
replace dtiratio=14 if debt_to_income=="46"
replace dtiratio=15 if debt_to_income=="47"
replace dtiratio=16 if debt_to_income=="48"
replace dtiratio=17 if debt_to_income=="49"
replace dtiratio=18 if debt_to_income=="50%-60%"
replace dtiratio=19 if debt_to_income==">60%"
replace dtiratio=.n if debt_to_income=="NA" | debt_to_income=="Exempt"

label def dtiratiol ///
1 "<20%" ///
2 "20%-30%" ///
3 "30%-36%" ///
4 "36" ///
5 "37" ///
6 "38" ///
7 "39" ///
8 "40" ///
9 "41" ///
10 "42" ///
11 "43" ///
12 "44" ///
13 "45" ///
14 "46" ///
15 "47" ///
16 "48" ///
17 "49" ///
18 "50%-60%" ///
19 ">60%" ///
.n "NA or Exempt"
label values dtiratio dtiratiol

*Credit Score Type
rename applicant_credit_score credit_score
label var credit_score "Credit scoring model used to generate the credit score"
replace credit_score=.n if credit_score==1111
label def creditl ///
1 "Equifax Beacon 5.0" ///
2 "Experian Fair Isaac" ///
3 "FICO Risk Score Classic 04" ///
4 "FICO Risk Score Classic 98" ///
5 "VantageScore 2.0" ///
6 "VantageScore 3.0" ///
7 ">1 credit scoring model" ///
8 "Other credit model" ///
9 "Not applicable" ///
.n "Exempt"
label values credit_score creditl

*Initially Payable to Institution
replace initially_payable=.n if initially_payable==1111
label var initially_payable "Whether loan was initially payable to intitution that originated loan"
label def payablel ///
1 "Initially payable to your institution" ///
2 "Not initially payable to your institution" ///
3 "Not applicable" ///
.n "Exempt"
label values initially_payable payablel

*Automated Underwriting System
local aus aus1 aus2 aus3 aus4 aus5 //this creates a macro of these variable
label var aus1 "AUS financial institution used to evaluate the application"
label def ausl ///
1 "Desktop Underwriter" ///
2 "Loan Prospector/Loan Product Advisor" ///
3 "Technology Open to Approved Lenders Scorecard" ///
4 "Guaranteed Underwriting System" ///
5 "Other" ///
6 "Not applicable" ///
.n "Exempt"
*BELOW IS AN EXAMPLE OF LOOPING over the aus macro that we created above
foreach y in `aus' {
replace `y'=.n if `y'==1111
label values `y' ausl
}

*************CENSUS VARIABLES - BY TRACT, 2010 TRACTS******************
label var tract_population "Total population in tract"
label var tract_minority "Percentage of minority population of total population"
rename ffiec_msa_md median_family_income
rename tract_to_msa msa_income_percent
label var msa_income_percent "Percentage of tract median income compared to MSA median income"
rename tract_owner_occupied owner_occupied_units
rename tract_median_age median_housing_age
label var median_housing_age "Tract median age of homes"

*MERGING WITH LENDER NAMES
rename lei lei_2018
merge m:1 lei_2018 using "K:\UROP\Data\arid2017_to_lei_xref_csv.dta", nogen

rename census_tract geo_id //this conforms with the 2011-2017 data
replace geo_id="" if geo_id=="NA"
destring geo_id, replace

save "K:\UROP\Analysis\seattle2023.dta", replace

**************************************************************************************
use seattle2019.dta, clear
append using seattle2020.dta, force
append using seattle2021.dta, force
append using seattle2022.dta, force
append using seattle2023.dta, force

save seattle_hmda.dta, replace