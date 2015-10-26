function [features, action_labels, subject_labels,instance_labels] = parseHDM05

% addpath(genpath('parser'))
% addpath(genpath('animate'))
% addpath('quaternions')
addpath(genpath('../3rdParty/HDM05-Parser'))

dataPath = '~/research/data/HDM05_cut_amc';
action = {'depositFloorR','elbowToKnee1RepsLelbowStart','grabHighR',...
    'hopBothLegs1hops','jogLeftCircle4StepsRstart','kickLFront1Reps',...
    'lieDownFloor','rotateArmsBothBackward1Reps','sneak2StepsLStart',...
    'squat1Reps','throwBasketball'};
subject = {'HDM_bd','HDM_bk','HDM_dg','HDM_mm','HDM_tr'};

maxFeatures = 1000;
features = cell(1, maxFeatures);
action_labels = zeros(1, maxFeatures);
subject_labels = zeros(1, maxFeatures);
instance_labels = zeros(1, maxFeatures);
count = 1;
for i = 1:length(action)
    for j = 1:length(subject)
        files = dir( fullfile( dataPath,action{i}, ...
            sprintf('%s*.amc',subject{j}) ) );
        subject_labels(count:count+length(files)-1) = j;
        action_labels(count:count+length(files)-1) = i;
        for k = 1:length(files)
            jointConf = fullfile(dataPath,sprintf('%s.asf',subject{j}));
            dataFile = fullfile(dataPath,action{i},files(k).name);
            [skel,mot] = readMocap(jointConf, dataFile);
            features{count} = cell2mat(mot.jointTrajectories);
            instance_labels(count) = k;
            count = count + 1;
            % animate(skel, mot, 1);
        end
        
    end
end
features(count:end) = [];
action_labels(count:end) = [];
subject_labels(count:end) = [];

end