clear; clc;
load('MMBatchData.mat');
data_size = length(data);
%% First Part
figure(1)
plot(data(:,1), data(:,2));

%% Second Part

[T, X] = y_dash(20, [0.05 0.97]);

hold on;
plot(T,X,'go-');
hold off;

%% Third Part

theta_1 = -5:0.5:5;
theta_2 = -5:0.5:5;
[X_theta, Y_theta] = meshgrid(theta_1, theta_2);

z = zeros(10/0.5 + 1, 10/0.5 + 1);
for i = 1 : 10/0.5 + 1
    for j = 1 : 10/0.5 + 1
        for k = 1 : data_size
            if data(k,1) == 0
                z(i,j) = z(i,j) + 0.5 * (norm(data(k,2) - 10, 2))^2;
                continue;
            end
            [T, X] = y_dash(data(k,1), [X_theta(i) Y_theta(j)]);
            z(i,j) = z(i,j) + 0.5 * (norm(data(k,2) - X(2), 2))^2;
        end
    end
end


figure(3)
v = [0:0.5:10 10:10:100];
[c,h] = contour(X_theta,Y_theta,z,v,'linewidth',2);
colorbar;
axis image;
xlabel('x_1','Fontsize',14);
ylabel('x_2','Fontsize',14);
