clear; clc;
load('MMBatchData.mat');
sol_2_0;



A = [1./rr(:,1), ones(rr_size, 1)];
b = 1./rr(:,2);

H = A' * A;
f = -A' * b;
x = quadprog(H, f);
x = lsqlin(A,b,[],[]);

x_copy = x;
x_copy(2) = 1./x_copy(2);
x_copy(1) = x_copy(1) * x_copy(2);
figure(1);
clf;
plot(rr(:,1), rr(:,2),'o-');
hold on;
plot(rr(:,1), x_copy(2) .* rr(:,1) ./ (x_copy(1) + rr(:,1)),'o-');
hold off;

figure(2);
clf;
plot(1./rr(:,1), 1./rr(:,2), 'o-');
hold on;
plot(1./rr(:,1), x(1) * 1./rr(:,1) + x(2), 'o-');
hold off;

theta_star_LS = [x_copy(2); x_copy(1)];

nor = norm(rr(:,2) - x_copy(2) .* rr(:,1) ./ (x_copy(1) + rr(:,1)), 2);
