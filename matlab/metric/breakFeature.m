function [feat,label] = breakFeature(features)

maxFeat = 50000;
feat = cell(1,maxFeat);
label = zeros(1, maxFeat);
wSize = 30;
count = 1;
for i = 1:length(features)
    f = features{i};
    nr = size(f,1);
    nc = size(f,2);
    nJoint = nr / 3;
    if nc <= wSize
        for k = 1:nJoint
            feat{count} = f(k*3-2:k*3,:);
            label(count) = i;
            count = count + 1;
        end
        continue;
    end
    for j = 1:nc-wSize+1
        for k = 1:nJoint
            feat{count} = f(k*3-2:k*3,j:j+wSize-1);
            label(count) = i;
            count = count + 1;
        end
    end
end
feat(count:end) = [];
label(count:end) = [];

end