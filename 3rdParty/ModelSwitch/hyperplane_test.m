
%hyperplane segmentation algorithm
%test file
%NO 03/08

seed = 0;
randn('state',seed);
rand('state',seed);
T = 30000;
n = 3;

epsilon = 0.2;
noise = (rand(T,1)-0.5)*2*epsilon; norm_used = inf;

%noise = randn(T,1)/5; epsilon = norm(noise)*1.5; norm_used = 2;

col = floor(T/3);

dummy = randn(col,n-1);
normal_1 = randn(n,1);
normal_1 = normal_1(1:n-1)./normal_1(n);
data = [dummy, dummy*normal_1+1+noise(1:col)];

dummy = randn(col,n-1);
normal_2 = randn(n,1);
normal_2 = normal_2(1:n-1)./normal_2(n);
dummy = [dummy, dummy*normal_2+1+noise(col+1:2*col)];
data =  [data;dummy];
 
dummy = randn(T - 2*col,n-1);
normal_3 = randn(n,1);
normal_3 = normal_3(1:n-1)./normal_3(n);
dummy = [dummy, dummy*normal_3+1+noise(2*col+1:end)];
data = [data;dummy];

group = l1_switch_detect(data,norm_used,epsilon);