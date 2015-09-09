% sythetic test

addpath(genpath('../matlab'));
addpath(genpath('../3rdParty'));

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
% data(1:3, :) = rand(3, N);
for i = 1:size(r,1)
    ind = (i-1)*n+1:i*n;
    for j = 4:d
        data(j,ind) = r(i,:) * data(j-3:j-1,ind);
    end
end
data = data + 0.1*randn(d, N);

%%
nc = 4;
HH = cell(1,n);
for i = 1:n
H1 = hankel_mo(data(:,i+0*n)',[d-nc+1, nc]);
% H2 = hankel_mo(seg2',[size(seg2,1)-nc+1, nc]);

H1_p = H1 / (norm(H1*H1','fro')^0.5);
% H2_p = H2 / (norm(H2*H2','fro')^0.5);

HH1 = H1_p' * H1_p;
% HH2 = H2_p' * H2_p;

HH{i} = HH1;
end

% tic;
% % HH_kracher = karchermean(HH);
% HH_kracher = karcher(HH{1:n});
% toc;

tic
D = zeros(1,n);
for i = 1:n
        D(i) = log(det((HH{i}+HH_kracher)/2)) - 0.5*log(det(HH{i}*HH_kracher));
end
toc

%% KL Distances between kratcher means
D_karcher = zeros(4);
for i = 1:4
    for j = i+1:4
        D_karcher(i,j) = log(det((K{i}+K{j})/2)) - 0.5*log(det(K{i}*K{j}));
    end
end
D_karcher = D_karcher + D_karcher';

%% plot
scale = 0:0.1:7;
h1 = hist(D1,scale);
h2 = hist(D2,scale);
h3 = hist(D3,scale);
h4 = hist(D4,scale);
plot(scale,h1,'b');
hold on;
plot(scale,h2,'g');
plot(scale,h3,'r');
plot(scale,h4,'m');
hold off;

