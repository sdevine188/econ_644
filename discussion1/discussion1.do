cd "C:\Users\Stephen\Desktop\stata\econ_644\discussion1"
ls
clear
use GPA1.DTA
set more off

summarize
describe

* mean and variance of age
tabstat age, statistics(mean count max min range sd variance)
list, sepby(male)

* calculage mean and var of age manually
egen mean_age = mean(age)
