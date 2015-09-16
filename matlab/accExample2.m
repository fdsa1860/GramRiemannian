
%% accExample2

clear;clc;close all;

addpath(genpath('../matlab'));
addpath(genpath('../3rdParty'));

load ../expData/MHAD_data_whole;

%% NN
Hsize = 105*4;
opt.metric='JLD';
opt.H_structure = 'HHt';
opt.sigma = 0.2;
opt.epsilon = 1e-6;
HH = cell(1,length(data));
for i=1:length(data)
    t = diff(data{i},[],2);
    if strcmp(opt.H_structure,'HtH')
        nc = Hsize;
        nr = size(t,1)*(size(t,2)-nc+1);
        if nr<1, error('hankel size is too large.\n'); end
        Ht = hankel_mo(t,[nr nc]);
        HHt = Ht' * Ht;
    elseif strcmp(opt.H_structure,'HHt')
        nr = floor(Hsize/size(t,1))*size(t,1);
        nc = size(t,2)-floor(nr/size(t,1))+1;
        if nc<1, error('hankel size is too large.\n'); end
        Ht = hankel_mo(t,[nr nc]);
        HHt = Ht * Ht';
    end
    HHt = HHt / norm(HHt,'fro');
    %     HHt = t * t';
%     I = opt.sigma * eye(size(HHt));
%     HH{i} = HHt + I;
    HH{i} = HHt;
end

index = [1 2+55 19 20+55 24 25+55];
groundtruth = label_act(index);
D = zeros(length(index), length(index));
for i = 1:length(index)
    for j = 1:length(index)
        D(i,j) = gramDist_cccp(pcaClean(HH{index(i)}), HH{index(j)}, opt);
    end
end
D
groundtruth

% % get centers
% X_train = HH(1:329);
% y_train = label_act(1:329);
% X_test = HH(330:end);
% y_test = label_act(330:end);
% unique_classes = unique(label_act);
% n_classes = length(unique_classes);
% HH_center = cell(1, n_classes);
% for i = 1:n_classes
%     X_tmp = X_train(y_train==unique_classes(i));
%     HH_center{i} = karcher(X_tmp{1:end});
%     fprintf('processed %d/%d\n',i,n_classes);
% end
% % test
% D2 = HHdist(HH_center,X_test,opt.metric);
% [~,ind] = min(D2);
% predicted_labels = unique_classes(ind);
% accuracy = nnz(y_test==predicted_labels)/ length(y_test);
% accuracy
