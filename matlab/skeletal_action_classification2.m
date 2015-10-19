function [] = skeletal_action_classification2(dataset_idx, feature_idx)

dbstop if error

addpath(genpath('../3rdParty'))
addpath(genpath('.'))
addpath(genpath('../skeleton_data'))

feature_types = {'absolute_joint_positions', 'relative_joint_positions',...
    'joint_angles_quaternions', 'SE3_lie_algebra_absolute_pairs',...
    'SE3_lie_algebra_relative_pairs', 'JLD'};

if (feature_idx > 6)
    error('Feature index should be less than 6');
end

datasets = {'UTKinect', 'Florence3D', 'MSRAction3D', 'UCF'};

if (dataset_idx > 4)
    error('Dataset index should be less than 3');
end


% All the action sequences in a dataset are interpolated to have same
% length. 'desired_frames' is the reference length.
if (strcmp(datasets{dataset_idx}, 'UTKinect'))
    desired_frames = 74;
    
elseif (strcmp(datasets{dataset_idx}, 'Florence3D'))
    desired_frames = 35;
    
elseif (strcmp(datasets{dataset_idx}, 'MSRAction3D'))
    desired_frames = 76;
    
elseif (strcmp(datasets{dataset_idx}, 'UCF'))
    desired_frames = 76;
    
else
    error('Unknown dataset')
end


directory = [datasets{dataset_idx}, '_experiments/', feature_types{feature_idx}];
mkdir(directory)


% Training and test subjects
if dataset_idx<4
tr_info = load(['../skeleton_data/', datasets{dataset_idx}, '/tr_te_splits']);
n_tr_te_splits = size(tr_info.tr_subjects, 1);
tr_subjects = tr_info.tr_subjects;
te_subjects = tr_info.te_subjects;
end

% uncomment if UTKinect and if use LOOCV protocol
% if dataset_idx==1
%     n_tr_te_splits = 20;
%     all_subjects = kron(1:10,ones(1,2));
%     all_instances = kron(ones(1,10),[1 2]);
%     te_subjects = zeros(20,1);
%     tr_subjects = zeros(20,19);
%     te_instances = zeros(20,1);
%     tr_instances = zeros(20,19);
%     for i = 1:20
%         te_subjects(i) = all_subjects(i);
%         tr_subjects(i,:) = all_subjects(setdiff(1:20,i));
%         te_instances(i) = all_instances(i);
%         tr_instances(i,:) = all_instances(setdiff(1:20,i));
%     end
% end

if dataset_idx==3
    action_sets = tr_info.action_sets;
    n_action_sets = length(action_sets);
end

%% Skeletal representation
disp ('Generating skeletal representation')
if (~exist([directory '/features.mat'],'file'))
generate_features(directory, datasets{dataset_idx}, feature_types{feature_idx}, desired_frames);
end

%% JLD
disp ('JLD dictionary')
if dataset_idx==1 || dataset_idx==4
    labels = load([directory, '/labels'], 'action_labels', 'subject_labels','instance_labels');
else
    labels = load([directory, '/labels'], 'action_labels', 'subject_labels');
end
subject_labels = labels.subject_labels;
action_labels = labels.action_labels;
% instance_labels = labels.instance_labels; % comment if MSR

loadname = [directory, '/features'];
data = load(loadname, 'features');

opt.metric = 'JLD';
% opt.metric = 'JLD_denoise';
% opt.metric = 'binlong';
% opt.metric = 'AIRM';
opt.H_structure = 'HHt';
opt.sigma = 0.01;
% opt.sigma = 0.25; % MSR parameter
opt.epsilon = 1;

HH = getHH(data.features,opt);
% HH_main = getHH_local(data.features);

% % correct data, uncomment this section if MSR if you want corrected data
% load o;
% [newFeat,newHH,newSub,newAct] = getNewHH(o,opt);
% data.features = [data.features; newFeat];
% HH = [HH, newHH];
% subject_labels = [subject_labels; newSub];
% action_labels = [action_labels; newAct];
% data.features(action_labels==20) = [];
% HH(action_labels==20) = [];
% subject_labels(action_labels==20) = [];
% action_labels(action_labels==20) = [];

k = 4;
C_val = 1e-2;
results_dir = fullfile('..','expData','res');
for set = 1:n_action_sets % uncomment if MSR
% for set = 3
% for set = 1:10 % uncomment if UCF
    
    actions = unique(action_sets{set}); % uncomment if MSR
%     actions = setdiff(actions,20); % uncomment if MSR
    n_classes = length(actions); % uncomment if MSR
    action_ind = ismember(action_labels, actions); % uncomment if MSR

%     rng(set); % uncomment if UCF
%     n_tr_te_splits = 4; % uncomment if UCF
%     indices = crossvalind('Kfold',length(action_labels), n_tr_te_splits); % uncomment if UCF

%     actions = unique(action_labels);%  comment if MSR
%     n_classes = length(unique(actions));% comment if MSR

    % clustering
%     clustering(HH(action_ind),n_classes,opt);
    
    total_accuracy = zeros(n_tr_te_splits, 1);
    cw_accuracy = zeros(n_tr_te_splits, n_classes);
    confusion_matrices = cell(n_tr_te_splits, 1);
    
    for si = 1:n_tr_te_splits
        fprintf('Processing %d/%d ...\n',si,n_tr_te_splits);
        
        tr_subject_ind = ismember(subject_labels, tr_subjects(si,:));
        te_subject_ind = ismember(subject_labels, te_subjects(si,:));
%         tr_instance_ind = ismember(instance_labels, tr_instances(si,:)); % comment if not UTkinect
%         te_instance_ind = ismember(instance_labels, te_instances(si,:)); % comment if not UTkinect
%         tr_ind = (tr_instance_ind & tr_subject_ind); % comment if not UTkinect
%         te_ind = (te_instance_ind & te_subject_ind); % comment if not UTkinect
%         tr_ind = ~te_ind;
        tr_ind = (action_ind & tr_subject_ind); % comment if not MSR
        te_ind = (action_ind & te_subject_ind); % comment if not MSR
%         tr_ind = tr_subject_ind; % comment if MSR or UTkinect
%         te_ind = te_subject_ind; % comment if MSR or UTkinect
%         tr_ind = find(indices~=si); % comment if not UCF
%         te_ind = find(indices==si); % comment if not UCF
        
        % slide window
        numWords = 20;
        noiseBound = 2;
%         [feat_tr,fl_tr] = chopFeature(data.features(tr_ind));
%         [feat_tr,fl_tr] = breakFeature(data.features(tr_ind));
        [feat_tr,fl_tr] = breakFeature2(data.features(tr_ind));
%         [feat_tr, fl_tr] = filterStaticData(feat_tr, fl_tr, noiseBound);
        HH_tr = getHH(feat_tr, opt);
%         [label,HH_centers,sD,cparams] = ncutJLD(HH_tr,numWords,opt);
        tic
        [label,HH_centers,sD] = kmeansJLD(HH_tr,numWords,opt);
        toc
%         feat_tr = bowFeature(HH_centers, HH_tr, fl_tr, opt);
        feat_tr = vladFeature(HH_centers, HH_tr, fl_tr, opt);
%         [feat_te,fl_te] = chopFeature(data.features(te_ind));
%         [feat_te,fl_te] = breakFeature(data.features(te_ind));
        [feat_te,fl_te] = breakFeature2(data.features(te_ind));
%         [feat_te, fl_te] = filterStaticData(feat_te, fl_te, noiseBound);
        HH_te = getHH(feat_te,opt);
%         feat_te = bowFeature(HH_centers, HH_te, fl_te, opt);
        feat_te = vladFeature(HH_centers, HH_te, fl_te, opt);
        
        X_train = feat_tr;
        y_train = action_labels(tr_ind);
        X_test = feat_te;
        y_test = action_labels(te_ind);
        [total_accuracy(si), cw_accuracy(si,:), confusion_matrices{si}] =...
            svm_one_vs_all(X_train, X_test, y_train, y_test, C_val);

        X_train = HH(tr_ind);
        nTrain = length(X_train);
        y_train = action_labels(tr_ind);
        X_test = HH(te_ind);
        nTest = length(X_test);
        y_test = action_labels(te_ind);

        
        % train NN
        predicted_labels = nn(X_train, y_train, X_test, opt);

%         % test KNN
%         predicted_labels = knn(X_train, y_train, X_test, opt);

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
    
    save ([results_dir, '/classification_results_as', num2str(set), '.mat'],...
        'total_accuracy', 'cw_accuracy', 'avg_total_accuracy',...
        'avg_cw_accuracy', 'confusion_matrices', 'avg_confusion_matrix');
% end % comment if MSR OR UCF

end
