% gamma

clc;clear;

addpath(genpath('../../matlab'));
addpath(genpath('../../3rdParty'));

rng('default');
data_generation;
n = 500;
d = num_frame;
N = n * num_sys;

data = data + 0*randn(size(data));

trainData = [];
testData = [];
for i = 1:num_sys
    trainData = [trainData data(index_train(:,1)+(i-1)*n,:)'];
    testData = [testData data(index_test(:,1)+(i-1)*n,:)'];
end

opt.metric = 'JLD';
% opt.metric = 'binlong';

%% training
nc = 4;
HH = cell(1,size(trainData,2));
for i = 1:size(trainData,2)
    H1 = hankel_mo(trainData(:,i)',[d-nc+1, nc]);
    HH1 = H1' * H1;
    HH1 = HH1 / norm(HH1,'fro');
    if strcmp(opt.metric,'JLD')
        HH{i} = HH1 + 1e-6 * eye(nc);
%         HH{i} = HH1;
    elseif strcmp(opt.metric,'binlong')
        HH{i} = HH1;
    end
end
G = HH;

k = 6;
rng('default');
ind = randsample(length(G),k);
prior_init = 1/k;
Gm_init = zeros(size(G));
alpha_init = 1;
theta_init = 0.1;

cparams(1:k) = struct ('prior',prior_init,'Gm',Gm_init,'alpha',alpha_init,'theta',theta_init);
for i = 1:k
    cparams(i).Gm = G(ind(i));
end

[label,G_center] = kmeansJLD(G,k,opt);
D2 = HHdist(G_center, G, opt.metric);
for i = 1:k
    cparams(i).Gm = G_center(i);
    cparams(i).prior = nnz(label==i)/length(G);
    param = gamfit(D2(i,label==i));
    cparams(i).alpha = param(1);
    cparams(i).theta = param(2);
end

pre_log_lkhd = 0;
log_lkhd = 0;
log_lkhd1 = 0;
iter = 1;
while abs(log_lkhd - pre_log_lkhd) >= 1e-3 * abs(log_lkhd-log_lkhd1) && iter<70
    fprintf('iter %d ...\n',iter);
    pre_log_lkhd = log_lkhd;
    ez = e_step(G, k, cparams, opt);        % e step
    cparams = m_step(G, ez, cparams, opt);  % m step
    log_lkhd = lg_lkhd_gamma(G, k, cparams, opt); % log likelihood
    if iter==1
        log_lkhd1 = log_lkhd;
    end
    iter = iter + 1;
%     if k==3     % if m=true k, plot log likelihood versus number of iteration
        figure(15);
        hold on;
        plot(iter,log_lkhd,'bx');
        xlabel('number of iterations');
        ylabel('log likelihood');
        title('gamma mix log likelihood');
        hold off;
%     end
end

ez = e_step(G, k, cparams, opt);
[~,label] = max(ez);

%% eval
gt = kron(1:num_sys,ones(1,unit_train));
% gt = kron(1:num_sys,ones(1,unit_test));
v = perms(1:num_sys);
acc = zeros(1,size(v,1));
for i = 1:length(acc)
    acc(i) = nnz(v(i,label)==gt)/length(gt);
end
[precision,ind] = max(acc);
precision
label = v(ind,label);

M = confusionmat(gt,label)/unit_train;
% M = confusionmat(gt,label)/unit_test;

%% display
figure(1);
plotConfusionMatrix(M);
xlabel('predicted labels');
ylabel('groundtruth');

%% show distance distribution
D3 = HHdist(cparams(5).Gm,G,'JLD');
% hist(D3);
plot(D3);