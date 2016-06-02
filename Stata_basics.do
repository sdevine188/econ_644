

**************************************************
** Basic commands: opening & entering data
**************************************************
/*
cd			Change directory
dir			Show files in current directory
pwd			Print working directory
insheet		Read ASCII (text) data created by a spreadsheet
infile		Read unformatted ASCII (text) data
infix		Read ASCII (text) data in fixed format
input		Enter data from keyboard
import 		excel	Import Excel .xls or .xlsx file
describe	Describe contents of data in memory or on disk
compress	Compress data in memory
save		Store the dataset currently in memory on disk in Stata data format
use			Load a Stata-format dataset
count		Show the number of observations
list		List values of variables
clear		Clear the entire dataset and everything else
memory		Display a report on memory usage
set memory	Set the size of memory
*/

* CHANGE TO THE LOCATION ON YOUR COMPUTER!!

/*if using Windows: cd " C:\Users\maksimbelenkiy\Documents\Teaching Files"
  if using Mac cd "/Users/maksimbelenkiy/Documents/Teaching/UMaryland/ECN644/Lecture 1/Data"*/
cd "your dir"
dir
pwd
set more off

/*you can always change your working directory by File -> change working directory */

**************************************************
* Opening different types of files
**************************************************

/*It is crucial to know the contents of your data before you import it into Stata
 kinds of variables - string or number
 delimeter types - space, comma, semi-column
*/

* Opening Comma Separated files 
insheet using hs0.csv, clear
describe

* Opening Comma Separated files without variable names 
insheet gender id race ses schtyp prgtype read write math science socst using hs0_noname.csv, clear
count

*Stata usually can distinguish delimeters automatically. But if it fails you can specify the delimeter explicitly if you know it:
insheet gender id race ses schtyp prgtype read write math science socst using hs0_noname.csv, clear delimiter (",") 

* Opening a space-delimited file
infile gender id race ses schtyp str10 prgtype read write math science socst using hs0.raw, clear

/*infile command does not read files with variable names in the first row - we can use insheet command instead 

*Opening fixed column files*/
 type dentists7.txt
 
 infix str name 1-17 years 18-22 fulltime 23 recom 24 using dentists7.txt, clear

 /*note that we must have some prior knowledge of the data structure called data dictionary*/
  type dentists1.dct
  infix using dentists1.dct, using (dentists7.txt) clear
  
  /*infix vs infile*/
  
  /*infix - specifies beginning and end of columns; infile allows variable types*/
  
  type dentists3.dct
 infile using dentists3.dct, clear
 
 /*we can enter data manually - click Data Editor and start entering data - use properties dialog to change variable properties*/


* Opening an Excel file (Stata 12)
import excel using hs0.xlsx, sheet("Sheet1") firstrow clear



* Opening a Stata file
use hs0, clear

/*we can always use menu driven UI to import data: File -> Import"*/


/*Opening data file on the web:*/

use http://www.ats.ucla.edu/stat/stata/dae/poisson_sim, clear

/*Stata often provides their own data sets for documenation examples*/

sysuse auto, clear

/*if we try to read dataset when the other one is loaded and changed we will get error:*/
 gen dummy = 1
use http://www.ats.ucla.edu/stat/stata/dae/poisson_sim
*no; data in memory would be lost
* Save as Stata file*/
save hs0, replace

*Export to Excel:

export excel using "your dir", sheet("name") firstrow(variables)

*if your file is too large - you will get "no room to add more observations" check the size of the file with dir command
*set mem ... - to set the size of the file*/





**************************************************
** Exploring data
**************************************************
/*
browse		Browse the data
describe	Describe a dataset
list		List the contents of a dataset
codebook	Detailed contents of a dataset
log			Create a log file
lookfor		Find variables in large dataset
summarize	Descriptive statistics
tabstat		Table of descriptive statistics
table		Create a table of statistics
stem		Stem-and-leaf plot
graph		High resolution graphs
kdensity	Kernel density plot
sort		Sort observations in a dataset
histogram	Histogram for continuous and categorical variables
tabulate	One- and two-way frequency tables
correlate	Correlations
pwcorr		Pairwise correlations
*/

import excel using hs0.xlsx, sheet("Sheet1") firstrow clear



* Start a log file to save work
log using "your dir\Stata basics.txt", replace

browse

* Describe the variables in the data
describe

* Detail for variables 
codebook race gender math write

* List first 20 observations for select variables
list gender-read in 1/20

* Summarize variables
summarize read math science write

* Summarize variables with detail
summarize read math science write, detail

* Tabulate values of a variable
tabulate prgtype, missing

tabulate race gender, missing

* Use of IF statements
summarize write if gender==0

summarize write if prgtype=="general"

* IF statement with "AND" (&)
summarize math if gender==1 & prgtype=="general"

* IF statement with "OR" (&)
summarize math if gender==1 & (prgtype=="general" | prgtype=="academic")  

* Use of "Not Equal"
summarize math if gender==1 & prgtype!="general" /* "!=" or "~=" */

* Sort data
sort gender race

* Tabstat
tabstat read write math, by(prgtype) stat(n mean sd)
tabstat write, by(prgtype) stat(n mean sd p25 p50 p75)

* Table
table prgtype, c(mean math mean read mean write) row col 

table prgtype, c(min math mean math max math) row col 

* Correlations
correlate write read science

* Histogram, Graph, Scatter
hist write, normal
hist write, bin(20) frequency

graph box write
graph box write, over(prgtype)

scatter write read
graph matrix read science write, half 

**************************************************
** Modifying data
**************************************************
/*
order	 		Order the variables in a data set
label data		Apply a label to a data set
label variable	Apply a label to a variable
label define	Define value labels for a categorical variable
label values	Apply value labels to a variable 
encode			Create numeric version of a string variable
list			Lists the observations
rename			Rename a variable
recode			Recode the values of a variable
notes			Apply notes to the data file
generate		Creates a new variable
replace			Replaces values for an existing variable
egen			Extended generate - has special functions that can be used when creating a new variable 
*/

* Change the order of variables
order race gender

* Label a variable
label variable schtyp "type of school"
label define scl 1 public 2 private
label values schtyp scl
codebook schtyp

list schtyp in 1/10, nolabel
list schtyp in 1/10

* Encode: create a new numeric version of the string variable 
encode prgtype, gen(prgtype2)
label variable prgtype2 "type of program"
codebook prgtype2
list prgtype2 in 1/10, nolabel
list prgtype2 in 1/10

* Recode: Change the values of numeric variables (still numeric)
gen female = gender 
recode female (0=1)(1=0)
label define fm 1 female 0 male
label values female fm
codebook female
list female in 1/10, nolabel
list female in 1/10

* Generate a new variable
generate total_score = read + write + math + science

summarize total_score
count if total_score==.
browse read write math science total_score if total_score==.

* Recode: Assign letter grades to total test scores.
recode total_score (0/140=0 F) (141/180=1 D) (181/210=2 C) (211/234=3 B) (235/300=4 A), gen(grade)
label variable grade "combined grades of read, write, math, science"
codebook grade

list read write math science total_score grade in 1/10
list read write math science total_score grade in 1/10, nolabel

* Add some notes to the data set.
notes female:  the variable gender was renamed to female
notes race:  values of race coded as 5 were recoded to be missing
notes

* Egen (extended generation): Create a constant with certain variables

* Create a variable with the mean score for Write
* Create standard scores for the variable read
egen mean_write = mean(write)
list mean_write in 1/10

* Create a variable that has the median of read for each program type
egen median_read = median(read), by(prgtype)
list read prgtype median_read in 1/20

* Compute the average of scores for each observation/person
* Ignores missing values for science
egen row_mean = rowmean(read write math science)
list read write math science row_mean in 1/10

**************************************************
** Managing data
**************************************************
/*
keep if	Keep observations if condition is met
keep	Keep variables or observations
drop	Drop variables or observations
drop if	Drop observations if condition is met
append	Append a data file to current file
sort	Sort observations
merge	Merge a data file with current file
*/

* Drop variables
drop gender

* Drop observations
drop if science==.

* Alternative to drop if
keep if science!=.

* Append with another data with more observations
append using hs0_more

* Merge with another data using a unique key
* hs0_age.dta has age of the individuals
merge 1:1 id using hs0_age
tab _merge
drop if _merge==2
drop _merge

/*
* Other types of merge
* Many-to-one merge on specified key variables
merge m:1 varlist using filename [, options]
* One-to-many merge on specified key variables
merge 1:m varlist using filename [, options]
* Many-to-many merge on specified key variables
merge m:m varlist using filename [, options]
*/

**************************************************
** Probability distributions
**************************************************
capture scalar drop _all
* To get the CDF of standard normal distribution
scalar cdfval1 = normal(0)
scalar cdfval2 = normal(-1.96)
scalar cdfval3 = normal(1.96)
scalar list
* To do the reverse of normal
scalar val1 = invnorm(0.5)
scalar val2 = invnorm(0.025)
scalar val3 = invnorm(0.975)
scalar list

* To get the CDF of chi-squared distribution with n degrees of freedom
scalar cdfval4 = chi2(10,5)
scalar list
* To do the reverse of chi2
scalar val4 = invchi2(10,.10882198)
scalar list

**************************************************
** Creating random draws
**************************************************
* Create random uniform values in [0, 1] 
gen rndm_uni = runiform()
* Histogram
hist rndm_uni
hist rndm_uni, frequency

* Create random normally distrbuted values with mean m and standard deviation s 
gen rndm_norm = rnormal(5,2)
* Histogram
hist rndm_norm
hist rndm_norm, frequency

**************************************************
** Using loops: "foreach" or "forvalues"
** Many different kinds so need to use help menu!
**************************************************
forvalues i = 1(1)10 {
	display "This is iteration: `i'"
	gen myvar`i' = runiform()
}


log close

*EOF

