
clear; clc;
load('Problem1Data.mat');

figure(1);
clf;
alpha = 1.0;
beta = 0.0;
plot(t,y,'b.',t,alpha * t + beta,'r','Markersize',10);

legend('Data','True Model')
xlabel('t')
ylabel('y')