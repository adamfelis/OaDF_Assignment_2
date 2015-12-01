clear; clc;
load('MMBatchData.mat');
data_size = length(data);
%% First Part
figure(1)
plot(data(:,1), data(:,2), '.', 'Markersize', 10);
xlabel('t','Fontsize',14);
ylabel('y','Fontsize',14);

%% Second Part

[T, X] = y_dash(data(:,1), [0.1 0.1]);

hold on;
plot(T,X,'go-');
hold off;

%odeset(abstol,1e-12,'rmitol',1e-12
%% Third Part

theta_1 = 0:0.01:1;
theta_2 = 0:0.01:1;
[X_theta, Y_theta] = meshgrid(theta_1, theta_2);

z = zeros(1/0.01 + 1, 1/0.01 + 1);
for i = 1 : 1/0.01 + 1
    for j = 1 : 1/0.01 + 1
        [T, X] = y_dash(data(:,1), [theta_1(i) theta_2(j)]);
        z(i,j) = 0.5 * (norm(data(:,2) - X, 2));
    end
end


figure(3)
v = [0:0.01:1 1:0.1:30];
[c,h] = contour(X_theta,Y_theta,z,v,'linewidth',2);
colorbar;
axis image;
xlabel('Q_2','Fontsize',14);
ylabel('Q_1','Fontsize',14);
