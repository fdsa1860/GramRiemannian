function action_UTKinect(HH, tr_info, labels, opt)

feat = HH;
% feat = getLogHH(HH);

total_preprocessingTime = toc(opt.tStart);

% uncomment if UTKinect and if use LOOCV protocol
n_tr_te_splits = 20;
all_subjects = kron(1:10,ones(1,2));
all_instances = kron(ones(1,10),[1 2]);
te_subjects = zeros(20,1);
tr_subjects = zeros(20,19);
te_instances = zeros(20,1);
tr_instances = zeros(20,19);
for i = 1:20
    te_subjects(i) = all_subjects(i);
    tr_subjects(i,:) = all_subjects(setdiff(1:20,i));
    te_instances(i) = all_instances(i);
    tr_instances(i,:) = all_instances(setdiff(1:20,i));
end

% n_tr_te_splits = size(tr_info.tr_subjects, 1);
% tr_subjects = tr_info.tr_subjects;
% te_subjects = tr_info.te_subjects;

subject_labels = labels.subject_labels;
action_labels = labels.action_labels;
instance_labels = labels.instance_labels;

results_dir = fullfile('..','expData','res');
if ~exist(results_dir,'dir')
    mkdir(results_dir);
end

% for set = 1:n_action_sets
    % for set = 3
    % for set = 1:10 % uncomment if UCF
    
    %     rng(set); % uncomment if UCF
    %     n_tr_te_splits = 4; % uncomment if UCF
    %     indices = crossvalind('Kfold',length(action_labels), n_tr_te_splits); % uncomment if UCF
    
        unique_classes = unique(action_labels);%  comment if MSR
        n_classes = length(unique_classes);% comment if MSR
    
    % clustering
    %     clustering(HH(action_ind),n_classes,opt);
    
    total_accuracy = zeros(n_tr_te_splits, 1);
    cw_accuracy = zeros(n_tr_te_splits, n_classes);
    confusion_matrices = cell(n_tr_te_splits, 1);
    
    for si = 1:n_tr_te_splits
        fprintf('Processing %d/%d ...\n',si,n_tr_te_splits);
        
        tr_subject_ind = ismember(subject_labels, tr_subjects(si,:));
        te_subject_ind = ismember(subject_labels, te_subjects(si,:));
        tr_instance_ind = ismember(instance_labels, tr_instances(si,:)); % comment if not UTkinect
        te_instance_ind = ismember(instance_labels, te_instances(si,:)); % comment if not UTkinect
        tr_ind = (tr_instance_ind & tr_subject_ind); % comment if not UTkinect
        te_ind = (te_instance_ind & te_subject_ind); % comment if not UTkinect
%         tr_ind = tr_subject_ind; % comment if MSR or UTkinect
%         te_ind = te_subject_ind; % comment if MSR or UTkinect
        
        % [total_accuracy(si), cw_accuracy(si,:), confusion_matrices{si}] =...
        %     vladClassify(data, tr_ind, te_ind, opt);
        
%         X_train = HH(tr_ind);
        X_train = feat(:,tr_ind);
        nTrain = length(X_train);
        y_train = action_labels(tr_ind);
%         X_test = HH(te_ind);
        X_test = feat(:,te_ind);
        nTest = length(X_test);
        y_test = action_labels(te_ind);
        
        % train NN
        [predicted_labels,~,time] = nn(X_train, y_train, X_test, opt);

%         C_val = 1;
%         [total_accuracy(si), cw_accuracy(si,:), confusion_matrices{si}] = svm_one_vs_all(X_train, X_test,y_train, y_test, C_val);
        
        %         % test KNN
        %         predicted_labels = knn(X_train, y_train, X_test, opt);
        
        total_accuracy(si) = nnz(y_test==predicted_labels)/ length(y_test);
%         unique_classes = unique(y_test);
%         n_classes = length(unique_classes);
        class_wise_accuracy = zeros(1, n_classes);
        confusion_matrix = zeros(n_classes, n_classes);
        for i = 1:n_classes
            temp = find(y_test == unique_classes(i));
            if ~isempty(temp)
                class_wise_accuracy(i) =...
                    nnz(predicted_labels(temp)==unique_classes(i)) / length(temp);
                confusion_matrix(i, :) = ...
                    hist(predicted_labels(temp), unique_classes) / length(temp);
            else
                class_wise_accuracy(i) = 1;
                confusion_matrix(i, i) = 1;
            end
        end
        cw_accuracy(si,:) = class_wise_accuracy;
        confusion_matrices{si} = confusion_matrix;
        trainTime(si) = time.trainTime;
        testTime(si) = time.testTime;
        
        %         % SVM
        %         D1 = HHdist(HH_center,X_train,opt.metric);
        %         D2 = HHdist(HH_center,X_test,opt.metric);
        %         [total_accuracy(si), cw_accuracy(si,:), confusion_matrices{si}] =...
        %             svm_one_vs_all(D1, D2, y_train, y_test, C_val);
        
        
        %         nJoints = length(HH_main);
        %         centers(1:nJoints) = struct('HH_center',[],'param',[]);
        %         for di = 1:nJoints
        %
        %             HH = HH_main{di};
        %             X_train = HH(tr_ind);
        %             y_train = action_labels(tr_ind);
        %
        %             cparams(1:n_classes) = struct ('alpha',0,'theta',0);
        %             HH_center = cell(1,n_classes);
        %             for j=1:length(HH_center)
        %                 if nnz(y_train==actions(j))>1
        %                     HH_center{j} = karcher(X_train{y_train==actions(j)});
        %                 elseif nnz(y_train==actions(j))==1
        %                     HH_center{j} = X_train{y_train==actions(j)};
        %                 elseif nnz(y_train==actions(j))==0
        %                     error('cluster is empty.\n');
        %                 end
        %                 d = HHdist(HH_center(j),X_train(y_train==actions(j)),'JLD');
        %                 d(abs(d)<1e-6) = 1e-6;
        %                 param = gamfit(d);
        %                 cparams(j).alpha = min(100,param(1));
        %                 if isinf(cparams(j).alpha), keyboard; end
        %                 cparams(j).theta = max(0.01,param(2));
        %             end
        %
        %             centers(di).HH_center = HH_center;
        %             centers(di).cparams = cparams;
        %
        %         end
        %
        %         hFeat = zeros(nJoints, n_classes, nnz(te_ind));
        %         for di = 1:nJoints
        %
        %             HH = HH_main{di};
        %             X_test = HH(te_ind);
        %             y_test = action_labels(te_ind);
        %
        %             HH_center = centers(di).HH_center;
        %             cparams = centers(di).cparams;
        %             D2 = HHdist(HH_center,X_test,opt.metric);
        %             for ci=1:n_classes
        %                 hFeat(di,ci,:) = gampdf(D2(ci,:),cparams(ci).alpha,cparams(ci).theta);
        %                 hFeat(di,ci,:) = D2(ci,:);
        %             end
        %
        %         end
        %
        %         [~,ind] = min(squeeze(sum(hFeat)));
        %         predicted_labels = actions(ind);
        %         total_accuracy(si) = nnz(y_test==predicted_labels)/ length(y_test);
        %
        %         % scale data
        %         mx = max(hFeat,[],2); mn = min(hFeat,[],2);
        %         hFeat = bsxfun(@rdivide,bsxfun(@minus,hFeat,(0.5*mx+0.5*mn)),0.5*mx-0.5*mn);
        %
        %         X_train = hFeat(:,tr_ind);
        %         y_train = action_labels(tr_ind);
        %         X_test = hFeat(:,te_ind);
        %         y_test = action_labels(te_ind);
        %
        %         [total_accuracy(si), cw_accuracy(si,:), confusion_matrices{si}] =...
        %             svm_one_vs_all(X_train,...
        %             X_test, y_train, y_test, C_val);
        
    end
    
    avg_total_accuracy = mean(total_accuracy);
    avg_cw_accuracy = mean(cw_accuracy);
    
    avg_confusion_matrix = zeros(size(confusion_matrices{1}));
    for j = 1:length(confusion_matrices)
        avg_confusion_matrix = avg_confusion_matrix + confusion_matrices{j};
    end
    avg_confusion_matrix = avg_confusion_matrix / length(confusion_matrices);
    total_trainTime = sum(trainTime);
    total_testTime = sum(testTime);
    total_runtime = toc(opt.tStart);
    
    save ([results_dir, '/classification_results.mat'],...
        'total_accuracy', 'cw_accuracy', 'avg_total_accuracy',...
        'avg_cw_accuracy', 'confusion_matrices', 'avg_confusion_matrix',...
        'total_trainTime','total_testTime','total_preprocessingTime',...
        'total_runtime');
    
%     save ([results_dir, '/classification_results.mat'],...
%         'total_accuracy', 'cw_accuracy', 'avg_total_accuracy',...
%         'avg_cw_accuracy', 'confusion_matrices', 'avg_confusion_matrix');
    
% end % comment if MSR OR UCF