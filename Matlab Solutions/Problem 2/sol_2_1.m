clear; clc;
load('MMBatchData.mat');
sol_2_0;


x_continuous = rr(length(rr),1) : 0.05 : rr(1,1);

%% First Part

figure(1);
clf;
plot(rr(:,1), rr(:,2),'.', 'MarkerSize', 12);


%% Second Part

figure(2);
clf;
plot(1./rr(:,1), 1./rr(:,2), '.', 'MarkerSize', 12);

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

%% Fifth Part

figure(1);
hold on;
plot(x_continuous, x_copy(2) .* x_continuous ./ (x_copy(1) + x_continuous));
hold off;

figure(2);
hold on;
plot(1./x_continuous, x(1) * 1./x_continuous + x(2));
hold off;

theta_star_LS = [x_copy(2); x_copy(1)];

nor = norm(rr(:,2) - x_copy(2) .* rr(:,1) ./ (x_copy(1) + rr(:,1)), 2);
