
clear; clc;
load('Problem1Data.mat');

%% First Part
tau = 3;
data_length = length(t);
A = ones(data_length, 2);
b = y;

for i = 1:1:data_length
   A(i,1) = t(i);
end

m = data_length;
H = [zeros(2*m + 2,3*m + 2); zeros(m, 2*m + 2), eye(m,m) ];
g = [zeros(2,1); tau * ones(2*m,1); zeros(m,1)];
Aeq = [-A, -eye(m), eye(m), eye(m)];
beq = -b;
%% Second Part
x = quadprog(H, g, [], [], Aeq, beq, [-inf * ones(2,1) ; zeros(m,1) ; zeros(m,1) ;-inf * ones(m,1)], [inf * ones(3 * m + 2,1)]);
model_y = x(1) .* t + x(2);

%% Third Part
figure(1);
clf;
%subplot(3,1,1);
alpha = 1.0;
beta = 0.0;
plot(t, y, 'r.', t, alpha * t + beta, 'b', t, model_y, 'g');

legend('Data','True Model', 'Huber (tau = 3)')
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

tau = 3;
data_length = length(t_without_outliers);
A = ones(data_length, 2);
b = y_without_outliers;

for i = 1:1:data_length
   A(i,1) = t_without_outliers(i);
end
m = data_length;
H = [zeros(2*m + 2,3*m + 2); zeros(m, 2*m + 2), eye(m,m) ];
g = [zeros(2,1); tau * ones(2*m,1); zeros(m,1)];
Aeq = [-A, -eye(m), eye(m), eye(m)];
beq = -b;
x = quadprog(H, g, [], [], Aeq, beq, [-inf * ones(2,1) ; zeros(m,1) ; zeros(m,1) ;-inf * ones(m,1)], [inf * ones(3 * m + 2,1)]);

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
