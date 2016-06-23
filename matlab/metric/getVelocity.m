function velocity = getVelocity(features)
% get features' first order derivative along the time dimension

velocity = cell(1,length(features));
for i=1:length(features)
    velocity{i} = diff(features{i},[],2);
end

end