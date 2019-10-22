#' ---
#' title: "Epithelioma"
#' author: "Qi Yan"
#' date: "09/08/2019"
#' ---
#' 
#+ init, message=FALSE,echo=FALSE
# init -----
if(interactive()){
  try(source('https://raw.githubusercontent.com/bokov/UT-Template/master/git_setup.R'));
};

# set to > 0 for verbose initialization
.debug <- 0;
# additional packages to install, if needed. If none needed, should be: ''
.projpackages <- c('GGally','tableone','pander')
# name of this script
.currentscript <- "data_characterization.R"; 
# other scripts which need to run before this one. If none needed, shoule be: ''
.deps <- c( 'dictionary.R' ); 

# load stuff ----
# load project-wide settings, including your personalized config.R
if(.debug>0) source('./scripts/global.R',chdir=T) else {
  .junk<-capture.output(source('./scripts/global.R',chdir=T,echo=F))};

#+ startcode, echo=F, message=FALSE
#===========================================================#
# Your code goes below, content provided only as an example #
#===========================================================#
#' ### Data Dictionary
#' 
#' Quality control, descriptive statistics, etc.

#+ characterization, echo=F, message=FALSE
# characterization ----
#' 
#' * Q: What does the command `nrow()` do?
#'     * A: give the number of row the data has
#'          
#'          
#' * Q: What does the command `sample()` do? What are its first and second
#'      arguments for?
#'     * A: sample 10 rows from the table
#'          
#'          
#' * Q: If `foo` were a data frame, what might the expression `foo[bar,baz]` do,
#'      what are the roles of `bar` and `baz` in that expression, and what would
#'      it mean if you left either of them out of the expression?
#'     * A: Gives the row name and column name of the data point you want to look at. If you leave them out you get the characteristics about the data and first 10 rows
#'          
#'          
#' 
for (ii in v(c_ordinal)) {dat00[[ii]] <- as.factor(dat00[[ii]])}
set.seed(project_seed);
dat01 <- dat00[sample(nrow(dat00), nrow(dat00)/2),];  
set.caption('Data Dictionary');
set.alignment(row.names='right');
.oldopt00 <- panderOptions('table.continues');
panderOptions('table.continues','Data Dictionary (continued)');
#  render the Data Dictionary table
pander(dct0[,-1],row.names=dct0$column,split.tables=Inf); 
#  reset this option to its previous value
panderOptions('table.continues',.oldopt00);

#' ### Select predictor and outcome variables (step 8)
#' 
#' Predictors
predictorvars <- c('stageN','surg3','gradeN','age');
#' Outcomes
outcomevars <- c('live','surmo');
#' All analysis-ready variables
mainvars <- c(outcomevars, predictorvars);
#' ### Scatterplot matrix)
#' 
#' To explore pairwise relationships between all variables of interest.
#+ ggpairs_plot, message=FALSE, warning=FALSE
ggpairs(dat01[,mainvars])

#' ### Cohort Characterization (step 10)
#' 
#' To explore possible covariates
#' * Q: Which function 'owns' the argument `caption`? What value does that 
#'      argument pass to that function?
#'     * A: pander, gives the name "data characterizatio" to the graph 
#'          
#'          
#' * Q: Which function 'owns' the argument `printToggle`? What value does that 
#'      argument pass to that function?
#'     * A: print, not sure what value
#'          
#'          
#' * Q: Which function 'owns' the argument `vars`? We can see that the value
#'      this argument passes comes from the variable `mainvars`... so what is
#'      the actual value that ends up getting passed to the function?
#'     * A: CreateTableOne, outcome and predictor variables
#'          
#'          
#' * Q: What is the _very first_ argument of `print()` in the expression below?
#'      (copy-paste only that argument into your answer without including 
#'      anything extra)
#'     * A: CreateTableOne(vars = mainvars, data = dat01sourc
#'          
#'          
pander(print(CreateTableOne(vars = mainvars, strata = stageN, data = dat01, includeNA = TRUE)
             , printToggle=FALSE)
       , caption='Cohort Characterization');

#' ### Data Analysis
#' 
#' Fitting the actual statistical models.
#+ echo=F, message=FALSE
# analysis ----
surv00 <- survfit(Surv(surmo,live)~stageN,dat01)

#+ echo=FALSE,warning=FALSE,message=FALSE
#===========================================================#
##### End of your code, start of boilerplate code ###########
#===========================================================#
knitr::opts_chunk$set(echo = FALSE,warning = FALSE,message=FALSE);

# save out with audit trail 
message('About to tsave');
tsave(file=paste0(.currentscript,'.rdata'),list=setdiff(ls(),.origfiles)
      ,verbose=FALSE);
message('Done tsaving');

#' ### Audit Trail
.wt <- walktrail();
c()
