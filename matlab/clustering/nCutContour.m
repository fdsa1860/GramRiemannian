function [label,X_center,centerInd,W] = nCutContour(X,k)
% Input:
% X: an N-by-1 cell vector
% k: the number of clusters
% Output:
% label: the clustered labeling results

N = length(X);
thr = 0.99;

D = zeros(N,N);
for i=1:N
    for j=i+1:N
%         D(i,j) = hankeletAngle(X{i},X{j});
        D(i,j) = myHankeletAngle2(X{i},X{j});
    end
end

D = D + D';
W = exp(-1e7*D);

addpath('../3rdParty/Ncut_9');

map = ncutW(W,k);
label = map * (1:k)';
centerInd = findCenter(W,label);
X_center = X(centerInd);

rmpath('../3rdParty/Ncut_9');

end

function centerInd = findCenter(W,label)

k = length(unique(label));
centerInd = zeros(k,1);
for i=1:k
    index = find(label==i);
    WW = W(index,index);
    w = sum(WW);
    [~,ind] = max(w);
    centerInd(i) = index(ind);
end

end