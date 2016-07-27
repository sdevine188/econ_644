* 1)
* 1.1)
* Stephen Devine
* ECON 644 Midterm Exam

clear
set more off

* 1.2) 
* set working directory
global data "C:\Users\Stephen\Desktop\stata\econ_644\midterm"
global output "C:\Users\Stephen\Desktop\stata\econ_644\midterm"
log using "$output\midterm_output.log", replace

* 1.3) 
* open dataset and review variables
use "$data\WAGE1.dta", clear
summarize

* 2)
* wage = B0 + B1(educ) + B2(exper) + B3(tenure) + B4(female) + B5(married)
* I expect the coefficients to have the following signs:
* B1 = positive
* B2 = positive
* B3 = positive
* B4 = negative
* B5 = positive

* summary statistics for each variable
tabstat wage educ exper tenure female married, stat(n mean median sd min max)

* wage mean by gender and marital status
tabstat wage if female == 1, stat(n mean)
tabstat wage if female == 0, stat(n mean)

tabstat wage if married == 1, stat(n mean)
tabstat wage if married == 0, stat(n mean)

tabstat wage if female == 1 & married == 1, stat(n mean)
tabstat wage if female == 1 & married == 0, stat(n mean)

tabstat wage if female == 0 & married == 1, stat(n mean)
tabstat wage if female == 0 & married == 0, stat(n mean)

* the mean wages are higher for males
* the mean wages are higher for married people
* the mean wages are very slightly higher for unmarried females relative to married females
* the mean wages are higher for married men

* 3) 
* scatterplots of wage and exper for married and non-married
scatter wage exper if married == 1
scatter wage exper if married == 0

* in the married plot there are higher wages observed
* also, in the married plot, there are more observations with high experience
* also, in the married plot, there is a trend arc of higher earnings as exper increased, then after about 30 years exper wages decrease as exper increases
* in the unmarried plot, those with high exper tend to earn lower wages

* 4) 
* difference in education between males and females
tabstat educ if female == 1, stat(n mean sd median min max)
tabstat educ if female == 0, stat(n mean sd median min max)

* the average grade level of education for females is approximately .47 grade levels lower than for men
ttest(educ), by(female)
* the p-value for the ttest on the null hypothesis of no difference is .0513
* this means we fail to reject the null at the 5% significance level
* so there is no statistically significant difference

* 5) 
* probabilty of drawing above average tenure conditional on female

* calculate avg tenure
tabstat tenure, stat(n mean)
* 5.10

* count of females with above average tenure
count if tenure > 5.1 & female == 1
* 51

* count of all females
count if female == 1
* 252

* probability of drawing above average tenure conditional on female
disp 51 / 252
* probability is 20.2%

* 6) 
* 95% CI for average educ by gender and marital status
ci(educ)

ci(educ) if female == 1
ci(educ) if female == 0

ci(educ) if married == 1
ci(educ) if married == 0

ci(educ) if female == 1 & married == 1
ci(educ) if female == 1 & married == 0

ci(educ) if female == 0 & married == 1
ci(educ) if female == 0 & married == 0

* I wasn't sure which version of the CI was being asked for
* so I calculated it for female and married seperately, and also jointly
* for the interpretation, I'll refer to the calculations done seperately

* The 95% CI for educ for females is 12.0 to 12.6
* The 95% CI for educ for males is 12.4 to 13.1

* The 95% CI for educ for married is 12.4 to 13.0
* The 95% CI for educ for unmarried is 11.9 to 12.7

* The average education grade level is within the 95% CI range in 95% of samples

* 7)
* Yes, I expect the assumption that all independent variables are uncorrelated with the error term will be violated
* This is because the model omits variables likely significant, like ability, which are therefore captured in the error term
* Since ability is likely correlated with educ, educ will likely be correlated with the error term

* I also expect the assumption of constant variance of the error term to be violated
* This heteroskedasticity is likely present because the residual for high levels of educ or exper or tenure will likely be much larger than for small levels

* 8)
reg wage educ exper tenure female married

* Interpret the coefficients:
* on average, a one grade level increase in educ is associated with an increase in wages by $0.55, holding other variables constant; this is significant
* on average, a one year increase in exper is associated with an increase in wages by $0.02, holding other variables constant; this is not significant
* on average, a one year increase in tenure is associated with an increase in wages by $0.14, holding other variables constant; this is significant
* on average, females wages are $1.74 less than males, holding other variables constant; this is significant
* on average, married peoples' wages are $0.56 more than unmarried peoples', holding other variables constant; this is not significant at the 5% significance level

* The F-test of the null hypothesis that all explantory variable coefficients being jointly equal to 0 is 60.61
* This high value rejects the null, so the model is overall statistically significant

* There are not really any irrelevant variables; all the explantory variables are theoretically relevant
* Also, of the two variables not statistically significant, married is very close to technical significance
* Also, exper is somewhat close to being significant, and there could be many reasons why the coefficient in this model does not appear significant, including omitted variable bias

* 9)
* Yes, experience may exhibit diminishing returns as people get into old age and earn less
reg wage educ exper tenure female married expersq

* wage = -2.118117 + .5282458(educ) + .2004023(exper) + .1334383(tenure) + -1.779127(female) + .0924594(married) + -.0040498(expersq)

* get average values for explanatory variables
tabstat educ
tabstat tenure
tabstat female
tabstat married

* calculate wage-maximizing value of experience at the mean for the other variables
* wage = -2.118117 + .5282458(12.56274) + .2004023(30) + .1334383(5.104563) + -1.779127(.4790875) + .0924594(.608365) + -.0040498(900)

* the wage-maximizing experience is 25 years
disp -2.118117 + .5282458 * 12.56274 + .2004023 * 24 + .1334383 * 5.104563 + -1.779127 * .4790875 + .0924594 * .608365 + -.0040498 * 576
disp -2.118117 + .5282458 * 12.56274 + .2004023 * 25 + .1334383 * 5.104563 + -1.779127 * .4790875 + .0924594 * .608365 + -.0040498 * 625
disp -2.118117 + .5282458 * 12.56274 + .2004023 * 26 + .1334383 * 5.104563 + -1.779127 * .4790875 + .0924594 * .608365 + -.0040498 * 676

* 10) 
* I expect tenure to be biased downward, since tenure and educ are likely to be negatively correlated, and educ and wage are positively correlated
* This is likely because an individual with more education has likely stayed out of the workforce for longer, and so accrued less tenure
* Also, individuals with higher education are more likely to be more marketable and sought after by employers, so they can change jobs for promotions more frequently, reducing their tenure

* check the correlation of educ and tenure, which is confirmed to be negative
reg educ tenure
corr educ tenure

* check the correlation of wage and educ
reg wage educ
corr wage educ

* the coefficient on tenure is actually higher than in the previous regression including educ
* not sure why??
reg wage exper tenure female married expersq

* calculate bias
* auxiliary regression
reg educ exper tenure female married expersq

ereturn list
matrix delta_aux = e(b)
scalar delta_tenure_aux = delta_aux[1, 2]

* unrestricted regression
reg wage educ exper tenure female married expersq

matrix betas_u = e(b)
scalar beta_educ_hat = betas_u[1, 1]
scalar beta_tenure_hat = betas_u[1, 3]

* restricted regression
reg wage exper tenure female married expersq

matrix betas_r = e(b)
scalar beta_tenure_tilda = betas_r[1, 2]

* note these are the same values
disp beta_tenure_hat + delta_tenure_aux * beta_educ_hat
disp beta_tenure_tilda

* bias is:
disp delta_tenure_aux * beta_educ_hat

* 11) 
* h0: B_educ = B_tenure
* ha: B_educ != B_tenure
generate educ_plus_tenure = educ + tenure
reg wage educ exper female married expersq educ_plus_tenure

* the coefficient on educ = B_educ - B_tenure
* since it is significant, we reject the null of no difference

* 12) 
* h0: gender and married coefficients jointly = 0
* ha: gender and married coefficients jointly != 0

* restricted regression
reg wage educ exper tenure expersq
scalar ssr_r = e(rss)

* unrestricted regression
reg wage educ exper tenure female married expersq
scalar ssr_ur = e(rss)
scalar df = e(df_r)

* f-stat
scalar f_stat = ((ssr_r - ssr_ur) / 2) / (ssr_ur / df)
disp f_stat

* f-critical value
scalar f_critical = invFtail(2, df, .05)
disp f_critical

* the f_stat is 24.1 and the f-critical value is 3.01
* so we reject the null hypothesis that the coefficents jointly = 0
* in favor of the alternative hypothesis that married and female are jointly significant

* 13) 
generate educ_female = educ * female
reg wage educ exper tenure female married expersq educ_female

* the coefficient on female rose from -1.77 to -.28 when educ_female was included
* this indicates that the decreased wages for women relative to men found in the earlier regression, other variables held constant, is lessened when educ_female is included
* also, the coefficient on female in the model with educ_female is no longer significant
* the coefficient on educ_female is also insignificant

* 14) 
* h0: B_educ_female = 0
* ha: B_educ_female != 0
reg wage educ exper tenure female married expersq educ_female

* the coefficient on educ_female is not significant, so we fail to reject the null of no difference

log close



