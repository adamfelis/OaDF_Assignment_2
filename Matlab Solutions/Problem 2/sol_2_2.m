
clear; clc;
load('MMBatchData.mat');
sol_2_1;

%% First Part

f = @(theta, x) (theta(1) .* x ./ (theta(2) + x));

x1 = -5:0.05:5;
x2 = -5:0.05:5;
[X,Y] = meshgrid(x1,x2);

y_dash = zeros(10/0.05 + 1, 10/0.05 + 1);
for i = 1 : 10/0.05 + 1
    for j = 1 : 10/0.05 + 1
        for k = 1 : rr_size
            y_dash(i,j) = y_dash(i,j) + 0.5 * (norm(rr(k,2) - f([X(i,j), Y(i,j)], rr(k,1)), 2))^2;
        end
    end
end


figure(3)
v = [0:0.005:0.1 0.1:0.5:10 10:10:100];
[c,h] = contour(X,Y,y_dash,v,'linewidth',2);
colorbar;
axis image;
xlabel('x_1','Fontsize',14);
ylabel('x_2','Fontsize',14);

hold on;
plot(theta_star_LS(1), theta_star_LS(2), 'ro');
hold off;

%% Second Part

%% Third Part

f_non_lin = @(theta) (rr(:,2) - f(theta, rr(:,1)));
theta_star = lsqnonlin(f_non_lin, [0;0]);
figure(1)
hold on;
plot(rr(:,1), f(theta_star, rr(:,1)) , 'go-');
hold off;

m = rr_size;
n = 2;
variance = sum(f_non_lin(theta_star).^ 2) / (m - n);

%% Fourth Part

figure(3)
hold on;
plot(theta_star(1), theta_star(2), 'go');
hold off;