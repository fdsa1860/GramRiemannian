function [centers, label, D, W] = nCutContourHHSigma(X, k, alpha, D, scale_sig, order)
% nCutContourHHSigma: cluster data using hankelet metric and normalized
% sigular values
%
% Input:
% X: an N-by-1 cell vector, data to cluster
% k: the number of clusters
% alpha: the distance metric parameter, affects the significance of the
% order difference information
% D: distance matrix
% Output:
% centers.centerInd: indices of centers in D
% centers.data: the cluster centers
% centers.sigma: the normalized singular value information of the centers
% centers.H: the centers' hankel matrices
% centers.HH: the centers' normalized hankel matrices
% label: the clustered labeling results
% D: distance matrix

if nargin < 3
    alpha = 0;
end

if nargin < 4 || isempty(D)
    D = dynamicDistanceSigma(X, alpha);
end

if (~exist('scale_sig','var'))
    scale_sig = 0.001*max(D(:));
end

if (~exist('order','var'))
  order = 2;
end

% kNN = 80;
% D2 = D;
% for j=1:size(D,1)
%     [ignore,ind] = sort(D(:,j));
%     D2(ind(kNN+1:end),j) = Inf;
% %     D2(ind(1:kNN),j) = D(ind(1:kNN),j) / max(D(ind(1:kNN),j)) * 0.5;
% end
% % scale_sig = 1;
% % D = min(D2,D2');%(B+B')/2;
% D = max(D2,D2');
% solitude = sum(D<1)==1;
% D(solitude, :) = [];
% D(:, solitude) = [];

tmp = (D/scale_sig).^order;
W = exp(-tmp);     % the similarity matrix
NcutDiscrete = ncutW(W, k);
label = sortLabel_count(NcutDiscrete);

% % bamboo shoot ncut
% % scale_sig = 0.01;
% label = zeros(size(D,1), 1);
% sel = [0 1];
% % sel = [0 2 4];
% for iter = 1:length(sel)
%     D1 = D(ismember(label,sel(iter)), ismember(label,sel(iter)));
%     W1 = exp(-(D1/scale_sig).^order);
%     NcutDiscrete1 = ncutW(W1, k);
%     [label1, clsSize] = sortLabel_count(NcutDiscrete1);
%     label1 = label1 + (iter-1)*k;
%     label(ismember(label,sel(iter))) = label1;
% %     sel = label1(1:s);
% %     scale_sig = scale_sig / 10;
% end
% label = sortLabel(label);
% W = 0;

% get centers of clusters
centerInd = findCenters(D, label);

% % filter small clusters
% clsSizeThres = 50;
% index = true(length(centerInd), 1);
% for i = 1:length(centerInd)
%     if nnz(label==i) < clsSizeThres, index(i) = false; end
% end
% centerInd = centerInd(index);

% update k, sometimes the cluster # is not exactly k
k = length(centerInd);

% estimate beta, which is the parameter for the estimated pdf of each
% cluster, the pdf function is f(x) = beta * exp(- beta * x)
delta_t = 0.0002;
t = 0:delta_t:1;
beta = zeros(1, k);
for i = 1:k
    h = hist(D(centerInd(i), label==i), t);
    p = h / sum(h * delta_t);
    beta(i) = 1 / (sum(p .* t * delta_t) + 1e-6);
end

centers = X(centerInd);
for i = 1:k
    centers(i).centerInd = centerInd(i);
    centers(i).beta = beta(i);
end

end