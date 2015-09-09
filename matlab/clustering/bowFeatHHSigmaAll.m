function feat = bowFeatHHSigmaAll(X_all_HH, centers_HH, X_all_sigma, centers_sigma, alpha, verbose)

if nargin < 6
    verbose = false;
end

if verbose
    fprintf('getting BOW representation ...');
end

nc = length(centers_HH);
numImg = length(X_all_HH);
feat = zeros(nc, numImg);
for i = 1:numImg
    if isempty(X_all_HH{i})
        continue;
    end
    feat(:,i) = bowFeatHHSigma(X_all_HH{i}, centers_HH, X_all_sigma{i}, centers_sigma, alpha);
end

if verbose
    fprintf('finish!\n');
end

end