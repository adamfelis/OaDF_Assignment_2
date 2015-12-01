
clear; clc;
load('MMBatchData.mat');
sol_2_1;

f = @(theta, x) (theta(1) .* x ./ (theta(2) + x));
%% First Part


x1 = 0:0.01:5;
x2 = 0:0.005:0.2;
[X,Y] = meshgrid(x2,x1);

y_dash = zeros(5/0.01 + 1, 0.2/0.005 + 1);
for i = 1 : 5/0.01 + 1
    for j = 1 : 0.2/0.005 + 1
        y_dash(i,j) = 0.5 * (norm(rr(:,2) - f([X(i,j), Y(i,j)], rr(:,1)), 2));
    end
end


figure(3)
v = [0:0.00001:0.1 0.1:0.5:10 10:10:100];
[c,h] = contour(X,Y,y_dash,v,'linewidth',2);
colorbar;
%axis image;
xlabel('x_1','Fontsize',14);
ylabel('x_2','Fontsize',14);

hold on;
plot(theta_star_LS(1), theta_star_LS(2), 'ro');
hold off;

%% Second Part

%% Third Part

f_non_lin = @(theta) (rr(:,2) - f(theta, rr(:,1)));
[theta_star, resnorm,residual,exitflag,output] = lsqnonlin(f_non_lin, theta_star_LS);


m = rr_size;
n = 2;
variance = sum(f_non_lin(theta_star).^ 2) / (m - n);

J = [rr(:,1)./(theta_star(2) + rr(:,1)) , theta_star(1) * rr(:,1)./((theta_star(2) + rr(:,1)).^2)];

H = J'*J;
covariance_matrix = variance * variance * H^(-1);
alpha = 0.05;
parameters_interval = tinv(alpha/2, m-n) * variance * sqrt(diag(H^(-1)));
%% Fourth Part
figure(1)
hold on;
plot(x_continuous, f(theta_star, x_continuous) , 'g');
hold off;

figure(2)
hold on;
plot(1./x_continuous, 1./f(theta_star, x_continuous) , 'g');
hold off;

figure(3)
hold on;
plot(theta_star(1), theta_star(2), 'go');
hold off;

%% Fifth Part

disp(output.iterations);