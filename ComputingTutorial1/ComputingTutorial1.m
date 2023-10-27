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
boxplot(Data.waiting, Data.day, 'Whisker', 3)
xlabel("Day")
ylabel("Waiting time in minutes from previous eruption")

% Everyday the mean waiting time is between 70 and 80 minutes, outside of
% that there don't seem to be many other patterns in the data.

%% Part 2 Histograms and kernel density plots
% We are working with the same data from faithful but now are looking to
% produce histograms from it

% Starting by computing the centre of 10 binning intervals using the
% maximum and minium waiting times, linspace is defining the bin centres
bins10 = linspace(WaitingStats.Min, WaitingStats.Max, 10)';
% finding the width of each bin interval
width10 = bins10(2) - bins10(1);
% Then find the number of occurences of the waiting times in each of the
% bins using the hist function
freq10 = hist(Data.waiting, bins10)';

% Now creating the histogram
figure
bar(bins10, freq10, 1);
xlabel("Waiting time (mins)")
ylabel("Frequency")

% Asking for relative frequency to be calculated
relfreq10 = freq10/(sum(freq10) * width10);
% Plotting the relative frequency histogram
figure 
bar(bins10, relfreq10, 1);
xlabel("Waiting time (mins)")
ylabel("Relative Frequency")
hold on

% Now wants the kernel density to be found
kernels10 = ksdensity(Data.waiting, bins10);
% Plotting the results from the smoothed kernel density
plot(bins10, kernels10)

% Repeat using 20 and 50 bins
% 20
bins20 = linspace(WaitingStats.Min, WaitingStats.Max, 20)';
% finding the width of each bin interval
width20 = bins20(2) - bins20(1);
% Then find the number of occurences of the waiting times in each of the
% bins using the hist function
freq20 = hist(Data.waiting, bins20)';

% Now creating the histogram
% figure
% bar(bins20, freq20, 1);
% xlabel("Waiting time (mins)")
% ylabel("Frequency")

% Asking for relative frequency to be calculated
relfreq20 = freq20/(sum(freq20) * width20);
% Plotting the relative frequency histogram
figure 
bar(bins20, relfreq20, 1);
xlabel("Waiting time (mins)")
ylabel("Relative Frequency")
hold on

% Now wants the kernel density to be found
kernels20 = ksdensity(Data.waiting, bins20);
% Plotting the results from the smoothed kernel density
plot(bins20, kernels20)

% 50
bins50 = linspace(WaitingStats.Min, WaitingStats.Max, 50)';
% finding the width of each bin interval
width50 = bins50(2) - bins50(1);
% Then find the number of occurences of the waiting times in each of the
% bins using the hist function
freq50 = hist(Data.waiting, bins50)';

% Now creating the histogram
% figure
% bar(bins50, freq50, 1);
% xlabel("Waiting time (mins)")
% ylabel("Frequency")

% Asking for relative frequency to be calculated
relfreq50 = freq50/(sum(freq50) * width50);
% Plotting the relative frequency histogram
figure 
bar(bins50, relfreq50, 1);
xlabel("Waiting time (mins)")
ylabel("Relative Frequency")
hold on

% Now wants the kernel density to be found
kernels50 = ksdensity(Data.waiting, bins50);
% Plotting the results from the smoothed kernel density
plot(bins50, kernels50)

% According to Stuges' formula the optimal number of bins for the data is
% 9.2 so 9 or 10, looking at the histograms I think 20 seems like a better
% number.

% For me the histograms and kernel density estimates much better illustrate
% the variety of waiting times than the box plots do

% Generating the kernel density smooths with different bandwidths
[kernelsbwdefault, xbwdefault] = ksdensity(Data.waiting);
[kernelsbw10, xbw10] = ksdensity(Data.waiting, 'Bandwidth', 10);
[kernelsbw2, xbw2] = ksdensity(Data.waiting, 'Bandwidth', 2);

% Plotting these
figure 
plot(xbwdefault, kernelsbwdefault)
hold on
plot(xbw10, kernelsbw10)
plot(xbw2, kernelsbw2)
xlabel("Waiting time (mins)")
ylabel("Density")
legend('bw = default', 'bw = 10', 'bw = 2')


%% Part 3 Plotting consecutive eruption waiting times
% Wants us to generate a plot for each day plotting the waiting times
% consecutively
% Generate a figure first 
figure
% Write a for loop 
for i = 1:max(Data.day)
    subplot(3, 5, i)
    PlottingIndices = find(Data.day == i);
    plot(Data.waiting(PlottingIndices))
    if i == 1 || i == 6 || i == 11
        ylabel("Waiting time (mins)")
    end
    xlim([0, 15])
    ylim([0, 120])
    title("Day " + num2str(i))
end