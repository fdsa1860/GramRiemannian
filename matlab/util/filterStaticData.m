function [feat, label] = filterStaticData(feat, label, noiseBound)

if nargin < 3
    noiseBound = 2;
end

N = length(feat);
featNorm = zeros(1,N);
for i = 1:N
    featNorm(i) = norm(feat{i}, 'fro');
end
ind = featNorm < noiseBound;
label(ind) = [];
feat(ind) = [];

end