% sythetic test


r(1, :) = [1 -0.3 0.3 ];
r(2, :) = [0.5 -0.3 0.8];
r(3, :) = [0.7 -0.2 0.5];
r(4, :) = [0.7 0.2 0.1];

rng('default');
n = 1000;
d = 20;
N = n*size(r, 1);
data = zeros(d, N);
data(1:3, :) = randn(3, N);
for i = 1:size(r,1)
    ind = (i-1)*1000+1:i*1000;
    for j = 4:d
        data(j,ind) = r(i,:) * data(j-3:j-1,ind);
    end
end
data = data + 0.1*randn(d, N);

tic
D = zeros(N);
for i = 1:N
    for j = i:N
        D(i,j) = JLDistance(data(:,i),data(:,j),10);
    end
end
D = D + D';
toc

tic
D2 = zeros(N);
for i = 1:N
    for j = i:N
        D2(i,j) = hankeletAngle(data(:,i),data(:,j));
    end
end
D2 = D2 + D2';
toc

%% plot
ind1 = 1001:2000;
ind2 = 2001:3000;
scale = 0:0.1:10;
% M = D2/0.1;
M = D;
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