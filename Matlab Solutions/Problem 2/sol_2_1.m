clear; clc;
load('MMBatchData.mat');
sol_2_0;


x_continuous = rr(length(rr),1) : 0.05 : rr(1,1);

%% First Part

figure(1);
clf;
plot(rr(:,1), rr(:,2),'.', 'MarkerSize', 14);
xlabel('x');
ylabel('y');

%% Second Part

figure(2);
clf;
plot(1./rr(:,1), 1./rr(:,2), '.', 'MarkerSize', 14);
xlabel('1/x');
ylabel('1/y');
%% Third, Fourth Part

A = [1./rr(:,1), ones(rr_size, 1)];
b = 1./rr(:,2);

H = A' * A;
f = -A' * b;
x = quadprog(H, f);
x = lsqlin(A,b,[],[]);

x_copy = x;
x_copy(2) = 1./x_copy(2);
x_copy(1) = x_copy(1) * x_copy(2);

theta_star_LS = [x_copy(2); x_copy(1)];
%% Fifth Part

figure(1);
hold on;
plot(x_continuous, x_copy(2) .* x_continuous ./ (x_copy(1) + x_continuous));
hold off;

figure(2);
hold on;
plot(1./x_continuous, x(1) * 1./x_continuous + x(2));
hold off;


nor = norm(rr(:,2) - x_copy(2) .* rr(:,1) ./ (x_copy(1) + rr(:,1)), 2);
