
clear; clc;
load('Problem1Data.mat');

%% First Part
data_length = length(t);
A = ones(data_length, 2);
b = y;

for i = 1:1:data_length
   A(i,1) = t(i);
end

H = A' * A;
g = -A' * b;
gamma = 0.5 * b' * b;

%% Second Part
x = quadprog(H, g);
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

t_without_outliers = [];
y_without_outliers = [];
errors_without_outliers = [];
for i = 1:1:length(errors)
    if(errors(i) < 4)
        errors_without_outliers = [errors_without_outliers ; errors(i)];
        y_without_outliers = [y_without_outliers ; y(i)];
        t_without_outliers = [t_without_outliers ; t(i)];
    end
end

data_length = length(t_without_outliers);
A = ones(data_length, 2);
b = y_without_outliers;

for i = 1:1:data_length
   A(i,1) = t_without_outliers(i);
end

H = A' * A;
g = -A' * b;
gamma = 0.5 * b' * b;
x = quadprog(H, g);
model_y = x(1) .* t_without_outliers + x(2);
errors = y_without_outliers - model_y;
subplot(3,1,3);
h = histogram(errors, length(errors));

% subplot(3,1,1);
% hold on;
% plot(t_without_outliers, model_y, 'r');
% hold off;

%% Sixth Part
m = length(t_without_outliers);
n = 2;
sd_of_noise = sum(errors.^ 2) / (m - n);

F = A'*A;
covariance_matrix = sd_of_noise * sd_of_noise * F^(-1);

sd_of_parameters = sqrt(diag(covariance_matrix));

alpha = 0.05;
parameters_interval = tinv(alpha/2, m-n) * sd_of_noise * sqrt(diag(F^(-1)));

predictions_interval = tinv(alpha/2, m-n) * sd_of_noise * sqrt(diag(A * F^(-1) * A'));
