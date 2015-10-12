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


opt.metric = 'JLD';
opt.H_structure = 'HHt';
opt.sigma = 0.25;

c1 = (features(subject_labels==1 & action_labels==3));
c2 = (features(subject_labels==2 & action_labels==3));
HH1 = getHH(c1(1),opt);
HH2 = getHH(c1(2),opt);
HH3 = getHH(c2(1),opt);
HH4 = getHH(c2(2),opt);
JBLD(HH1{1},HH2{1})
