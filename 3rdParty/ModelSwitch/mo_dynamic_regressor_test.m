
%detcting switches in dynamic regressors
%test file
%NO 03/08
seed = 0;
randn('state',seed);
rand('state',seed);

clear all;
close all;

T = 300;
n = 1;
order = 2;

epsilon = 0.2;
noise = (rand(T,1)-0.5)*2*epsilon; norm_used = inf;

%noise = randn(T,1); epsilon = norm(noise); noise = noise*rand; norm_used = 2;

y = randn(n,order);

% I.   y_t = 0.2y_(t-1)+0.24y_(t-2)
% II.  y_t = -1.4y_(t-1)-0.53y_(t-2)
% III. y_t = 1.7y_(t-1)-0.72y_(t-2)

col = floor(T/3);
for i = order+1:col
    y(i) = 0.2*y(i-1)+0.24*y(i-2)+noise(i);
end

for i = col+1:2*col
    y(i) = -1.4*y(i-1)-0.53*y(i-2)+noise(i);
end

for i = 2*col+1:T
    y(i) = 1.7*y(i-1)-0.72*y(i-2)+noise(i);
end

group = multidim_dyn_switch_detect(y(:),norm_used,epsilon,order);