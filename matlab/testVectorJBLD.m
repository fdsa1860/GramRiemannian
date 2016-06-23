% testVectorJBLD

addpath(genpath('../matlab'));
addpath(genpath('../3rdParty'));

% rng(1);
% data_generation;

% d = 2;
% n = floor(num_sample/d);
% t = cell(1, n * num_sys);
% for si = 1:num_sys;
%     index = (si-1) * num_sample + 1;
%     for i = 1:n
%         ind = index + (i-1) * d;
%         t{(si-1)*n+i} = data(ind:ind+d-1, :) + 0*randn(size(data(ind:ind+d-1, :)));
%     end
% end
% gt = kron((num_sys-1:num_sys), ones(1,n));
rng(1);
data_generation_coupled;
gt = [ones(num_sample, 1); 2*ones(num_sample, 1)]';
t = data;

opt.H_structure = 'HHt';
% opt.H_structure = 'HtH';
opt.metric = 'JBLD';
% opt.metric = 'binlong';
opt.H_rows = 3;
opt.sigma = 1e-4;

HH = getHH(t, opt);

D = HHdist(HH, [], opt);

figure;imagesc(D); colorbar;
% imagesc(D(31:60,31:60)); colorbar;

label = ncutD(D, 2);

v = perms(1:num_sys);
acc = zeros(1,size(v,1));
for i = 1:length(acc)
    acc(i) = nnz(v(i,label)==gt)/length(gt);
end
[accuracy,ind] = max(acc);
% accuracy
label = v(ind,label);

% displayRes(label, gt);

fprintf('identification accuracy is %f\n', accuracy);