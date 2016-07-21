clear
set more off

**************************************
* Q1: Setup the environment
**************************************
global data "C:\Users\Stephen\Desktop\stata\econ_644\ps3"
global output "C:\Users\Stephen\Desktop\stata\econ_644\ps3"

log using "$output\Midterm  output.log", replace

**************************************
* Open data
**************************************
use "$data\WAGE2.dta", clear

count

**************************************
* Q2 
**************************************
count if urban==1

scalar sc_urban = r(N)
display sc_urban
* This is going to be the denominator

count if married==1 & urban==1
scalar sc_marr_urban = r(N)
display sc_marr_urban
* This is the numerator

display sc_marr_urban/sc_urban

**************************************
* Q3
**************************************
ttest wage = 1000, level(99)

* We reject the null hypothesis that average monthly earnings is $1,000.
* The t-statistic is -3.18 which is less than -2 and in the rejection region.
* The 99% CI is  [923.8, 992.1] which excludes the value 1,000.
* p-value for the test is 0.0008 which is less than alpha (1%).
* We conclude that average monthly earnings is less than $1,000.

**************************************
* Q4
**************************************
ci wage, level(95)

* The 95% CI is [932.9, 983.9].
* The population average of monthly earnings is between these two values with 95% probability.

**************************************
* Q5
**************************************
ttest wage, by(urban) level(99)

/*
The results show that the mean for non-urban individuals (830.1098) is significantly
smaller than the mean for urban individuals (1008.241). The t-statistic is very large (-6.18)
(and p-value is 0) and hence in the rejection region. We conclude that average monthly in 
urban areas are significantly higher than average monthly earnings in non-urban areas.
*/

**************************************
* Q6
**************************************
gen hourly_rate = wage/(4*hours)

* You could also do this in 2 steps.

**************************************
* Q7
**************************************
gen lhourly_rate = log(hourly_rate)

**************************************
* Q8
**************************************
tab  educ, sort
* Most common is 12 years of education (high-school graduate) with 393 observations.
* The second most common is college-graduate with 150 obsrvations.

**************************************
* Q9
**************************************
reg lhourly_rate educ

**************************************
* Q10
**************************************
/*
The t-stats are very large for both the constant and the slope for educ.
Hence, both coefficients are statistically significant (or non-zero). 
*/

**************************************
* Q11
**************************************
/*
The slope estimate is .053 (rounded). So, each year of education increases
the average hourly earnings by about 5 percent.
*/

**************************************
* Q12
**************************************
scalar r_sq = e(r2) 
display r_sq

/* 
The model (with education only) explains about 6% of the variation in 
log hourly earnings. It means that education explains a small portion of the
movements/variation in earnings and the model is missing many other factors that
cause earnings to vary/change.
*/

**************************************
* Q13
**************************************
reg lhourly_rate educ urban

**************************************
* Q14
**************************************
* Yes, it is statistically significant.
* The 95% CI is [.1073937, .2309193] which excludes the value 0.

**************************************
* Q15
**************************************
ereturn list
scalar fstat1 = e(F)

/*
This F-statistic tests the joint null hypothesis that coefficients for
both educ and urban are 0. Given that it is very large, without having to 
find out the critical value, we conclude that we reject this null hypothesis.
Hence, educ and urban jointly belong to this regression model.
*/

**************************************
* Q16
**************************************
test urban=0

return list
scalar fstat = r(F)

scalar crit = invFtail(1,932,0.01)
di crit

* F-statistic is greater than the critical value so we reject the null
* that the coefficient for urban is insignificant.

di sqrt(fstat)
* or you can use: di fstat^0.5

* We show above that square root of the F-statistics is approximately
* equal to the t-statistic for urban in the regression output.


**************************************
* Q18
**************************************
* Regress urban (omitted variable) on other explanatory variables
reg urban educ

matrix dd =e(b)
matrix list dd
scalar delta_hat = dd[1,1]

* Regress the original model (without the omission) 
regress lhourly_rate educ urban

matrix b1=e(b)
matrix list b1
scalar beta1_hat=b1[1,1]
scalar beta2_hat=b1[1,2]

* Regress the model with the omission
regress lhourly_rate educ

matrix b2=e(b)
matrix list b2
scalar beta1_tilda=b2[1,1]

display beta1_hat + beta2_hat*delta_hat
display beta1_tilda

* Note that these 2 displayed values are equal.

* The bias is given by:
di beta2_hat*delta_hat

**************************************

log close

*EOF
