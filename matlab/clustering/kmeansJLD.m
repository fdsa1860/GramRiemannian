function [label,X_center,D] = kmeansJLD(X,k,opt)
% kmeansJLD:
% perform kmeans clustering on covariance matrices with JLD metric
% Input:
% X: an N-by-1 cell vector
% k: the number of clusters
% Output:
% label: the clustered labeling results

N = length(X);
ind = randsample(N,k);
X_center = X(ind);
label = ones(1,N);
label_old = zeros(1,N);

iter = 0;
iter_max = 100;
labelChangeThreshold = N * 0.01;
while iter<iter_max && nnz(label-label_old)>labelChangeThreshold   
    D = HHdist(X_center, X, opt);
    label_old = label;
    [~,label] = min(D);
    for j=1:k
        if strcmp(opt.metric,'JLD')
%             X_center{j} = karcher(X{label==j});
%             X_center{j} = BhattacharyyaMean(X{label==j});
            X_center{j} = steinMean(cat(3,X{label==j}));
%             X_center{j} = findCenter(X(label==j),opt);
        elseif strcmp(opt.metric,'binlong')
            X_center{j} = findCenter(X(label==j));
        end
        if isempty(X_center{j})
            X_center(j) = X(randsample(N,1));
        end
    end
    iter = iter + 1;
    fprintf('iter %d ... label # changed %d ... \n',iter,nnz(label-label_old));
end

if iter==iter_max
    warning('kmeans has reached maximum iterations before converging.\n');
end

nEachCluster = histc(label, 1 : k);
[nEachCluster, IX] = sort(nEachCluster, 'descend');
X_center = X_center(IX);
label = sortLabel(label);

end

function center = findCenter(X,opt)

D = HHdist(X,[],opt);
d = sum(D);
[~,ind] = min(d);
center = X{ind};

end