
clear; clc;
load('Problem1Data.mat');

%% First Part
data_length = length(t);
A = ones(data_length, 2);
b = y;

for i = 1:1:data_length
   A(i,1) = t(i);
end

%% Second Part
f_lin = [zeros(1, 2), 1];
A_lin = [-A, -ones(data_length, 1); A, -ones(data_length, 1)];
b_lin = [-b; b]';
[x f e] = linprog(f_lin, A_lin, b_lin);
x = [x(1); x(2)];

model_y = x(1) .* t + x(2);

%% Third Part
figure(1);
clf;
subplot(3,1,1);
alpha = 1.0;
beta = 0.0;
plot(t, y, 'r.', t, alpha * t + beta, 'b', t, model_y, 'g');

legend('Data','True Model', 'LS')
xlabel('t')
ylabel('y')

%% Fourth Part

errors = y - model_y;
subplot(3,1,2);
h = histogram(errors, length(errors));

%% Fifth Part

data_without_outliers = [];
errors_without_outliers = [];
for i = 1:1:length(errors)
    if(errors(i) < 2.1)
        errors_without_outliers = [errors_without_outliers ; errors(i)];
        data_without_outliers = [data_without_outliers ; y(i)];
    end
end
subplot(3,1,3);
h = histogram(errors_without_outliers, length(errors)/4);


%% Sixth Part
m = length(errors_without_outliers);
n = 2;
sd_of_noise = sum(errors_without_outliers .^ 2) / (m - n);

mean_of_parameters = mean(x);

covariance_matrix = [(x(1) - mean_of_parameters)^2 , (x(1) - mean_of_parameters) * (x(2) - mean_of_parameters);...
                    (x(2) - mean_of_parameters) * (x(1) - mean_of_parameters), (x(2) - mean_of_parameters)^2];

sd_of_parameters = ((x(1) - mean_of_parameters)^2 + (x(2) - mean_of_parameters)^2) / 2;

alph = 0.05;
parameters_interval = t(m-n) * (alph / 2) * sd_of_noise .* sqrt(diag((A'*A)^(-1)));

predictions_interval = t(m-n) * (alph / 2) * sd_of_noise;
