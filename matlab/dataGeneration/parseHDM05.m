function [features, action_labels, subject_labels,instance_labels] = parseHDM05

addpath(genpath(fullfile('..','3rdParty','HDM05-Parser')));

dataPath = fullfile('~','research','data','HDM05_cut_amc');
% action = {'depositFloorR','elbowToKnee3RepsLelbowStart','grabHighR',...
%     'hopBothLegs3hops','jogLeftCircle4StepsRstart','kickRFront1Reps',...
%     'lieDownFloor','rotateArmsBothBackward3Reps','sneak4StepsRStart',...
%     'squat1Reps','throwBasketball','hopBothLegs1hops', ...
%     'jumpingJack1Reps','throwStandingHighR','sitDownChair',...
%     'standUpSitChair'};
action = {'clapAboveHead1Reps','depositFloorR', ...
    'elbowToKnee1RepsLelbowStart','grabHighR',...
    'hopBothLegs1hops','jogLeftCircle4StepsRstart','kickLFront1Reps',...
    'lieDownFloor','rotateArmsBothBackward1Reps','sitDownChair',...
    'sneak2StepsLStart','squat3Reps','standUpLieFloor','throwBasketball'};
% action = {'depositFloorR','elbowToKnee1RepsLelbowStart','grabHighR'};
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
            T = cell2mat(mot.jointTrajectories);
            T = T - repmat(T(1:3,:),mot.njoints,1);
            for n = 1:size(T,2)
                hip_axis = T(19:21, n) - T(4:6, n);
%                 hip_axis = joint_locations(:, body_model.right_hip_index, k) -...
%                     joint_locations(:, body_model.left_hip_index, k);
                % Find the rotation matrix that converts the ground plane projection of hip-axis into x-axis
                R = vrrotvec2mat(vrrotvec([hip_axis(1), 0, hip_axis(3)], [1, 0, 0]));
                T2 = reshape(T(:,n),3,[]);
                T3 = R*T2;
                T(:,n) = T3(:);
            end
            for m=1:mot.njoints
                mot.jointTrajectories{m} = T(3*m-2:3*m,:);
            end
%             T(1:3,:) = [];
            T = T([16 17 18 31 32 33 67 68 69 88 89 90],:);
            features{count} = T;
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