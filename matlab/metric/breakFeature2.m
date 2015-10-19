function [feat,label] = breakFeature2(features)

wSize = 15;
nTraj = 3;
samplesPerFeature = 200;
nFeatures = length(features);
N = samplesPerFeature * nFeatures;
feat = cell(1,N);
label = zeros(1, N);
% rng('default');
rng(1);
count = 1;
for i = 1:nFeatures
    f = features{i};
    nr = size(f,1);
    nc = size(f,2);
    nJoint = nr / 3;
    index = randi(nJoint,nTraj,samplesPerFeature);
    if nc <= wSize
        firstFrame = ones(1,samplesPerFeature);
        lastFrame = nc*ones(1,samplesPerFeature);
    else
        lastFrame = randi([wSize,nc],1,samplesPerFeature);
        firstFrame = lastFrame-wSize+1;
    end
    for j = 1:samplesPerFeature
        ind = index(:,j);
        if length(unique(ind))<nTraj
            ind = randsample(nJoint,nTraj);
        end
        ind = sort(ind);
        g = zeros(nTraj*3,lastFrame(j)-firstFrame(j)+1);
        for k = 1:nTraj
            g(k*3-2:k*3,:) = f(ind(k)*3-2:ind(k)*3,firstFrame(j):lastFrame(j));
        end
        feat{count} = g;
        label(count) = i;
        count = count + 1;
    end
end

end