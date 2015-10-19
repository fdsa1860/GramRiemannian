% experiment 1
% spatial comparing
% between subjects

addpath(genpath(fullfile('..','3rdParty')));
addpath(genpath(fullfile('.')));
load(fullfile('..', 'skeleton_data', 'MSRAction3D', 'skeletal_data'));
load(fullfile('..', 'skeleton_data', 'MSRAction3D', 'body_model'));

n_subjects = 10;
n_actions = 20;
n_instances = 3;

n_sequences = length(find(skeletal_data_validity));

features = cell(n_sequences, 1);
action_labels = zeros(n_sequences, 1);
subject_labels = zeros(n_sequences, 1);
instance_labels = zeros(n_sequences, 1);

count = 1;
for subject = 1:n_subjects
    for action = 1:n_actions
        for instance = 1:n_instances
            if (skeletal_data_validity(action, subject, instance))
                
                joint_locations = skeletal_data{action, subject, instance}.joint_locations;
                features{count} = get_features('JLD', joint_locations, body_model, 76);
                action_labels(count) = action;
                subject_labels(count) = subject;
                instance_labels(count) = instance;
                
                count = count + 1;
            end
        end
    end
end


%%

opt.metric = 'JLD';
opt.H_structure = 'HHt';
opt.sigma = 0.01;
opt.epsilon = 1e-4;


c1 = (features(subject_labels==5 & action_labels==3));
c2 = (features(subject_labels==6 & action_labels==3));
c3 = (features(subject_labels==5 & action_labels==2));

HH1 = getHH(c1(1),opt);
HH2 = getHH(c1(2),opt);
HH3 = getHH(c2(1),opt);
HH4 = getHH(c2(2),opt);
HH5 = getHH(c3(1),opt);
HH6 = getHH(c3(2),opt);
JBLD(HH1{1}, HH2{1})

nJoint = 19;
d1 = zeros(1, nJoint);
d2 = zeros(1, nJoint);
d3 = zeros(1, nJoint);
g1 = zeros(1, nJoint);
g2 = zeros(1, nJoint);
g3 = zeros(1, nJoint);
for iJoint=1:nJoint
e1 = c1{1}(3*iJoint-2:3*iJoint,:);
e2 = c1{2}(3*iJoint-2:3*iJoint,:);
e3 = c2{1}(3*iJoint-2:3*iJoint,:);
e4 = c2{2}(3*iJoint-2:3*iJoint,:);
e5 = c3{1}(3*iJoint-2:3*iJoint,:);
e6 = c3{2}(3*iJoint-2:3*iJoint,:);
HH1 = getHH({e1},opt);
HH2 = getHH({e2},opt);
HH3 = getHH({e3},opt);
HH4 = getHH({e4},opt);
HH5 = getHH({e5},opt);
HH6 = getHH({e6},opt);
d1(iJoint) = JBLD(HH1{1},HH2{1});
d2(iJoint) = JBLD(HH1{1},HH3{1});
d3(iJoint) = JBLD(HH1{1},HH5{1});
g1(iJoint) = gramDist_cccp(pcaClean(HH1{1}), HH2{1}, opt);
g2(iJoint) = gramDist_cccp(pcaClean(HH1{1}), HH3{1}, opt);
g3(iJoint) = gramDist_cccp(pcaClean(HH1{1}), HH5{1}, opt);
end
figure(1);

plot(d1,'b*-');hold on;
plot(d2,'g*-');
plot(d3,'r*-');
hold off;
figure(2);
plot(g1,'b*-');hold on;
plot(g2,'g*-');
plot(g3,'r*-');
hold off;