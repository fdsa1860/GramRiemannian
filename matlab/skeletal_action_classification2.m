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
elseif dataset_idx == 5
    tr_info = load([directory, '/tr_te_splits']);
end

opt.tStart = tic;

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

loadname = [directory, '/features'];
data = load(loadname, 'features');

% opt.metric = 'JBLD';
% opt.metric = 'JBLD_denoise';
% opt.metric = 'binlong';
% opt.metric = 'AIRM';
% opt.metric = 'LERM';
% opt.metric = 'KLDM';
opt.metric = 'SubspaceAngle';

opt.H_structure = 'HHt';
opt.H_rows = 12;
opt.sigma = 0.01;
% opt.sigma = 0.25; % MSR parameter
opt.epsilon = 0.01;
opt.SA_thr = 0.5;

HH = getHH(data.features,opt);
% HH = getCov(data.features);
% HH_main = getHH_local(data.features);

results_dir = fullfile('..','expData','res');
if ~exist(results_dir,'dir')
    mkdir(results_dir);
end

if strcmp(datasets{dataset_idx}, 'UTKinect')
    action_UTKinect(HH,tr_info,labels,opt);
elseif strcmp(datasets{dataset_idx}, 'Florence3D')
    action_UTKinect(HH,tr_info,labels,opt);
elseif strcmp(datasets{dataset_idx}, 'MSRAction3D')
    action_MSR3D(HH,tr_info,labels,opt);
elseif strcmp(datasets{dataset_idx}, 'HDM05')
    action_HDM05(HH,tr_info,labels,opt);
end


end
