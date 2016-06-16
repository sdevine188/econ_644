* Q1

* cd and load data
cd "C:\Users\Stephen\Desktop\stata\econ_644\ps1"
ls
pwd
use BWGHT.DTA

* look at data
summarize
describe

* i
* create dummy for smoking
generate smoke = .
replace smoke = 1 if cigs > 0
replace smoke = 0 if cigs == 0
tabstat smoke if smoke == 1, statistics(count)

* average cig smoked each day
tabstat cigs

* avg cig smoked per day, given smoker
tabstat cigs if smoke == 1, stat(mean max min count median)

* avg fathers education
mean(fatheduc)
tabstat fatheduc, stat(count)
count if missing(fatheduc)

* avg family income and sd
tabstat faminc, stat(mean sd)


********

* q2

* read in data
clear
pwd
ls
use meap01.dta
set more off

* explore data
summarize
describe

* find largest and smallest values of math4
tabstat math4, stat(min max)
count if missing(math4)
histogram math4

* what % of schools have perfect pass rate on math10
count if math4 == 100
tabulate math4 if math4 == 100
scalar perfect_math = 38
scalar n = 1823
disp perfect_math / n

* how many schools w math pass rate of exactly 50%
count if math4 == 50
tabulate math4 if math4 == 50

* which test is harder to pass
tabstat math4
tabstat read4

* correlation btw math and reading tests
corr math4 read4

* mean and sd of exppp
tabstat exppp, stat(mean sd min max)
histogram exppp

* school a to b percentage
disp 500 / 5500
disp ln(6000) - ln(5500)


****************************

* q3

* create dataset with 1000 obs
clear
set obs 1000
generate rndm = runiform()
summarize
histogram rndm


***************************

* q4

* read in ceo salary
clear
pwd
ls
use CEOSAL2.DTA

* explore data
summarize

* average salary and tenure
tabstat salary
tabstat ceoten

* ceos with 0 years tenure, longest tenure
count if ceoten == 0
tabstat ceoten if ceoten == 0, stat(count mean)
summarize ceoten

* estimate model 1
reg lsalary ceoten


********************************

* q5

* read in data
clear
use MEAP93.DTA

* explore data
summarize

* estimate model
reg math10 lexpend

* explore math10
summarize math10
tabstat math10, stat(mean count min max median)


********************************

* q7

* read in data
clear
use WAGE2.DTA

* explore data
summarize

* model 1
reg IQ educ

* model 2
reg lwage educ

* model 3
reg lwage educ IQ


**********************************

* q8

* read in data
clear 
use discrim.dta

* explore data
summarize

* mean for prpblck and income
tabstat prpblck, stat(mean sd count min max)
tabstat income, stat(mean sd count min max)

* convert prpblck to percent from decimal
generate prpblckp = prpblck * 100

* model 1
reg psoda prpblckp income

* model 2
reg psoda prpblckp

* model 3
generate lpsoda = log(psoda)
reg lpsoda prpblckp lincome

* model 4
reg lpsoda prpblckp lincome prppov

* corr of lincome and prppov
corr lincome prppov
