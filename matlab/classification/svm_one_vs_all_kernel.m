function [final_predicted_labels, time] =...
    svm_one_vs_all_kernel(X_train, X_test,...
    y_train, y_test, C_val, opt)

time.trainTime = 0;
time.testTime = 0;
tStart = tic;

scale = 0.5;
D1 = HHdist(X_train, [], opt);
sig = max(max(D1)) / scale;
K1 = exp(-D1/sig);
time.trainTime = time.trainTime + toc(tStart); tStart = tic;

D2 = HHdist(X_test, X_train, opt);
K2 = exp(-D2/sig);
time.testTime = time.testTime + toc(tStart); tStart = tic;

model = svmtrain(y_train,[(1:length(y_train))', K1],sprintf('-t 4 -c %d -b 1 -q',C_val));
[final_predicted_labels, ~, prob] = svmpredict(y_test, [(1:length(y_test))', K2], model, '-b 1 -q');


% unique_classes = unique(y_train);
% n_classes = length(unique_classes);
% n_test_samples = length(y_test);
% svmModel = cell(1,n_classes);
% test_prediction_prob = zeros(n_classes, length(y_test));
% for i=1:n_classes
%     y_train2 = y_train;
%     y_train2(y_train==unique_classes(i)) = 1;
%     y_train2(y_train~=unique_classes(i)) = -1;
%     class_imbalance_ratio = nnz(y_train2==-1) / nnz(y_train2==1);
%     model = svmtrain(y_train2,[(1:length(y_train))', K1],sprintf('-t 4 -c %d -w1 %f -b 1 -q',C_val,class_imbalance_ratio));
%     time.trainTime = time.trainTime + toc(tStart); tStart = tic;
%     [~, ~, prob] = svmpredict(y_test, [(1:length(y_test))', K2], model, '-b 1 -q');
%     test_prediction_prob(i,:) = prob(:,1)';
%     svmModel{i} = model;
%     time.testTime = time.testTime + toc(tStart); tStart = tic;
% end

% [~, ind] = max(test_prediction_prob);
% final_predicted_labels = unique_classes(ind);

end