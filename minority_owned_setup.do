*PANDEMIC IMPACTS ON MORTGAGE LENDING TO MINORITY-OWNED BUSINESSES


/*
LET'S THINK ABOUT HOW TO IDENTIFY MINORITY-OWNED BUSINESSES IN THE HMDA DATA


Creat an identifier for minority-owned business
1. Start with business_or_commercial_purpose

gen small_business=1 if business==1 //1 is primarily business
replace small_business=0 if business!=1

2. How to think about whether it's minority-owned
follow same procedures for identifying non-white borrowers

gen nonwhite=1 if applicant_race1!=5 & ///
applicant_race1!=6 & ///
applicant_race1!=7 //may want to leave this out for the moment because it's "not applicable"
replace nonwhite=1 if applicant_ethnicity1==1 & nonwhite==. //hispanic identifiers not already accounted for


3. Create minority business identifier
gen minority_owned_business=1 if small_business==1 & racial_minority==1
replace minority_owned_business=0 if small_business=1 & racial_minority==0


4. See what the distribution looks like, how many observations are there for this variable?


5. Since a business is not going to have an owner-occupied home, want to filter out those mortgages
you would filter on only mortgages for investment properties
keep if occupancy_type==3 //this refers to investment properties


6. Create a pandemic identifier
gen pandemic=.
replace pandemic=1 if activity_year==2019
replace pandemic=2 if activity_year==2020
replace pandemic=3 if activity_year>2020

label def pandemicl ///
1 "Pre-pandemic" ///
2 "Pandemic" ///
3 "Post-pandemic"

7. look at destribution by pandemic variable
tab minority_owned pandemic


8. look at borrower characteristics by minority_owned_business
income
debt_to_income ratio
loan_to_value

9. create a denial variable
gen denied=1 if action_taken==3
replace denied=0 if action_taken<3 //this means that it was denied on the merits


10. delineate between small and big businesses by income
replace small_business=1 if income<500000
replace small_business=0 if income>=500000

*/




