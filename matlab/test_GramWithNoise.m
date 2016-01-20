% test Gram matrix with noise

addpath(genpath('../matlab'));
addpath(genpath('../3rdParty'));

rng('default');
data_generation;
data_clean = data;
d = num_frame;
N = num_sample * num_sys;
nc = 30;
Hsize = 30;
% opt.metric = 'binlong';
% opt.metric = 'AIRM';
% opt.metric = 'LERM';
opt.metric = 'JBLD';
% opt.metric = 'KLDM';
opt.sigma = 1e-2;
e = 0;
s = 1e-2;

% s = 10.^(-10:0);
e = 0:0.1:2;
d = zeros(length(s), length(e));
for m = 1:length(s)
for k = 1:length(e);
% for k = 1;
    
    fprintf('Processing %d/%d ...\n',k,length(e));
    opt.sigma = s(m);
    
    data = data_clean + e(k)*noise_data;
    testData = data(1:2,:);
    
    HH = cell(1, size(testData,1));
    for i = 1:size(testData, 1)
        t = testData(i, :);
        nr = floor(Hsize/size(t,1))*size(t,1);
        nc = size(t,2)-floor(nr/size(t,1))+1;
        if nc<1, error('hankel size is too large.\n'); end
        H1 = hankel_mo(t, [nr, nc]);
        HH1 = H1 * H1';
        HH1 = HH1 / norm(HH1,'fro');
        if strcmp(opt.metric,'AIRM') || strcmp(opt.metric,'LERM')...
                || strcmp(opt.metric,'KLDM') || strcmp(opt.metric,'JBLD')
            HH{i} = HH1 + opt.sigma * eye(nr);
        elseif strcmp(opt.metric,'binlong')
            HH{i} = HH1;
        end
    end
    
    d(m,k) = HHdist(HH(1),HH(2),opt);
end
end

% semilogx(s,d,'*');
% xlabel('regularization value \sigma');
% ylabel('JBLD distance between two instances from same model');
% title('the intra-class distance VS regularization value');

plot(e,d,'*');
xlabel('Noise standard deviation \epsilon');
ylabel('JBLD distance between two instances from same model');
title('Intra-class distance VS noise amplitude');