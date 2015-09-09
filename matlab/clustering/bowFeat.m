function feat = bowFeat(X,centers)
% Input:
% X: contour features
% centers: cluster centers
% Output:
% feat: bag of words representation

% get the length of X samples as weights
N = length(X);
K = length(centers);

lx = zeros(1, N);
for i = 1:N
    lx(i) = length(X{i});
end

% build hankel matrix
h_size = 4;
order_thres = 0.995;
Hx = cell(1, N);
Hc = cell(1, K);
order1 = zeros(1, N);
order2 = zeros(1, K);
for i = 1:N
    [H, HHp] = buildHankel(X{i}, h_size, 1);
    Hx{i} = HHp;
    order1(i) = getOrder(H, order_thres);
end
for i = 1:K
    [H, HHp] = buildHankel(centers{i}, h_size, 1);
    Hc{i} = HHp;
    order2(i) = getOrder(H, order_thres);
end

% get distance matrix D
D = dynamicDistanceCross(Hx, Hc, order1, order2);

[val,ind] = min(D, [], 2);

% get BOW representation
feat = zeros(K, 1);
for i = 1:N
    feat(ind(i)) = feat(ind(i)) + lx(i);
end

% normalization
feat = feat / norm(feat);

end