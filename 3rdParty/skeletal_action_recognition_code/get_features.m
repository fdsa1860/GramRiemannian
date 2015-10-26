function [features] = get_features(feature_type, joint_locations, body_model)

    if (strcmp(feature_type, 'JLD'))

        features = get_joint_features(joint_locations,body_model);
        
    else
        error('Unknown feature type');
    end
end
