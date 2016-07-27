* load data
cd "C:\Users\Stephen\Desktop\stata\econ_644\ps2"
ls
use WAGE2.DTA

* explore data
summarize

* 3)
reg lwage educ exper tenure

test (exper = tenure)

 * from p142 in wooldridge
generate exper_plus_tenure = exper + tenure
reg lwage educ exper exper_plus_tenure

* 4) 

* load data
clear
use discrim.dta

summarize

* estimate model
reg lpsoda prpblck lincome prppov

corr lincome prppov

reg lpsoda prpblck lincome prppov lhseval

reg lpsoda prpblck lhseval




* 5) 
* load data
clear
use WAGE2.DTA

summarize

* first model
generate exper2 = exper^2
reg lwage educ exper exper2 
