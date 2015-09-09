function [label, centers, cOrder, cH, cHH, D, centerInd] = nCutContourHH(X, order, H, HH, k, alpha, D)
% Input:
% X: an N-by-1 cell vector, data to cluster
% order: N-by-1 vector, the estimated order information of X
% H: N-by-1 cell, the hankel matrix of each X
% HH: N-by-1 cell, the normalized hankel matrix of each X
% k: the number of clusters
% Output:
% label: the clustered labeling results
% centers: the cluster centers
% cOrder: the order information of the centers
% cH: the centers' hankel matrices
% cHH: the centers' normalized hankel matrices
% k: the number of clusters

if nargin < 5
    k = numel(unique(order));
end

if nargin < 6
    alpha = 1;
end

if nargin < 7
    D = dynamicDistance(HH, 1:length(order), order, alpha);
end

W = exp(-D);     % the similarity matrix
NcutDiscrete = ncutW(W, k);
label = sortLabel_order(NcutDiscrete, order);

centerInd = findCenters(D, label);
centers = X(centerInd);
cOrder = order(centerInd);
cH = H(centerInd);
cHH = HH(centerInd);

end