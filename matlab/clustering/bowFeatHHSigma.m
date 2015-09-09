function feat = bowFeatHHSigma(HH1, HH2, sigma1, sigma2, alpha)
% Input:
% HH1: 1 by N cell, data to be represented
% HH2: 1 by K cell, cluster centers
% sigma1: D by N vector
% sigma2: D by K vector
% alpha: the weight of order in distance metric
% Output:
% feat: bag of words representation

if nargin < 5
    alpha = 1;
end

% get the length of X samples as weights
N = length(HH1);
K = length(HH2);

w = zeros(1, N);
for i = 1:N
    w(i) = size(HH1{i},1) + size(HH1{i},2) - 1; % contour length
end

% get distance matrix D
D = dynamicDistanceSigmaCross(HH1, HH2, sigma1, sigma2, alpha);

[val,ind] = min(D, [], 2);

% get BOW representation
feat = zeros(K, 1);
for i = 1:N
    feat(ind(i)) = feat(ind(i)) + w(i);
end

% normalization
feat = feat / norm(feat);

end