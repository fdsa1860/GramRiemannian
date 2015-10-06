
addpath(genpath('../matlab'));
addpath(genpath('../3rdParty'));

rng('default');
acc_data_generation;
data_clean = data;
n = 500;
d = num_frame;
N = n * num_sys;
nr = 5;
opt.metric = 'JLD';
% opt.metric = 'binlong';
opt.sigma = 1e-3;
% opt.sigma = 0;
opt.epsilon = 100;

e = 1e-1;
data = data_clean + e * noise_data;

y1 = data(1001,:);
Hy1 = hankel_mo(y1,[nr, length(y1)-nr+1]);
HHy1 = Hy1 * Hy1';
HHy1 = HHy1 / norm(HHy1,'fro');

[D,Phi,cccp] = gramDist_cccp(HHy1, eye(size(HHy1)), opt);
D