function HH_hat = pcaClean(HH)

w = size(HH,2);
h = size(HH,1);
d = min([w,h]);
assert(rank(HH)==d);    % check that HH is full rank
[coef,score,~,~,~,mu] = pca(HH','Centered',false);
HH_hat = bsxfun(@plus,coef(:,1:d-1)*score(:,1:d-1)',mu'); % reduce rank by one

end