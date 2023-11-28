% Statistics computing tutorial 2
%% Question 1 - Simulation of the probability that athletes took drugs given a positive test result
% Creating an array of 100 random integers between 1 and 10, if it is 1 the
% athlete is on drugs if not then they are not
athletes = randi(10, 100, 1);
% Creating an array of 100 random integers between 1 and 10, if it is 1 or
% 2 the athletes test results are incorrect, otherwise it is correct
testcorrect = randi(10, 100, 1);

% Can now run a simulation to output which athletes the test would deem to
% have taken drugs
ondrugs = zeros(100, 1);
ondrugs(athletes==1 & ~(testcorrect==1 | testcorrect==1), 1) = 1;
ondrugs(athletes~=1 & (testcorrect==1 | testcorrect==2), 1) = 1;

% The above is one simulation of the scenario, the sheet wants us to repeat
% the sim 1000 times and then plot a histogram of the results
% Creating a blank array to add the number of athletes determined to be on
% drugs and another one to record the fraction of people the test recorded
% as one drugs that actually were
Onetestsimresults = [];
OnetestFractions = [];
for i = 1:1000
    % Run simulation
    athletes = randi(10, 100, 1);
    testcorrect = randi(10, 100, 1);
    ondrugs = zeros(100, 1);
    ondrugs(athletes==1 & ~(testcorrect==1 | testcorrect==2), 1) = 1;
    ondrugs(athletes~=1 & (testcorrect==1 | testcorrect==2), 1) = 1;
    % Summing the number of athletes that return a positive test and
    % therefore are deemed to be on drugs
    Onetestsimresults(end+1) = sum(ondrugs==1);
    OnetestFractions(end+1) = sum(ondrugs(athletes==1))/sum(ondrugs==1);
end
Onetestsimresults = Onetestsimresults';
OnetestFractions = OnetestFractions';
figure
tiledlayout(1, 2)
nexttile
% Plotting a histogram
histogram(Onetestsimresults)
xlabel('Athletes testing positive')
ylabel('Frequency')
title('Histogram of 1 test results')

% Now want to simulate a situation where you have to fail two tests in
% order to be classified as having taken drugs
% Creating more empty arrays
Twotestsimresults = [];
TwotestFractions = [];
for i = 1:1000
    % Run simulation
    athletes = randi(10, 100, 1);
    test1correct = randi(10, 100, 1);
    test2correct = randi(10, 100, 1);
    ondrugs = zeros(100, 1);
    ondrugs(athletes==1 & (~(test1correct==1 | test1correct==2) & ~(test2correct==1 | test2correct==2)), 1) = 1;
    ondrugs(athletes~=1 & ((test1correct==1 | test1correct==2) & (test2correct==1 | test2correct==2)), 1) = 1;
    % Summing the number of athletes that return a positive test and
    % therefore are deemed to be on drugs
    Twotestsimresults(end+1) = sum(ondrugs==1);
    TwotestFractions(end+1) = sum(ondrugs(athletes==1))/sum(ondrugs==1);
end
Twotestsimresults = Twotestsimresults';
TwotestFractions = TwotestFractions';
nexttile
% Plotting a histogram
histogram(Twotestsimresults)
xlabel('Athletes testing positive')
ylabel('Frequency')
title('Histogram of 2 test results')

% Bayes theorem to work out the conditional probability of an athlete
% having done drugs given they did one test and failed it
BayesOnetest = (0.8*0.1)/0.26;
disp(BayesOnetest)
disp(mean(OnetestFractions)) 

% Bayes theorem to work out the conditional probability of an athlete
% having done drugs given they did two test and failed it
BayesTwotest = (0.64*0.1)/0.0676;
disp(BayesTwotest)
disp(mean(TwotestFractions))

%% Question 2 - Probability distributions
% Setting up an input x vector
x1 = linspace(0, 12, 13)';
x2 = linspace(-10, 10, 100)';

% Getting geometric pdf values
geopdfresults = geopdf(x1, 0.3);
% Getting geometric cdf values
geocdfresults = geocdf(x1, 0.3);

% Getting normal pdf values
normpdfresults = normpdf(x2, 0, 2);
% Getting normal cdf values
normcdfresults = normcdf(x2, 0, 2);

% Plotting
figure
tiledlayout(2, 2)
% Geometric pdf
nexttile
plot(x1, geopdfresults)
title('Geometric distribution pdf')
xlabel('x value')
ylabel('probability')
% Geometric cdf
nexttile
plot(x1, geocdfresults)
title('Geometric distribution cdf')
xlabel('x value')
ylabel('probability')
% Normal pdf
nexttile
plot(x2, normpdfresults)
title('Normal distribution pdf')
xlabel('x value')
ylabel('probability')
% Normal cdf
nexttile
plot(x2, normcdfresults)
title('Normal distribution cdf')
xlabel('x value')
ylabel('probability')

% Generating random numbers from each distribution
samples = 1000;
georndresults = geornd(0.3, [samples, 1]);
normrndresults = normrnd(0, 2, [samples, 1]);

% Plotting 
figure
tiledlayout(1, 2)
nexttile
histogram(georndresults, 'Normalization', 'pdf')
hold on
plot(x1, geopdfresults)
title('Histogram of random values from geometric distribution')
xlabel('x values')
ylabel('relative frequency')

nexttile
histogram(normrndresults, 'Normalization', 'pdf')
hold on
plot(x2, normpdfresults)
title('Histogram of random values from normal distribution')
xlabel('x values')
ylabel('relative frequency')

% Calculating means and standard deviations for the randomly generated
% values
georndmean = sum(georndresults)/samples;
disp(georndmean)
georndstd = sqrt(sum((georndresults-georndmean).^2)/(samples-1));
disp(georndstd)

normrndmean = sum(normrndresults)/samples;
disp(normrndmean)
normrndstd = sqrt(sum((normrndresults-normrndmean).^2)/(samples-1));
disp(normrndstd)