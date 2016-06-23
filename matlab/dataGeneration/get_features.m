function [features] = get_features(feature_type, joint_locations, body_model)

if (strcmp(feature_type, 'normal'))
    features = get_joint_features(joint_locations,body_model);
elseif (strcmp(feature_type, 'original'))
    S = size(joint_locations);
    features = reshape(joint_locations, S(1)*S(2), S(3));
else
    error('Unknown feature type');
end

end
