% Stats Academic tutorial 1
%% Question 1
% Writing out the dataset
dataset = [15; 25; 22; 31; 25; 19; 8; 24; 44; 30; 34; 12; 7; 33; 19; 20; 19; 42; 38; 27];
% Plotting the histogram
histogram(dataset, [5, 15.5, 25.5, 35.5, 45.5])
% Adding plot labels
xlabel('Count')
ylabel('Frequency')
title('Histogram for geiger counter data')
%% Question 2
% Finding the mean, variance, median and mode of the dataset
a = mean(dataset);
b = var(dataset);
c = median(dataset);
d = mode(dataset);