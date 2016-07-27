* load data

summarize

* estimate model
reg lsalary lsales lmktval profmarg ceoten comten
* adj r-squared improves slightly after removing profmarg
reg lsalary lsales lmktval ceoten comten
reg lsalary lsales lmktval 
reg lsalary lsales profmarg ceoten comten

reg lsalary lsales lmktval profmarg ceoten comten comtensq ceotensq
ovtest

reg lsalary lsales lmktval profmarg ceoten comten comtensq ceotensq
reg lsalary lsales lmktval profmarg ceoten comten ceotensq

reg lsalary sales mktval profmarg ceoten comten ceotensq
generate sales_sq = sales^2
generate mktval_sq = mktval^2
reg lsalary sales sales_sq mktval mktval_sq profmarg ceoten comten ceotensq

reg lsalary lsales lmktval profmarg ceoten comten
predict original_fit
reg lsalary sales sales_sq mktval mktval_sq profmarg ceoten comten ceotensq
predict model4_fit

reg lsalary lsales lmktval profmarg ceoten comten model4_fit
reg lsalary sales sales_sq mktval mktval_sq profmarg ceoten comten ceotensq original_fit

