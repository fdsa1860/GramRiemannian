function [] = generate_features(directory, dataset, feature_type)

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
%                     if size(joint_locations,3) < 20, continue; end
                    features{count} = get_features(feature_type, joint_locations, body_model);
                    action_labels(count) = action;
                    subject_labels(count) = subject;
                    instance_labels(count) = instance;
                    
                    count = count + 1;
                end
            end
        end
    end
    
%     features(count:end) = [];
%     action_labels(count:end) = [];
%     subject_labels(count:end) = [];
%     instance_labels(count:end) = [];
    
    save([directory, '/features'], 'features', '-v7.3');
    save([directory, '/labels'], 'action_labels', 'subject_labels', 'instance_labels');
    
elseif (strcmp(dataset, 'Florence3D'))
    
    n_sequences = length(skeletal_data);
    
    features = cell(n_sequences, 1);
    action_labels = zeros(n_sequences, 1);
    subject_labels = zeros(n_sequences, 1);
    
    for count = 1:n_sequences
        
        joint_locations = skeletal_data{count}.joint_locations;
        features{count} = get_features(feature_type, joint_locations, body_model);
        
        action_labels(count) = skeletal_data{count}.action;
        subject_labels(count) = skeletal_data{count}.subject;
        
    end
    
    save([directory, '/features'], 'features', '-v7.3');
    save([directory, '/labels'], 'action_labels', 'subject_labels');
    
    
elseif (strcmp(dataset, 'MSRAction3D'))
    
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
                    features{count} = get_features(feature_type, joint_locations, body_model);
                    action_labels(count) = action;
                    subject_labels(count) = subject;
                    instance_labels(count) = instance;
                    
                    count = count + 1;
                end
            end
        end
    end
    
    save([directory, '/features'], 'features', '-v7.3');
    save([directory, '/labels'], 'action_labels', 'subject_labels', 'instance_labels');
    
elseif (strcmp(dataset, 'HDM05'))
    [features, action_labels, subject_labels,instance_labels] = parseHDM05;
%     tr_subjects = nchoosek(1:5,3);
%     te_subjects = flipud(nchoosek(1:5,2));
    tr_subjects = [1 4 5];
    te_subjects = [2 3];
    save([directory, '/tr_te_splits'], 'tr_subjects', 'te_subjects');
    save([directory, '/features'], 'features', '-v7.3');
    save([directory, '/labels'], 'action_labels', 'subject_labels', 'instance_labels');
    
else
    error('Unknown dataset');
end

end


