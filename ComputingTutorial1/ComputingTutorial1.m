% Stats computing tutorial 1
%% Part 1 - Importing data and summary statistics
% Reading in the data from the CSV
Data = readtable("faithful.csv");

% Creating a struct to assign statistics about waiting time till
WaitingStats = struct;
% Assigning statistics about waiting time
WaitingStats.Max = max(Data.waiting);
WaitingStats.Min = min(Data.waiting);
WaitingStats.Mean = mean(Data.waiting);
WaitingStats.Median = median(Data.waiting);
WaitingStats.Mode = mode(Data.waiting);
WaitingStats.Std = std(Data.waiting);
WaitingStats.Variance = var(Data.waiting);

% Creating a box plot of waiting for each day
figure
hAx = axes;
% This function creates box plots of the waiting data using the day data as
% a label for the plots.
boxplot(Data.waiting, Data.day)
% Ading axis labels
xlabel("Day")
ylabel("Waiting time in minutes from previous eruption")

% The whiskers of the plots are defined as the most extreme data points not
% considered outliers, they can be adjusted using an additional input, the
% default numerical value is 1.5
figure
hAx = axes;
boxplot(Data.waiting, Data.day, 'Whisker', 3)
xlabel("Day")
ylabel("Waiting time in minutes from previous eruption")

% Everyday the mean waiting time is between 70 and 80 minutes, outside of
% that there don't seem to be many other patterns in the data.