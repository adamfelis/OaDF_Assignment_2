
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
%subplot(3,1,1);
alpha = 1.0;
beta = 0.0;
plot(t, y, 'r.', t, alpha * t + beta, 'b', t, model_y, 'g');

legend('Data','True Model', 'l-infinity')
xlabel('t')
ylabel('y')

%% Fourth Part

errors = y - model_y;
figure(2)
%subplot(3,1,2);
h = histogram(errors, length(errors));
xlabel('error');
ylabel('amount');

%% Fifth Part

% data_without_outliers = [];
% errors_without_outliers = [];
% for i = 1:1:length(errors)
%     if(errors(i) < 2.1)
%         errors_without_outliers = [errors_without_outliers ; errors(i)];
%         data_without_outliers = [data_without_outliers ; y(i)];
%     end
% end
% subplot(3,1,3);
% h = histogram(errors_without_outliers, length(errors)/4);

t_without_outliers = [];
y_without_outliers = [];
errors_without_outliers = [];
for i = 1:1:length(errors)
    if(errors(i) < -2)
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
f_lin = [zeros(1, 2), 1];
A_lin = [-A, -ones(data_length, 1); A, -ones(data_length, 1)];
b_lin = [-b; b]';
[x f e] = linprog(f_lin, A_lin, b_lin);
x = [x(1); x(2)];
model_y = x(1) .* t_without_outliers + x(2);
errors = y_without_outliers - model_y;
figure(3)
%subplot(3,1,3);
h = histogram(errors, length(errors));
xlabel('error');
ylabel('amount');
% subplot(3,1,1);
% hold on;
% plot(t_without_outliers, model_y, 'r');
% hold off;


%% Sixth Part
m = length(t_without_outliers);
n = 2;
sd_of_noise = sum(errors.^ 2) / (m - n);

F = A'*A;
covariance_matrix = sd_of_noise * F^(-1);

sd_of_parameters = sqrt(diag(covariance_matrix));

alpha = 0.05;
parameters_interval = tinv(alpha/2, m-n) * sqrt(sd_of_noise) * sqrt(diag(F^(-1)));

predictions_interval = tinv(alpha/2, m-n) * sqrt(sd_of_noise) * sqrt(diag(A * F^(-1) * A'));


