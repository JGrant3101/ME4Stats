% Stats computing tutorial 3
%% 1.1 Building a random number generator - Inverse transform sampling
% Defining lamda for the exponential function
lamdae = 1/3;
% Defining random numbers
ue = rand(10, 1);
% Calculating the inverse of the cdf
xe = -log(1-u) / lamdae;

% Creating the probability distribution object
pde = makedist('Exponential', 'mu', 1/lamdae);

% QQ plotting
figure
qqplot(xe, pde)

% The more samples the closer the random numbers resemble the theoretical
% values

% Doing the same but for Poisson
lamdap = 5;
% Defining random numbers
up = rand(10000, 1);
% Calculating the inverse of the cdf
xp = poissinv(up, lamdap);

% Creating the probability distribution object
pdp = makedist('Poisson', 'lambda', lamdap);

% QQ plotting
figure
qqplot(xp, pdp)

% The QQ plot does not look very appropriate for checking the poisson 
% distribution due to the nature of it dealing with integers

%% 1.2 Building a random number generator the box muller method
% Generating the randomly distributed input numbers
u1 = rand(1000, 1);
u2 = rand(1000, 1);

% Calculating z value
zn = sqrt(-2 * log(u1)) .* cos(2 * pi * u2);

% Above is the standard distribution, can now convert to one with a
% different mean and std
mean = 5;
std = 2;
xn = zn*std + mean;

% Creating the probability distribution object
pdn = makedist('Normal', 'mu', mean, 'sigma', std);

% Plotting
figure
qqplot(xn, pdn)