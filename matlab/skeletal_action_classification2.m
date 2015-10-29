function [] = skeletal_action_classification2(dataset_idx, feature_idx)

dbstop if error

addpath(genpath('../3rdParty'))
addpath(genpath('.'))
addpath(genpath('../skeleton_data'))

feature_types = {'JLD'};

if nargin < 2
    feature_idx = 1;
end

if (feature_idx > 1)
    error('Feature index should be less than 6');
end

datasets = {'UTKinect', 'Florence3D', 'MSRAction3D', 'UCF', 'HDM05'};

if (dataset_idx > 5)
    error('Dataset index should be less than 5');
end

if ~strcmp(datasets{dataset_idx}, 'UTKinect') && ...
        ~strcmp(datasets{dataset_idx}, 'Florence3D') && ...
        ~strcmp(datasets{dataset_idx}, 'MSRAction3D') && ...
        ~strcmp(datasets{dataset_idx}, 'UCF') && ...
        ~strcmp(datasets{dataset_idx}, 'HDM05')
    error('Unknown dataset')
end

directory = [datasets{dataset_idx}, '_experiments/', feature_types{feature_idx}];
mkdir(directory)

% Training and test subjects
if dataset_idx<5
    tr_info = load(['../skeleton_data/', datasets{dataset_idx}, '/tr_te_splits']);
    n_tr_te_splits = size(tr_info.tr_subjects, 1);
    tr_subjects = tr_info.tr_subjects;
    te_subjects = tr_info.te_subjects;
elseif dataset_idx == 5
    tr_info = load([directory, '/tr_te_splits']);
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

%% Skeletal representation
disp ('Generating skeletal representation')
% if (~exist([directory '/features.mat'],'file'))
    generate_features(directory, datasets{dataset_idx}, feature_types{feature_idx});
% end

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

% opt.metric = 'JLD';
% opt.metric = 'JLD_denoise';
% opt.metric = 'binlong';
opt.metric = 'AIRM';
% opt.metric = 'LERM';
% opt.metric = 'KLDM';
opt.H_structure = 'HHt';
opt.H_rows = 3;
opt.sigma = 0.25;
% opt.sigma = 0.25; % MSR parameter
opt.epsilon = 0.1;

HH = getHH(data.features,opt);
% HH_main = getHH_local(data.features);

k = 4;
C_val = 1e-2;
results_dir = fullfile('..','expData','res');
if ~exist(results_dir,'dir')
    mkdir(results_dir);
end

if strcmp(datasets{dataset_idx}, 'MSRAction3D')
    action_MSR3D(HH,tr_info,labels,opt);
elseif strcmp(datasets{dataset_idx}, 'HDM05')
    action_HDM05(HH,tr_info,labels,opt);
end


end
