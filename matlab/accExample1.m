addpath(genpath('../matlab'));
addpath(genpath('../3rdParty'));

rng('default');
acc_data_generation;
data_clean = data;
n = 500;
d = num_frame;
N = n * num_sys;
nr = 10;
opt.metric = 'JLD';
% opt.metric = 'binlong';
opt.sigma = 1e-3;
% opt.sigma = 0;
opt.epsilon = 1e-2;

e = 1e-1;
data = data_clean + e * noise_data;


y1 = data(1001,:);
Hy1 = hankel_mo(y1,[nr, length(y1)-nr+1]);
HHy1 = Hy1 * Hy1';
HHy1 = HHy1 / norm(HHy1,'fro');
y2 = data(1002,:);
Hy2 = hankel_mo(y2,[nr, length(y2)-nr+1]);
HHy2 = Hy2 * Hy2';
HHy2 = HHy2 / norm(HHy2,'fro');
y3 = data(2001,:);
Hy3 = hankel_mo(y3,[nr, length(y3)-nr+1]);
HHy3 = Hy3 * Hy3';
HHy3 = HHy3 / norm(HHy3,'fro');
y4 = data(2002,:);
Hy4 = hankel_mo(y4,[nr, length(y4)-nr+1]);
HHy4 = Hy4 * Hy4';
HHy4 = HHy4 / norm(HHy4,'fro');
y5 = data(2501,:);
Hy5 = hankel_mo(y5,[nr, length(y5)-nr+1]);
HHy5 = Hy5 * Hy5';
HHy5 = HHy5 / norm(HHy5,'fro');
y6 = data(2502,:);
Hy6 = hankel_mo(y6,[nr, length(y6)-nr+1]);
HHy6 = Hy6 * Hy6';
HHy6 = HHy6 / norm(HHy6,'fro');
y7 = data_clean(1001,:);
Hy7 = hankel_mo(y7,[nr, length(y7)-nr+1]);
HHy7 = Hy7 * Hy7';
HHy7 = HHy7 / norm(HHy7,'fro');

HH{1} = HHy1;HH{2} = HHy2;HH{3} = HHy3;
HH{4} = HHy4;HH{5} = HHy5;HH{6} = HHy6;

% HHy1_hat = pcaClean(HHy1);
% HHy4_hat = pcaClean(HHy4);
% y1_hat = hstlnClean(y1);

% dis = HHdist({HHy1_hat},{HHy2},opt.metric);
% [dis, Phi] = gramDist_cccp(HHy1_hat, HHy4, opt);

index = [1:6];
D = zeros(length(index), length(index));
for i = 1:length(index)
    for j = 1:length(index)
        D(i,j) = gramDist_cccp(pcaClean(HH{index(i)}), HH{index(j)}, opt);
    end
end
D

%%
sig = [1 0.5 0.1 0.01 1e-3 1e-4 1e-5 1e-6 1e-7];
D_sigma = zeros(1, length(sig));
for i = 1:length(sig)
    opt.sigma = sig(i);
    D_sigma(i) = gramDist_cccp(pcaClean(HH{1}), HH{6}, opt);
end
