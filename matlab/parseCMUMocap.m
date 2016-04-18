function [features, action_labels, subject_labels,instance_labels] = parseCMUMocap

addpath(genpath('../3rdParty/'))

dataPath = '~/research/data/CMUMocap';
file = '05_02.amc';
jointConf = fullfile(dataPath, '05.asf');
dataFile = fullfile(dataPath,file);
% [D] = readC3D(fname);
[skel,mot] = readMocap(jointConf, dataFile);
T = cell2mat(mot.jointTrajectories);

55
end