function [] = skeletal_action_classification2(dataset_idx, feature_idx)

dbstop if error

addpath(genpath('../3rdParty'))
addpath(genpath('.'))
addpath(genpath('../skeleton_data'))

feature_types = {'normal','original'};
datasets = {'UTKinect', 'MHAD', 'MSRAction3D', 'HDM05'};

if nargin < 2
    feature_idx = 1;
end

if (feature_idx > length(feature_types))
    error('Feature index should be less or equal than %d\n',length(feature_types));
end

if (dataset_idx > length(datasets))
    error('Dataset index should be less than %d\n',length(datasets));
end

directory = fullfile('..','expData',datasets{dataset_idx}, feature_types{feature_idx});
mkdir(directory)

opt.tStart = tic;
generate_features(directory, datasets{dataset_idx}, feature_types{feature_idx});

% Training and test subjects
if strcmp(datasets{dataset_idx},'UTKinect') || strcmp(datasets{dataset_idx},'MSRAction3D') 
    tr_info = load(['../skeleton_data/', datasets{dataset_idx}, '/tr_te_splits']);
elseif strcmp(datasets{dataset_idx},'HDM05') || strcmp(datasets{dataset_idx},'MHAD')
    tr_info = load([directory, '/tr_te_splits']);
end

labels = load(fullfile(directory, 'labels'));
data = load(fullfile(directory, 'features'));

% opt.metric = 'JBLD';
% opt.metric = 'JBLD_denoise';
% opt.metric = 'binlong';
% opt.metric = 'AIRM';
% opt.metric = 'LERM';
opt.metric = 'KLDM';
% opt.metric = 'SubspaceAngle';
% opt.metric = 'SubspaceAngleFast';

opt.H_structure = 'HHt';
% opt.H_structure = 'HtH';
opt.H_rows = 5;
% opt.H_rows = 4; % UTKinect parameter, shortest video is 4 frames
opt.sigma = 0.0001;
% opt.epsilon = 0.01; % SubspaceAngle parameter
% opt.SA_thr = 0.5;   % SubspaceAngle parameter

featVel = getVelocity(data.features);
HH = getHH(featVel, opt);
% HH = getCov(data.features);
% HH_main = getHH_local(data.features);

results_dir = fullfile('..','expData','res');
if ~exist(results_dir,'dir')
    mkdir(results_dir);
end

if strcmp(datasets{dataset_idx}, 'UTKinect')
    action_UTKinect(HH,tr_info,labels,opt);
elseif strcmp(datasets{dataset_idx}, 'MHAD')
    action_MHAD(HH,tr_info,labels,opt);
elseif strcmp(datasets{dataset_idx}, 'MSRAction3D')
    action_MSR3D(HH,tr_info,labels,opt);
elseif strcmp(datasets{dataset_idx}, 'HDM05')
    action_HDM05(HH,tr_info,labels,opt);
else
    error('unknown dataset.\n')
end


end
