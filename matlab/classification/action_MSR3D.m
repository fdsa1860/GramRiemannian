function action_MSR3D(data, tr_info, labels, opt)

jointsVel = getVelocity(data.joints);
HH = getHH(jointsVel, opt);
feat = HH;
% feat = getLogHH(HH);

total_preprocessingTime = toc(opt.tStart);

n_tr_te_splits = size(tr_info.tr_subjects, 1);
tr_subjects = tr_info.tr_subjects;
te_subjects = tr_info.te_subjects;

% n_tr_te_splits = nchoosek(10,5);
% tr_subjects = nchoosek(1:10,5);
% te_subjects = flipud(tr_subjects);

% n_tr_te_splits = 1;
% tr_subjects = [1 2 3 4 5];
% te_subjects = [6 7 8 9 10];
% 
% n_tr_te_splits = 1;
% tr_subjects = [1 3 5 7 9];
% te_subjects = [2 4 6 8 10];

action_sets = tr_info.action_sets;
n_action_sets = length(action_sets);

subject_labels = labels.subject_labels;
action_labels = labels.action_labels;

results_dir = fullfile('..','expData','res');
if ~exist(results_dir,'dir')
    mkdir(results_dir);
end

for set = 1:n_action_sets
    % for set = 3
    
    actions = unique(action_sets{set}); % uncomment if MSR 3 sets
    n_classes = length(actions);        % uncomment if MSR 3 sets
    action_ind = ismember(action_labels, actions); % uncomment if MSR 3 sets
%     actions = unique(action_labels);%  % uncomment if use MSR all actions
%     n_classes = length(unique(actions));% % uncomment if use MSR all actions
    
    total_accuracy = zeros(n_tr_te_splits, 1);
    cw_accuracy = zeros(n_tr_te_splits, n_classes);
    confusion_matrices = cell(n_tr_te_splits, 1);
    trainTime = zeros(n_tr_te_splits, 1);
    testTime = zeros(n_tr_te_splits, 1);
    
    for si = 1:n_tr_te_splits
        fprintf('Processing %d/%d ...\n',si,n_tr_te_splits);
        
        tr_subject_ind = ismember(subject_labels, tr_subjects(si,:));
        te_subject_ind = ismember(subject_labels, te_subjects(si,:));
        %         tr_ind = ~te_ind;
        tr_ind = (action_ind & tr_subject_ind);
        te_ind = (action_ind & te_subject_ind);
%         tr_ind = tr_subject_ind; % uncomment if use MSR all actions
%         te_ind = te_subject_ind; % uncomment if use MSR all actions
        
        X_train = feat(:,tr_ind);
        y_train = action_labels(tr_ind);
        y_subject_train = subject_labels(tr_ind);
        X_test = feat(:,te_ind);
        y_test = action_labels(te_ind);
        
        % train NN
        [predicted_labels,~,time] = nn(X_train, y_train, X_test, opt);
        
        total_accuracy(si) = nnz(y_test==predicted_labels)/ length(y_test);
        unique_classes = unique(y_test);
        n_classes = length(unique_classes);
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
    

%     save ([results_dir, '/classification_results.mat'],...
%         'total_accuracy', 'cw_accuracy', 'avg_total_accuracy',...
%         'avg_cw_accuracy', 'confusion_matrices', 'avg_confusion_matrix',...
%         'total_trainTime','total_testTime','total_preprocessingTime',...
%         'total_runtime');

    save ([results_dir, '/classification_results_as', num2str(set), '.mat'],...
        'total_accuracy', 'cw_accuracy', 'avg_total_accuracy',...
        'avg_cw_accuracy', 'confusion_matrices', 'avg_confusion_matrix',...
        'total_trainTime','total_testTime','total_preprocessingTime',...
        'total_runtime');
    
end % comment if MSR OR UCF

total_runtime3 = toc(opt.tStart);
total_accuracy3 = 0;
total_trainTime3 = 0;
total_testTime3 = 0;
for i = 1:3
    load(fullfile('..','expData','res',sprintf('classification_results_as%d.mat',i)));
    total_accuracy3 = total_accuracy3 + avg_total_accuracy;
    total_trainTime3 = total_trainTime3 + total_trainTime;
    total_testTime3 = total_testTime3 + total_testTime;
end
avg_total_accuracy3 = total_accuracy3 / 3;
save ([results_dir, '/classification_results', '.mat'],...
    'avg_total_accuracy3','total_trainTime3','total_testTime3',...
    'total_preprocessingTime','total_runtime3');

end