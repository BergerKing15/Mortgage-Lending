*PANDEMIC IMPACTS ON MORTGAGE LENDING TO MINORITY-OWNED BUSINESSES

clear
capture log close
set more off
pause on

cd "K:\UROP\Analysis\"

use minneapolis_hmda.dta
/*
LET'S THINK ABOUT HOW TO IDENTIFY MINORITY-OWNED BUSINESSES IN THE HMDA DATA


Creat an identifier for minority-owned business
1. Start with business_or_commercial_purpose
*/
gen business=1 if business_or_commercial_purpose==1 & occupancy_type==3
replace business=0 if business==.
gen small_business=1 if business==1 & income<500000 //1 is primarily business
replace small_business=0 if small_business!=1

//2. How to think about whether it's minority-owned
//follow same procedures for identifying non-white borrowers

gen nonwhite=1 if applicant_race1!=5 & ///
applicant_race1!=6 & ///
applicant_race1!=7
replace nonwhite=1 if applicant_ethnicity1==1 &nonwhite==.
replace nonwhite=0 if nonwhite==.


//3. Create minority business identifier
gen minority_small_business=1 if small_business==1 & nonwhite==1
replace minority_small_business=0 if small_business==1 & nonwhite==0
gen minority_small_given_business=1 if minority_small_business==1
replace minority_small_given_business=0 if business==1 & minority_small_business==0

//also adding majority_minority tract identifier	and business type
gen majority_minority=tract_minority>50
gen business_type=0 if business==0
replace business_type=1 if business==1 & small_business==0
replace business_type=2 if small_business==1 & minority_small_business==0
replace business_type=3 if minority_small_business==1
label define businesstypel ///
0 "not a business" ///
1 "large business" ///
2 "majority small business" ///
3 "minority small business"
label values business_type businesstypel
//9. create a denial variable
gen denied=1 if action_taken==3
replace denied=0 if action_taken<3 //this means that it was denied on the merits






//did 5 earlier


//6. Create a pandemic identifier
gen pandemic=.
replace pandemic=1 if activity_year==2019
replace pandemic=2 if activity_year==2020
replace pandemic=3 if activity_year>2020

label def pandemic ///
1 "Pre-pandemic" ///
2 "Pandemic" ///
3 "Post-pandemic"

//7. look at destribution by pandemic variable
log using minneapolis_msb.log, replace
tab activity_year business, row
tab activity_year small_business, row
tab activity_year minority_small_business, row
tab activity_year business_type, row
tab denied business_type
tab business_type pandemic
ttest income if pandemic==1, by(minority_small_business)
ttest income if pandemic==2, by(minority_small_business)
ttest income if pandemic==3, by(minority_small_business)
tab debt_to_income_ratio business_type
ttest loan_to_value_ratio if pandemic==1, by(minority_small_business)
ttest loan_to_value_ratio if pandemic==2, by(minority_small_business)
ttest loan_to_value_ratio if pandemic==3, by(minority_small_business)
log close

log using minneapolis_msb2.log, replace
oneway income business_type, tab
oneway income business_type if pandemic==1, tab
oneway income business_type if pandemic==2, tab
oneway income business_type if pandemic==3, tab
oneway loan_to_value_ratio business_type, tab
oneway loan_to_value_ratio business_type if pandemic==1, tab
oneway loan_to_value_ratio business_type if pandemic==2, tab
oneway loan_to_value_ratio business_type if pandemic==3, tab
oneway interest_rate business_type, tab
oneway interest_rate business_type if pandemic==1, tab
oneway interest_rate business_type if pandemic==2, tab
oneway interest_rate business_type if pandemic==3, tab
ttest income, by(minority_small_given_business)
ttest income if pandemic==1, by(minority_small_given_business)
ttest income if pandemic==2, by(minority_small_given_business)
ttest income if pandemic==3, by(minority_small_given_business)
ttest loan_to_value_ratio, by(minority_small_given_business)
ttest loan_to_value_ratio if pandemic==1, by(minority_small_given_business)
ttest loan_to_value_ratio if pandemic==2, by(minority_small_given_business)
ttest loan_to_value_ratio if pandemic==3, by(minority_small_given_business)
ttest interest_rate, by(minority_small_given_business)
ttest interest_rate if pandemic==1, by(minority_small_given_business)
ttest interest_rate if pandemic==2, by(minority_small_given_business)
ttest interest_rate if pandemic==3, by(minority_small_given_business)
log close

/*8. look at borrower characteristics by minority_small_business
income
debt_to_income ratio
loan_to_value

9. create a denial variable
gen denied=1 if action_taken==3
replace denied=0 if action_taken<3 //this means that it was denied on the merits


10. delineate between small and big businesses by income
replace small_business=1 if income<500000
replace small_business=0 if income>=500000*/




