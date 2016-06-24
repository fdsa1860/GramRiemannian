function [] = skeletal_action_classification(dataset_idx)

% skeletal_action_classification(dataset_idx)
% dataset_idx is set:
% 1 if UTKinect
% 2 if MHAD
% 3 if MSRAction3D
% 4 if HDM05

% dbstop if error

if nargin < 1
    msg = ['You need to input the dataset index. You may run function '...
        'help to see a list of the available datasets'];
    error(msg);
end

addpath(genpath('.'))
addpath(genpath('../3rdParty'))
addpath(genpath('../skeleton_data'))

datasets = {'UTKinect', 'MHAD', 'MSRAction3D', 'HDM05'};

if (dataset_idx > length(datasets))
    error('Dataset index should be less than %d\n',length(datasets));
end

directory = fullfile('..','expData',datasets{dataset_idx});
if ~exist(directory,'dir')
    mkdir(directory);
end

opt.tStart = tic;
generate_features(directory, datasets{dataset_idx});

% Training and testing subjects
if strcmp(datasets{dataset_idx},'UTKinect') || strcmp(datasets{dataset_idx},'MSRAction3D') 
    tr_info = load(['../skeleton_data/', datasets{dataset_idx}, '/tr_te_splits']);
elseif strcmp(datasets{dataset_idx},'HDM05') || strcmp(datasets{dataset_idx},'MHAD')
    tr_info = load([directory, '/tr_te_splits']);
end

labels = load(fullfile(directory, 'labels'));
data = load(fullfile(directory, 'joints'));

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

% opt.epsilon = 0.01; % SubspaceAngle parameter
% opt.SA_thr = 0.5;   % SubspaceAngle parameter

results_dir = fullfile('..','expData','res');
if ~exist(results_dir,'dir')
    mkdir(results_dir);
end

if strcmp(datasets{dataset_idx}, 'UTKinect')
    opt.H_rows = 4; % UTKinect parameter, shortest video is 4 frames
    opt.sigma = 0.01;
    action_UTKinect(data,tr_info,labels,opt);
elseif strcmp(datasets{dataset_idx}, 'MHAD')
    opt.H_rows = 5;
    opt.sigma = 0.0001;
    action_MHAD(data,tr_info,labels,opt);
elseif strcmp(datasets{dataset_idx}, 'MSRAction3D')
    opt.H_rows = 5;
    opt.sigma = 0.01;
    action_MSR3D(data,tr_info,labels,opt);
elseif strcmp(datasets{dataset_idx}, 'HDM05')
    opt.H_rows = 5;
    opt.sigma = 0.01;
    action_HDM05(data,tr_info,labels,opt);
else
    error('unknown dataset.\n')
end


end
