addpath(genpath('../../matlab'));
addpath(genpath('../3rdParty'));

rng('default');
acc_data_generation;
data_clean = data;
n = 500;
d = num_frame;
N = n * num_sys;
nc = 10;
opt.metric = 'JLD';
% opt.metric = 'binlong';
opt.sigma = 1e-3;
% opt.sigma = 0;
e = 1e-1;

data = data_clean + e * noise_data;


y1 = data(2001,1:70);
Hy1 = hankel_mo(y1,[length(y1)-nc+1, nc]);
HHy1 = Hy1' * Hy1;
HHy1 = HHy1 / norm(HHy1,'fro');
y2 = data(2001,20:90);
Hy2 = hankel_mo(y2,[length(y2)-nc+1, nc]);
HHy2 = Hy2' * Hy2;
HHy2 = HHy2 / norm(HHy2,'fro');
y3 = data(2700,:);
Hy3 = hankel_mo(y3,[length(y3)-nc+1, nc]);
HHy3 = Hy3' * Hy3;
HHy3 = HHy3 / norm(HHy3,'fro');
y4 = data_clean(2001,1:70);
Hy4 = hankel_mo(y4,[length(y4)-nc+1, nc]);
HHy4 = Hy4' * Hy4;
HHy4 = HHy4 / norm(HHy4,'fro');

HHy1_hat = pcaClean(HHy1);
HHy4_hat = pcaClean(HHy4);
% y1_hat = hstlnClean(y1);

% dis = HHdist({HHy1_hat},{HHy2},opt.metric);
[dis, Phi] = gramDist_cccp(HHy1_hat,HHy4);
