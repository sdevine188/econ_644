* read in data
cd "C:\Users\Stephen\Desktop\stata\econ_644\ps3"
ls
clear
use bwght2.dta

* explore data
summarize

* 2) i)
reg lbwght npvis npvissq

* 4) i)
clear
use nbasal.dta

* explore data
summarize
count
count if center == 1
count if guard == 1 
count if forward == 1
* center, guard, and forward total to 269 = n

* estimate regression, with center as base category
reg points exper guard forward expersq

* iv) now add marital status
reg points exper guard forward expersq marr

* v) now add interaction of marital status
generate marr_exper = marr * exper
reg points exper guard forward expersq marr marr_exper

* vi) now use assists per game as dependent variable
reg assists exper guard forward expersq marr

* 5) i) 
clear 
use beauty.dta

* explore data
summarize
count
tabstat abvavg if female == 1, stat(mean min max sd count)
tabstat abvavg if female == 0, stat(mean min max sd count)
count if abvavg
count if belavg

* ii) 
reg abvavg female

* iii)
reg lwage belavg abvavg if female == 1
reg lwage belavg abvavg if female == 0

* v) 
reg lwage belavg abvavg educ exper expersq union goodhlth black married south bigcity smllcity service if female == 1
reg lwage belavg abvavg educ exper expersq union goodhlth black married south bigcity smllcity service if female == 0

* iv)
* conduct chow F-test for differences between male and female regressions
reg lwage belavg abvavg educ exper expersq union goodhlth black married south bigcity smllcity service
 disp ((293.587437 - (83.6932759 + 166.084144)) / 14) / ((83.6932759 + 166.084144) / (824 + 436 - 2*14))
 
 