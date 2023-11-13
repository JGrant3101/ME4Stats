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
% Plotting a histogram
histogram(Onetestsimresults)

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
figure
% Plotting a histogram
histogram(Twotestsimresults)

% Bayes theorem to work out the conditional probability of an athlete
% having done drugs given they did one test and failed it
BayesOnetest = (0.8*0.1)/0.26;
disp(BayesOnetest)
disp(mean(OnetestFractions)) 

% Bayes theorem to work out the conditional probability of an athlete
% having done drugs given they did one test and failed it
BayesTwotest = (0.64*0.1)/0.0676;
disp(BayesTwotest)
disp(mean(TwotestFractions))

%% Question 2 - Probability distributions


