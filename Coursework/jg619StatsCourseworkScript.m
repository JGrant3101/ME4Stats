% Stats coursework script
clear all
close all
clc
%% Import the dataset
% Will start by importing the dataset
dataset = readtable('jg619.csv');

% Creating arrays from the table
CO = dataset{:, 1};
T = dataset{:, 2};
RH = dataset{:, 3};

%% Question 1a
% Will have close all and clc at the start of each section to make plotting and
% looking at results while writing the code easier
close all
clc

% Want to plot a histogram for each of the features
% Creating the carbon monoxide histogram
figure
histogram(CO, 14)
xlabel('Carbon monoxide concentration (mg/m^3)')
ylabel('Frequency')
title('Histogram of carbon monoxide concentration from dataset jg619')

% Creating the temperature histrogram
figure
histogram(T, 12)
xlabel('Temperature (degrees celcius)')
ylabel('Frequency')
title('Histogram of temperature from dataset jg619')

% Creating the relaitve humidity histogram
figure 
histogram(RH, 12)
xlabel('Relative humidity (%)')
ylabel('Frequency')
title('Histogram of Relative humidity from dataset jg619')

%% Question 1b
close all
clc

% Want to make a scatter plot for each pair of features
% Creating the CO and T scatter plot
figure
scatter(T, CO, 'filled')
xlabel('Temperature (degrees celcius)')
ylabel('Carbon monoxide concentration (mg/m^3)')
title('Scatter plot of CO concentration vs temperature from dataset jg619')

% Creating the CO and RH scatter plot
figure
scatter(RH, CO, 'filled')
xlabel('Relative humidity (%)')
ylabel('Carbon monoxide concentration (mg/m^3)')
title('Scatter plot of CO concentration vs relative humidity from dataset jg619')

% Creating the T and RH scatter plot
figure
scatter(T, RH, 'filled')
xlabel('Temperature (degrees celcius)')
ylabel('Relative humidity (%)')
title('Scatter plot of relative humidity vs temperature from dataset jg619')

% Now that the scatter plots have been done can find the 2D linear 
% correlation coefficients
% Do this firstly for CO vs T
RCOvsT = corr2(T, CO);

% Then for CO vs RH
RCOvsRH = corr2(RH, CO);

% And finally for RH vs T
RRHvsT = corr2(T, RH);

% Then print these values
disp(['The correlation coefficient for CO vs T is: ', num2str(RCOvsT)])

disp(['The correlation coefficient  for CO vs RH is: ', num2str(RCOvsRH)])

disp(['The correlation coefficient for T vs RH is: ', num2str(RRHvsT)])

%% Question 2a
close all
clc

% Fitting a linear regression model for CO vs T and CO vs RH
% Firstly CO vs T
COvsTmodel = fitlm(T, CO, 'VarNames', {'T', 'CO'});

% Then CO vs RH
COvsRHmodel = fitlm(RH, CO, 'VarNames', {'RH', 'CO'});

% Each of these models returns two values for the coefficient of
% determination, an ordinary one and an adjusted one which takes into
% account the number of independent variables used to construct the model.
% I will use adjusted as it gives a more precise view of the correlation
% Printing these values
disp(['The adjusted coeffecient of determination for CO vs T is: ', num2str(COvsTmodel.Rsquared.Adjusted)])

disp(['The adjusted coeffecient of determination for CO vs RH is: ', num2str(COvsRHmodel.Rsquared.Adjusted)])

% Will also plot these models
% Firstly CO vs T
figure
plot(COvsTmodel)

% Then CO vs RH
figure
plot(COvsRHmodel)

%% Question 2b
close all
clc

% Now want to fit a linear regression model for CO vs both T and RH
% together
% Start by constructing an array that contains both T and RH
linmodelarray = [T, RH];

% Now fitting the linear model
COvsTandRHmodel = fitlm(linmodelarray, CO, 'VarNames', {'T', 'RH', 'CO'});

% Again printing displaying the adjusted coefficient of determination
disp(['The adjusted coeffecient of determination for CO vs T and RH is: ', num2str(COvsTandRHmodel.Rsquared.Adjusted)])

% Will also plot the model
figure
plot(COvsTandRHmodel)

%% Question 3
close all
clc

% Wants us to start by splitting the dataset into two halves so the models
% can be tested on unseen data.
% Find the length of data and divide by 2
num = numel(CO)/2;

% Splitting the data
fold1CO = CO(1:num);
fold1T = T(1:num);
fold1RH = RH(1:num);

fold2CO = CO(num+1:end);
fold2T = T(num+1:end);
fold2RH = RH(num+1:end);

% Now want to build the same set of models for both datasets and use them
% to predict the CO values for the other dataset

% Start with fold1 models
% Firstly CO vs T
COvsTmodel1 = fitlm(fold1T, fold1CO, 'VarNames', {'T', 'CO'});

% Then CO vs RH
COvsRHmodel1 = fitlm(fold1RH, fold1CO, 'VarNames', {'RH', 'CO'});

% Start by constructing an array that contains both T and RH
linmodelarray1 = [fold1T, fold1RH];

% Now fitting the linear model
COvsTandRHmodel1 = fitlm(linmodelarray1, fold1CO, 'VarNames', {'T', 'RH', 'CO'});

% Then the fold2 models
% Firstly CO vs T
COvsTmodel2 = fitlm(fold2T, fold2CO, 'VarNames', {'T', 'CO'});

% Then CO vs RH
COvsRHmodel2 = fitlm(fold2RH, fold2CO, 'VarNames', {'RH', 'CO'});

% Start by constructing an array that contains both T and RH
linmodelarray2 = [fold2T, fold2RH];

% Now fitting the linear model
COvsTandRHmodel2 = fitlm(linmodelarray2, fold2CO, 'VarNames', {'T', 'RH', 'CO'});

% Now can obtain the predictions for the other dataset using the linear
% regression models

% Start with the fold1 predictions, so using the fold2 models
% Firstly the Co vs T model
fold1COpredfromT = predict(COvsTmodel2, fold1T);

% Then CO vs RH
fold1COpredfromRH = predict(COvsRHmodel2, fold1RH);

% Then CO vs RH and T
fold1COpredfromTandRH = predict(COvsTandRHmodel2, linmodelarray1);

% Now can do the fold2 predictions, using the fold1 models
% Firstly the Co vs T model
fold2COpredfromT = predict(COvsTmodel1, fold2T);

% Then CO vs RH
fold2COpredfromRH = predict(COvsRHmodel1, fold2RH);

% Then CO vs RH and T
fold2COpredfromTandRH = predict(COvsTandRHmodel1, linmodelarray2);

% Now can calculate the residuals for all the predictions, the residual is
% the predicted value minus the observed value
% Start with the fold 1 values
% Firstly the CO predicted from T
fold1COfromTresidual = fold1COpredfromT - fold1CO;

% Then the CO predicted from RH
fold1COfromRHresidual = fold1COpredfromRH - fold1CO;

% Then the CO predicted from T and RH
fold1COfromTandRHresidual = fold1COpredfromTandRH - fold1CO;

% Now repeat for the fold 2 values
% Firstly the CO predicted from T
fold2COfromTresidual = fold2COpredfromT - fold2CO;

% Then the CO predicted from RH
fold2COfromRHresidual = fold2COpredfromRH - fold2CO;

% Then the CO predicted from T and RH
fold2COfromTandRHresidual = fold2COpredfromTandRH - fold2CO;

%% Question 3a
close all
clc

% Part a then wants us to assess the normality of the errors, this will be
% done using a Shapiro-Wilk test, the function for this is defined at the
% end of the file and was obtained from Mathworks file exchange, it was
% written by Ahmed BenSaida.

% Doing this for the fold1 residuals
% Firstly for CO predicted from T
[HCOfromTresidual1, pValueCOfromTresidual1, WCOfromTresidual1] = swtest(fold1COfromTresidual, 0.05);

% Then for CO predicted from RH
[HCOfromRHresidual1, pValueCOfromRHresidual1, WCOfromRHresidual1] = swtest(fold1COfromRHresidual, 0.05);

% Then for CO predicted from T and RH
[HCOfromTandRHresidual1, pValueCOfromTandRHresidual1, WCOfromTandRHresidual1] = swtest(fold1COfromTandRHresidual, 0.05);

% Now do the same for the fold2 residuals
% Firstly for CO predicted from T
[HCOfromTresidual2, pValueCOfromTresidual2, WCOfromTresidual2] = swtest(fold2COfromTresidual, 0.05);

% Then for CO predicted from RH
[HCOfromRHresidual2, pValueCOfromRHresidual2, WCOfromRHresidual2] = swtest(fold2COfromRHresidual, 0.05);

% Then for CO predicted from T and RH
[HCOfromTandRHresidual2, pValueCOfromTandRHresidual2, WCOfromTandRHresidual2] = swtest(fold2COfromTandRHresidual, 0.05);

% Combining the residuals into 1 residual array per independent variable(s)
% to assess the normality of errors for all datapoints
% Firslty making the array for CO from T
COfromTresidual = [fold1COfromTresidual; fold2COfromTresidual];

% Then for CO from RH
COfromRHresidual = [fold1COfromRHresidual; fold2COfromRHresidual];

% And finally for CO from T and RH
COfromTandRHresidual = [fold1COfromTandRHresidual; fold2COfromTandRHresidual];

% Now running the Shapiro-Wilk test on these arrays
% Firstly for CO predicted from T
[HCOfromTresidual, pValueCOfromTresidual, WCOfromTresidual] = swtest(COfromTresidual, 0.05);

% Then for CO predicted from RH
[HCOfromRHresidual, pValueCOfromRHresidual, WCOfromRHresidual] = swtest(COfromRHresidual, 0.05);

% Then for CO predicted from T and RH
[HCOfromTandRHresidual, pValueCOfromTandRHresidual, WCOfromTandRHresidual] = swtest(COfromTandRHresidual, 0.05);

% Printing values
disp(['The probability suggested by the Shapiro-Wilks test of the residuals of CO from T coming from a normal distribution is: ', num2str(pValueCOfromTresidual)])

if ~HCOfromTresidual
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T cannot be said to not come from a normal distribution')
else
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T can be said to not come from a normal distribution')
end

disp(' ')
disp(['The probability suggested by the Shapiro-Wilks test of the residuals of CO from RH coming from a normal distribution is: ', num2str(pValueCOfromRHresidual)])

if ~HCOfromRHresidual
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T cannot be said to not come from a normal distribution')
else
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T can be said to not come from a normal distribution')
end

disp(' ')
disp(['The probability suggested by the Shapiro-Wilks test of the residuals of CO from T and RH coming from a normal distribution is: ', num2str(pValueCOfromTandRHresidual)])

if ~HCOfromTandRHresidual
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T cannot be said to not come from a normal distribution')
else
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T can be said to not come from a normal distribution')
end


%% Question 3b
close all 
clc

% Part b then wants us to calculate the sum of the squares of the residuals
% for each model in order to determine which model is best based on the
% smallest overall error
% Firstly do this for CO from T
COfromTresidualSumofSquares = sum(COfromTresidual.^2);

% Then for CO from RH
COfromRHresidualSumofSquares = sum(COfromRHresidual.^2);

% Finall for CO from T and RH
COfromTandRHresidualSumofSquares = sum(COfromTandRHresidual.^2);

% Then print the three values
disp(['The sum of squares of the residuals of CO from T is: ', num2str(COfromTresidualSumofSquares)])

disp(['The sum of squares of the residuals of CO from RH is: ', num2str(COfromRHresidualSumofSquares)])

disp(['The sum of squares of the residuals of CO from T and RH is: ', num2str(COfromTandRHresidualSumofSquares)])

%% Question 4
close all
clc

% Want to start by setting up a day array that goes from 1 to the length of
% the dataset
day = linspace(1, numel(T), numel(T))';

%% Question 4a
close all 
clc

% Want to produce a scatter plot of CO vs day
figure
scatter(day, CO, 'filled')
xlabel('day')
ylabel('Carbon monoxide concentration (mg/m^3)')
title('CO concentration versus day')

% Next need to compute the correlation
RCOvsday = corr2(day, CO);

% And build a linear regression model
COvsdaymodel = fitlm(day, CO, 'VarNames', {'Day', 'CO'});

% Printing the adjusted correlations coefficient and coefficient of 
% determination for the model
disp(['The correlation coefficient for CO vs Day is: ', num2str(RCOvsday)])

disp(['The adjusted coeffecient of determination for CO vs Day is: ', num2str(COvsdaymodel.Rsquared.Adjusted)])

%% Question 4b
close 
clc

% Want to try the same again but now using the square root of day
sqrtday = sqrt(day);

% The question wants us to compare the fit, normality of errors and sum of
% squares of residuals to just using day
% Start by computing the correlation and creating a linear regression model 
% for CO vs sqrt(day)
RCOvssqrtday = corr2(sqrtday, CO);

% And build a linear regression model
COvssqrtdaymodel = fitlm(sqrtday, CO, 'VarNames', {'sqrt(Day)', 'CO'});

% Printing both coefficients of correlation and adjusted coefficients of
% determination
disp(['The coefficient of correlation for CO vs Day is: ', num2str(RCOvsday)])

disp(['The coefficient of correlation for CO vs sqrt(Day) is: ', num2str(RCOvssqrtday)])

disp(['The adjusted coeffecient of determination for CO vs Day is: ', num2str(COvsdaymodel.Rsquared.Adjusted)])

disp(['The adjusted coeffecient of determination for CO vs sqrt(Day) is: ', num2str(COvssqrtdaymodel.Rsquared.Adjusted)])
disp(' ')

% As we want to go on to compare the residuals need to do the cross fold
% validation
fold1day = day(1:num);
fold2day = day(num+1:end);

fold1sqrtday = sqrtday(1:num);
fold2sqrtday = sqrtday(num+1:end);

% Now want to build the same set of models for both datasets and use them
% to predict the CO values for the other dataset

% Start with fold1 models
% Firstly CO vs Day
COvsdaymodel1 = fitlm(fold1day, fold1CO, 'VarNames', {'Day', 'CO'});

% Then CO vs sqrt(Day)
COvssqrtdaymodel1 = fitlm(fold1sqrtday, fold1CO, 'VarNames', {'sqrt(Day)', 'CO'});

% Next do the fold2 models
% Firstly CO vs Day
COvsdaymodel2 = fitlm(fold2day, fold2CO, 'VarNames', {'Day', 'CO'});

% Then CO vs sqrt(Day)
COvssqrtdaymodel2 = fitlm(fold2sqrtday, fold2CO, 'VarNames', {'sqrt(Day)', 'CO'});

% Now want to use the model based on each dataset to predict results for
% the other dataset
% Predicting values for fold1 first, so using the fold2 models
fold1COpredfromday = predict(COvsdaymodel2, fold1day);
fold1COpredfromsqrtday = predict(COvssqrtdaymodel2, fold1sqrtday);

% Now predicting the fold2 values
fold2COpredfromday = predict(COvsdaymodel1, fold2day);
fold2COpredfromsqrtday = predict(COvssqrtdaymodel1, fold2sqrtday);

% Finding the residuals for each set of predictions
fold1COfromdayresidual = fold1COpredfromday - fold1CO;
fold1COfromsqrtdayresidual = fold1COpredfromsqrtday - fold1CO;

fold2COfromdayresidual = fold2COpredfromday - fold2CO;
fold2COfromsqrtdayresidual = fold2COpredfromsqrtday - fold2CO;

% Combining these residuals into a single array per feature
COfromdayresidual = [fold1COfromdayresidual; fold2COfromdayresidual];

COfromsqrtdayresidual = [fold1COfromsqrtdayresidual; fold2COfromsqrtdayresidual];

% Can now find the normality of these residuals
% Firstly the residual for CO predicted from Day
[HCOfromdayresidual, pValueCOfromdayresidual, WCOfromdayresidual] = swtest(COfromdayresidual, 0.05);

% Then the residual for CO predicted from sqrt(Day)
[HCOfromsqrtdayresidual, pValueCOfromsqrtdayresidual, WCOfromsqrtdayresidual] = swtest(COfromsqrtdayresidual, 0.05);

% Printing values
disp(['The probability suggested by the Shapiro-Wilks test of the residuals of CO from Day coming from a normal distribution is: ', num2str(pValueCOfromdayresidual)])

if ~HCOfromdayresidual
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T cannot be said to not come from a normal distribution')
else
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T can be said to not come from a normal distribution')
end

disp(' ')
disp(['The probability suggested by the Shapiro-Wilks test of the residuals of CO from sqrt(Day) coming from a normal distribution is: ', num2str(pValueCOfromsqrtdayresidual)])

if ~HCOfromsqrtdayresidual
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T cannot be said to not come from a normal distribution')
else
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T can be said to not come from a normal distribution')
end
disp(' ')

% And now find the sum of the squares of the residuals and print those
% values
% Firstly do this for CO from Day
COfromdayresidualSumofSquares = sum(COfromdayresidual.^2);

% Then do this for CO from sqrt(Day)
COfromsqrtdayresidualSumofSquares = sum(COfromsqrtdayresidual.^2);

% Printing these
disp(['The sum of squares of the residuals of CO from Day is: ', num2str(COfromdayresidualSumofSquares)])

disp(['The sum of squares of the residuals of CO from sqrt(Day) is: ', num2str(COfromsqrtdayresidualSumofSquares)])

%% Question 4c
close all 
clc

% I already have the CO vs T and RH model but will need to make models for
% the CO vs T, RH and Day and CO vs T, RH and sqrt(Day) models. To compare
% them I will look at the coefficient of determination of each as well as
% the normality and sum of squares of the residual of each.

% Will first find models for the whole dataset to find the coefficient of
% determination for both models
linmodelarray3 = [T, RH, day];
linmodelarray4 = [T, RH, sqrtday];

% Now fitting the linear models
COvsTRHandDaymodel = fitlm(linmodelarray3, CO, 'VarNames', {'T', 'RH', 'Day', 'CO'});
COvsTRHandsqrtDaymodel = fitlm(linmodelarray4, CO, 'VarNames', {'T', 'RH', 'sqrt(Day)', 'CO'});

% Now printing the coefficient of determination for each, including that
% already found for CO vs T and RH.
disp(['The adjusted coeffecient of determination for CO vs T and RH is: ', num2str(COvsTandRHmodel.Rsquared.Adjusted)])
disp(['The adjusted coeffecient of determination for CO vs T, RH and Day is: ', num2str(COvsTRHandDaymodel.Rsquared.Adjusted)])
disp(['The adjusted coeffecient of determination for CO vs T, RH and sqrt(Day) is: ', num2str(COvsTRHandsqrtDaymodel.Rsquared.Adjusted)])
disp(' ')

% Now want to do the linear regressions to get normality and sum of squares
% of residuals
% Will start by generating the models for CO vs T, RH and Day and CO vs T,
% RH and sqrt(Day)
% Start by making the arrays of independent variables
linmodelarray5 = [fold1T, fold1RH, fold1day];
linmodelarray6 = [fold1T, fold1RH, fold1sqrtday];

linmodelarray7 = [fold2T, fold2RH, fold2day];
linmodelarray8 = [fold2T, fold2RH, fold2sqrtday];

% Now fitting the linear models
COvsTRHandDaymodel1 = fitlm(linmodelarray5, fold1CO, 'VarNames', {'T', 'RH', 'Day', 'CO'});
COvsTRHandsqrtDaymodel1 = fitlm(linmodelarray6, fold1CO, 'VarNames', {'T', 'RH', 'sqrt(Day)', 'CO'});

COvsTRHandDaymodel2 = fitlm(linmodelarray7, fold2CO, 'VarNames', {'T', 'RH', 'Day', 'CO'});
COvsTRHandsqrtDaymodel2 = fitlm(linmodelarray8, fold2CO, 'VarNames', {'T', 'RH', 'sqrt(Day)', 'CO'});

% Predicting results for the other dataset, starting with fold1 predictions
% so using the fold2 model
fold1COpredfromTRHandDay = predict(COvsTRHandDaymodel2, linmodelarray5);
fold1COpredfromTRHandsqrtDay = predict(COvsTRHandsqrtDaymodel2, linmodelarray6);

% Now getting the fold2 predictions based on the fold1 model
fold2COpredfromTRHandDay = predict(COvsTRHandDaymodel1, linmodelarray7);
fold2COpredfromTRHandsqrtDay = predict(COvsTRHandsqrtDaymodel1, linmodelarray8);

% Now can find the residuals for each
fold1COfromTRHandDayresidual = fold1COpredfromTRHandDay - fold1CO;
fold1COfromTRHandsqrtDayresidual = fold1COpredfromTRHandsqrtDay - fold1CO;

fold2COfromTRHandDayresidual = fold2COpredfromTRHandDay - fold2CO;
fold2COfromTRHandsqrtDayresidual = fold2COpredfromTRHandsqrtDay - fold2CO;

% Combining these into arrays of residuals for the whole dataset
COfromTRHandDayresidual = [fold1COfromTRHandDayresidual; fold2COfromTRHandDayresidual];
COfromTRHandsqrtDayresidual = [fold1COfromTRHandsqrtDayresidual; fold2COfromTRHandsqrtDayresidual];

% Can now find the normality of these residuals
% Firstly the residual for CO predicted from T, RH and Day
[HCOfromTRHandDayresidual, pValueCOfromTRHandDayresidual, WCOfromTRHandDayresidual] = swtest(COfromTRHandDayresidual, 0.05);

% Then the residual for CO predicted from sqrt(Day)
[HCOfromTRHandsqrtDayresidual, pCOfromTRHandsqrtDayresidual, WCOfromTRHandsqrtDayresidual] = swtest(COfromTRHandsqrtDayresidual, 0.05);

% Printing values, including those already found for CO vs T and RH
disp(['The probability suggested by the Shapiro-Wilks test of the residuals of CO from T and RH coming from a normal distribution is: ', num2str(pValueCOfromTandRHresidual)])

if ~HCOfromTandRHresidual
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T cannot be said to not come from a normal distribution')
else
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T can be said to not come from a normal distribution')
end

disp(' ')
disp(['The probability suggested by the Shapiro-Wilks test of the residuals of CO from T, RH and Day coming from a normal distribution is: ', num2str(pValueCOfromTRHandDayresidual)])

if ~HCOfromTRHandDayresidual
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T, RH and Day cannot be said to not come from a normal distribution')
else
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T, RH and Day can be said to not come from a normal distribution')
end

disp(' ')
disp(['The probability suggested by the Shapiro-Wilks test of the residuals of CO from T, RH and sqrt(Day) coming from a normal distribution is: ', num2str(pCOfromTRHandsqrtDayresidual)])

if ~HCOfromTRHandsqrtDayresidual
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T, RH and sqrt(Day) cannot be said to not come from a normal distribution')
else
    disp('The Shapiro-Wilks test suggests that with a 5% significance level the residuals of CO from T, RH and sqrt(Day) can be said to not come from a normal distribution')
end
disp(' ')

% And now find the sum of the squares of the residuals and print those
% values
% Firstly do this for CO from Day
COfromTRHandDayresidualSumofSquares = sum(COfromTRHandDayresidual.^2);

% Then do this for CO from sqrt(Day)
COfromTRHandsqrtDayresidualSumofSquares = sum(COfromTRHandsqrtDayresidual.^2);

% Printing these
disp(['The sum of squares of the residuals of CO from T, RH and Day is: ', num2str(COfromdayresidualSumofSquares)])

disp(['The sum of squares of the residuals of CO from T, RH and sqrt(Day) is: ', num2str(COfromsqrtdayresidualSumofSquares)])

%% Functions
function [H, pValue, W] = swtest(x, alpha)
    %SWTEST Shapiro-Wilk parametric hypothesis test of composite normality.
    %   [H, pValue, SWstatistic] = SWTEST(X, ALPHA) performs the
    %   Shapiro-Wilk test to determine if the null hypothesis of
    %   composite normality is a reasonable assumption regarding the
    %   population distribution of a random sample X. The desired significance 
    %   level, ALPHA, is an optional scalar input (default = 0.05).
    %
    %   The Shapiro-Wilk and Shapiro-Francia null hypothesis is: 
    %   "X is normal with unspecified mean and variance."
    %
    %   This is an omnibus test, and is generally considered relatively
    %   powerful against a variety of alternatives.
    %   Shapiro-Wilk test is better than the Shapiro-Francia test for
    %   Platykurtic sample. Conversely, Shapiro-Francia test is better than the
    %   Shapiro-Wilk test for Leptokurtic samples.
    %
    %   When the series 'X' is Leptokurtic, SWTEST performs the Shapiro-Francia
    %   test, else (series 'X' is Platykurtic) SWTEST performs the
    %   Shapiro-Wilk test.
    % 
    %    [H, pValue, SWstatistic] = SWTEST(X, ALPHA)
    %
    % Inputs:
    %   X - a vector of deviates from an unknown distribution. The observation
    %     number must exceed 3 and less than 5000.
    %
    % Optional inputs:
    %   ALPHA - The significance level for the test (default = 0.05).
    %  
    % Outputs:
    %  SWstatistic - The test statistic (non normalized).
    %
    %   pValue - is the p-value, or the probability of observing the given
    %     result by chance given that the null hypothesis is true. Small values
    %     of pValue cast doubt on the validity of the null hypothesis.
    %
    %     H = 0 => Do not reject the null hypothesis at significance level ALPHA.
    %     H = 1 => Reject the null hypothesis at significance level ALPHA.
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                Copyright (c) 17 March 2009 by Ahmed Ben Saïda          %
    %                 Department of Finance, IHEC Sousse - Tunisia           %
    %                       Email: ahmedbensaida@yahoo.com                   %
    %                    $ Revision 3.0 $ Date: 18 Juin 2014 $               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %
    % References:
    %
    % - Royston P. "Remark AS R94", Applied Statistics (1995), Vol. 44,
    %   No. 4, pp. 547-551.
    %   AS R94 -- calculates Shapiro-Wilk normality test and P-value
    %   for sample sizes 3 <= n <= 5000. Handles censored or uncensored data.
    %   Corrects AS 181, which was found to be inaccurate for n > 50.
    %   Subroutine can be found at: http://lib.stat.cmu.edu/apstat/R94
    %
    % - Royston P. "A pocket-calculator algorithm for the Shapiro-Francia test
    %   for non-normality: An application to medicine", Statistics in Medecine
    %   (1993a), Vol. 12, pp. 181-184.
    %
    % - Royston P. "A Toolkit for Testing Non-Normality in Complete and
    %   Censored Samples", Journal of the Royal Statistical Society Series D
    %   (1993b), Vol. 42, No. 1, pp. 37-43.
    %
    % - Royston P. "Approximating the Shapiro-Wilk W-test for non-normality",
    %   Statistics and Computing (1992), Vol. 2, pp. 117-119.
    %
    % - Royston P. "An Extension of Shapiro and Wilk's W Test for Normality
    %   to Large Samples", Journal of the Royal Statistical Society Series C
    %   (1982a), Vol. 31, No. 2, pp. 115-124.
    %
    
    %
    % Ensure the sample data is a VECTOR.
    %
    
    if numel(x) == length(x)
        x  =  x(:);               % Ensure a column vector.
    else
        error(' Input sample ''X'' must be a vector.');
    end
    
    %
    % Remove missing observations indicated by NaN's and check sample size.
    %
    
    x  =  x(~isnan(x));
    
    if length(x) < 3
       error(' Sample vector ''X'' must have at least 3 valid observations.');
    end
    
    if length(x) > 5000
        warning('Shapiro-Wilk test might be inaccurate due to large sample size ( > 5000).');
    end
    
    %
    % Ensure the significance level, ALPHA, is a 
    % scalar, and set default if necessary.
    %
    
    if (nargin >= 2) && ~isempty(alpha)
       if ~isscalar(alpha)
          error(' Significance level ''Alpha'' must be a scalar.');
       end
       if (alpha <= 0 || alpha >= 1)
          error(' Significance level ''Alpha'' must be between 0 and 1.'); 
       end
    else
       alpha  =  0.05;
    end
    
    % First, calculate the a's for weights as a function of the m's
    % See Royston (1992, p. 117) and Royston (1993b, p. 38) for details
    % in the approximation.
    
    x       =   sort(x); % Sort the vector X in ascending order.
    n       =   length(x);
    mtilde  =   norminv(((1:n)' - 3/8) / (n + 1/4));
    weights =   zeros(n,1); % Preallocate the weights.
    
    if kurtosis(x) > 3
        
        % The Shapiro-Francia test is better for leptokurtic samples.
        
        weights =   1/sqrt(mtilde'*mtilde) * mtilde;
    
        %
        % The Shapiro-Francia statistic W' is calculated to avoid excessive
        % rounding errors for W' close to 1 (a potential problem in very
        % large samples).
        %
    
        W   =   (weights' * x)^2 / ((x - mean(x))' * (x - mean(x)));
    
        % Royston (1993a, p. 183):
        nu      =   log(n);
        u1      =   log(nu) - nu;
        u2      =   log(nu) + 2/nu;
        mu      =   -1.2725 + (1.0521 * u1);
        sigma   =   1.0308 - (0.26758 * u2);
    
        newSFstatistic  =   log(1 - W);
    
        %
        % Compute the normalized Shapiro-Francia statistic and its p-value.
        %
    
        NormalSFstatistic =   (newSFstatistic - mu) / sigma;
        
        % Computes the p-value, Royston (1993a, p. 183).
        pValue   =   1 - normcdf(NormalSFstatistic, 0, 1);
        
    else
        
        % The Shapiro-Wilk test is better for platykurtic samples.
    
        c    =   1/sqrt(mtilde'*mtilde) * mtilde;
        u    =   1/sqrt(n);
    
        % Royston (1992, p. 117) and Royston (1993b, p. 38):
        PolyCoef_1   =   [-2.706056 , 4.434685 , -2.071190 , -0.147981 , 0.221157 , c(n)];
        PolyCoef_2   =   [-3.582633 , 5.682633 , -1.752461 , -0.293762 , 0.042981 , c(n-1)];
    
        % Royston (1992, p. 118) and Royston (1993b, p. 40, Table 1)
        PolyCoef_3   =   [-0.0006714 , 0.0250540 , -0.39978 , 0.54400];
        PolyCoef_4   =   [-0.0020322 , 0.0627670 , -0.77857 , 1.38220];
        PolyCoef_5   =   [0.00389150 , -0.083751 , -0.31082 , -1.5861];
        PolyCoef_6   =   [0.00303020 , -0.082676 , -0.48030];
    
        PolyCoef_7   =   [0.459 , -2.273];
    
        weights(n)   =   polyval(PolyCoef_1 , u);
        weights(1)   =   -weights(n);
        
        if n > 5
            weights(n-1) =   polyval(PolyCoef_2 , u);
            weights(2)   =   -weights(n-1);
        
            count  =   3;
            phi    =   (mtilde'*mtilde - 2 * mtilde(n)^2 - 2 * mtilde(n-1)^2) / ...
                    (1 - 2 * weights(n)^2 - 2 * weights(n-1)^2);
        else
            count  =   2;
            phi    =   (mtilde'*mtilde - 2 * mtilde(n)^2) / ...
                    (1 - 2 * weights(n)^2);
        end
            
        % Special attention when n = 3 (this is a special case).
        if n == 3
            % Royston (1992, p. 117)
            weights(1)  =   1/sqrt(2);
            weights(n)  =   -weights(1);
            phi = 1;
        end
    
        %
        % The vector 'WEIGHTS' obtained next corresponds to the same coefficients
        % listed by Shapiro-Wilk in their original test for small samples.
        %
    
        weights(count : n-count+1)  =  mtilde(count : n-count+1) / sqrt(phi);
    
        %
        % The Shapiro-Wilk statistic W is calculated to avoid excessive rounding
        % errors for W close to 1 (a potential problem in very large samples).
        %
    
        W   =   (weights' * x) ^2 / ((x - mean(x))' * (x - mean(x)));
    
        %
        % Calculate the normalized W and its significance level (exact for
        % n = 3). Royston (1992, p. 118) and Royston (1993b, p. 40, Table 1).
        %
    
        newn    =   log(n);
    
        if (n >= 4) && (n <= 11)
        
            mu      =   polyval(PolyCoef_3 , n);
            sigma   =   exp(polyval(PolyCoef_4 , n));    
            gam     =   polyval(PolyCoef_7 , n);
        
            newSWstatistic  =   -log(gam-log(1-W));
        
        elseif n > 11
        
            mu      =   polyval(PolyCoef_5 , newn);
            sigma   =   exp(polyval(PolyCoef_6 , newn));
        
            newSWstatistic  =   log(1 - W);
        
        elseif n == 3
            mu      =   0;
            sigma   =   1;
            newSWstatistic  =   0;
        end
    
        %
        % Compute the normalized Shapiro-Wilk statistic and its p-value.
        %
    
        NormalSWstatistic   =   (newSWstatistic - mu) / sigma;
        
        % NormalSWstatistic is referred to the upper tail of N(0,1),
        % Royston (1992, p. 119).
        pValue       =   1 - normcdf(NormalSWstatistic, 0, 1);
        
        % Special attention when n = 3 (this is a special case).
        if n == 3
            pValue  =   6/pi * (asin(sqrt(W)) - asin(sqrt(3/4)));
            % Royston (1982a, p. 121)
        end
        %
    % To maintain consistency with existing Statistics Toolbox hypothesis
    % tests, returning 'H = 0' implies that we 'Do not reject the null 
    % hypothesis at the significance level of alpha' and 'H = 1' implies 
    % that we 'Reject the null hypothesis at significance level of alpha.'
    %
    
    H  = (alpha >= pValue);
    end
end