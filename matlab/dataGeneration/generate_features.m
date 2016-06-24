function [] = generate_features(directory, dataset)

if (strcmp(dataset, 'UTKinect')) || (strcmp(dataset, 'Florence3D')) ||...
        (strcmp(dataset, 'MSRAction3D'))
    load(['../skeleton_data/', dataset, '/skeletal_data']);
    load(['../skeleton_data/', dataset, '/body_model']);
end

if (strcmp(dataset, 'UTKinect'))
    n_subjects = 10;
    n_actions = 10;
    n_instances = 2;
    
    n_sequences = length(find(skeletal_data_validity));
    
    joints = cell(n_sequences, 1);
    action_labels = zeros(n_sequences, 1);
    subject_labels = zeros(n_sequences, 1);
    instance_labels = zeros(n_sequences, 1);
    
    count = 1;
    for subject = 1:n_subjects
        for action = 1:n_actions
            for instance = 1:n_instances
                if (skeletal_data_validity(action, subject, instance))
                    
                    joint_locations = skeletal_data{action, subject, instance}.joint_locations;
                    joint_locations(:, body_model.hip_center_index, :) = [];
                    S = size(joint_locations);
                    joints{count} = reshape(joint_locations, S(1)*S(2), S(3));
                    action_labels(count) = action;
                    subject_labels(count) = subject;
                    instance_labels(count) = instance;
                    
                    count = count + 1;
                end
            end
        end
    end
    
    save([directory, '/joints'], 'joints', '-v7.3');
    save([directory, '/labels'], 'action_labels', 'subject_labels', 'instance_labels');
    
elseif (strcmp(dataset, 'MHAD'))
    load(fullfile('..','skeleton_data','MHAD','MHAD_data_whole.mat'));
    joints = data;
    action_labels = label_act;
    subject_labels = label_sub;
    instance_labels = label_rep;
    tr_subjects = 1:7;
    te_subjects = 8:12;
    save([directory, '/tr_te_splits'], 'tr_subjects', 'te_subjects');
    save([directory, '/joints'], 'joints', '-v7.3');
    save([directory, '/labels'], 'action_labels', 'subject_labels', 'instance_labels');
    
    
elseif (strcmp(dataset, 'MSRAction3D'))
    
    n_subjects = 10;
    n_actions = 20;
    n_instances = 3;
    
    n_sequences = length(find(skeletal_data_validity));
    
    joints = cell(n_sequences, 1);
    action_labels = zeros(n_sequences, 1);
    subject_labels = zeros(n_sequences, 1);
    instance_labels = zeros(n_sequences, 1);
    
    count = 1;
    for subject = 1:n_subjects
        for action = 1:n_actions
            for instance = 1:n_instances
                if (skeletal_data_validity(action, subject, instance))
                    
                    joint_locations = skeletal_data{action, subject, instance}.joint_locations;
                    joint_locations(:, body_model.hip_center_index, :) = [];
                    S = size(joint_locations);
                    joints{count} = reshape(joint_locations, S(1)*S(2), S(3));
                    action_labels(count) = action;
                    subject_labels(count) = subject;
                    instance_labels(count) = instance;
                    
                    count = count + 1;
                end
            end
        end
    end
    
    save([directory, '/joints'], 'joints', '-v7.3');
    save([directory, '/labels'], 'action_labels', 'subject_labels', 'instance_labels');
    
elseif (strcmp(dataset, 'HDM05'))
    [joints, action_labels, subject_labels,instance_labels] = parseHDM05;
    tr_subjects = nchoosek(1:5,4);
    te_subjects = flipud(nchoosek(1:5,1));
%     tr_subjects = [1 4 5];
%     te_subjects = [2 3];
    save([directory, '/tr_te_splits'], 'tr_subjects', 'te_subjects');
    save([directory, '/joints'], 'joints', '-v7.3');
    save([directory, '/labels'], 'action_labels', 'subject_labels', 'instance_labels');
    
else
    error('Unknown dataset');
end

end


