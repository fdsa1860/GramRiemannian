% generate data from coupled model

num_frame = 100;
dim = 2;
sys_ord = 2;
num_sample = 50;
num_sys = 2;
noiseLevel = 0.0;

% A{1} = [
%     -1.7343, 0, -1, 0;
%     0, -1.7343, 0, -1;
%     1, 0, 0, 0;
%     0, 1, 0, 0
%     ];
% A{2} = [
%     -0.3708, 0, -1, 0;
%     0, -0.3708, 0, -1;
%     1, 0, 0, 0;
%     0, 1, 0, 0
%     ];

A = cell(1, num_sys);
theta = rand(2, num_sys);
for i = 1:num_sys
    U = orth(rand(sys_ord*dim));
    Lambda = [
        cos(theta(1,1)) sin(theta(1,1)) 0 0
        -sin(theta(1,1)) cos(theta(1,1)) 0 0
        0 0 cos(theta(2,i)) sin(theta(2,i))
        0 0 -sin(theta(2,i)) cos(theta(2,i))
        ];
%     A{i} = U * Lambda * U';
    A{i} = U;
end

C = [
    1, 0, 0, 0;
    0, 1, 0, 0
    ];

data = cell(1, num_sample*num_sys);
for sysInd = 1:num_sys
    for spInd = 1:num_sample
        y0 = rand(dim, sys_ord);
        temp = fliplr(y0);
        x0 = temp(:);
        x = zeros(dim * sys_ord, num_frame);
        y = zeros(dim, num_frame);
        for i = 1:num_frame
            if i == 1
                x(:, i) = x0;
            else
                x(:, i) = A{sysInd} * x(:, i-1);
            end
            y(:, i) = C * x(:, i);
        end
        data{(sysInd-1)*num_sample+spInd} = y + noiseLevel*randn(size(y));
    end
end