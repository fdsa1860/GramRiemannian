
clear
%% Data generation

num_sys = 6; % number of systems
sys_ord = [2 2 3 3 4 4]; % order for each system, minimum 2
num_frame = 100; % time length for each sample
num_sample = 500; % number of samples per system
num_fold = 5; % cross validation
num_MAXrandpro = 1000;
num_Hcol = 10;%floor((num_frame + 1)/2);

data = {};
sys_par = {};
label = ones(num_sys*num_sample,1);

unit_train = num_sample/num_fold;
unit_test = num_sample - unit_train;
index_train = zeros(unit_train,num_fold);
index_test = zeros(unit_test,num_fold);
randpro = zeros(num_MAXrandpro,num_Hcol);

%% System Generation
theta = (rand(num_sys,1))*2*pi; %
for i = 1:num_sys
%     x = rand(sys_ord(i)-2,1);
    if sys_ord(i)==2 || sys_ord(i)==3
        x = rand(sys_ord(i)-2,1);
    elseif sys_ord(i)==4
        theta2 = 0.3;
        x = [cos(theta2)+1i*sin(theta2);cos(theta2)-1i*sin(theta2)];
    end
    p = [cos(theta(i))+1i*sin(theta(i));cos(theta(i))-1i*sin(theta(i));x(:)]; % two complex poles and the rest are real poles
    null{i} = -fliplr(poly([p; rand(num_Hcol-1-sys_ord(i),1)]')); % null space for each system, depends on the number of hankel colomns
    p = -fliplr(poly(p'));
    sys_par{i} = p;
end

    
%% Data Generation
noise_data = randn(num_sys*num_sample,num_frame);
data = zeros(num_sys*num_sample,num_frame);

for k=1:num_sys
    temp_data = zeros(num_sample,num_frame);
    initial_value = [];
    for i = 1:num_sample
        initial_value(i,:) = rand(sys_ord(k),1)-0.5;
        output_value(1:sys_ord(k),1) = initial_value(i,:);
        for j = sys_ord(k)+1:num_frame
            output_value(j,1) = sys_par{k}(1:end-1)*output_value(j-sys_ord(k):j-1,1);
        end
        output_value = output_value/max(abs(output_value));
        temp_data(i,:) = output_value;
    end
    data(num_sample*(k-1)+1:num_sample*k,:) = temp_data;
    label((k-1)*num_sample+1:k*num_sample) = ones(num_sample,1)*k;
end



%% Generate random projection parameters 
temp_randpro = randn(num_MAXrandpro,num_Hcol);
randpro = temp_randpro./repmat(sum(temp_randpro.^2,2),1,num_Hcol);
temp_randpro = randn(num_MAXrandpro,num_Hcol*2);
randpro_2 = temp_randpro./repmat(sum(temp_randpro.^2,2),1,num_Hcol*2);
%% Generate random index
temp_index = randperm(500)';
for i = 1:num_fold
    index_train(:,i) = temp_index(unit_train*(i-1)+1:unit_train*i);
    index_test(:,i) = [temp_index(1:unit_train*(i-1));temp_index(unit_train*i+1:end)];
end






