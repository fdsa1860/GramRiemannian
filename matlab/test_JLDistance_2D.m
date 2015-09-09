% sythetic test

addpath(genpath('../matlab'));
addpath(genpath('../3rdParty'));

R(:, :, 1) = [1 -0.3; 0.3 1];
R(:, :, 2) = [0.5 -0.5; 0.8 0.1];
R(:, :, 3) = [0.7 -0.2; 0.5 0.4];
R(:, :, 4) = [0.7 0.2; 0.1 0.9];

rng('default');
n = 1000;
d = 20;
N = n*size(R, 3);
data = zeros(d, 2, N);
data(1, :, 1:N) = randn(1, 2, N);
for i = 1:size(R,3)
    ind = (i-1)*n+1:i*n;
    for j = 2:d
        for k = 1:length(ind)
            data(j,:,ind(k)) = (R(:,:,i) * data(j-1,:,ind(k))')';
        end
    end
end
data = data + 0.1*randn(d, 2, N);

tic
D = zeros(N);
for i = 1:N
    for j = i:N
        D(i,j) = JLDistance(data(:,:,i),data(:,:,j),4);
    end
end
D = D + D';
toc

tic
D2 = zeros(N);
for i = 1:N
    for j = i:N
        D2(i,j) = hankeletAngle(data(:,:,i),data(:,:,j));
    end
end
D2 = D2 + D2';
toc

tic
D3 = zeros(N);
for i = 1:N
    for j = i:N
        D3(i,j) = JLDistance(data(:,:,i),data(:,:,j),3);
    end
end
D3 = D3 + D3';
toc

%% plot
ind1 = 2001:3000;
ind2 = 3001:4000;
scale = 0:0.1:10;
% M = D2/0.1;
M = D3;
A1 = M(ind1,ind1);
A2 = M(ind2,ind2);
A12 = M(ind1,ind2);
h1 = hist(A1(:),scale);
h2 = hist(A2(:),scale);
h12 = hist(A12(:),scale);
plot(scale,h1,'b');
hold on;
plot(scale,h2,'g');
plot(scale,h12,'r');
hold off;