function [label,X_center,D] = kmeansContour(X,k)
% Input:
% X: an N-by-1 cell vector
% k: the number of clusters
% Output:
% label: the clustered labeling results

N = length(X);
D = zeros(k,N);
ind = randsample(N,k);
X_center = X(ind);
thr = 0.99;
label = zeros(1,N);
label_old = ones(1,N);

iter = 0;
iter_max = 100;
while iter<iter_max && nnz(label-label_old)~=0
    
    for i=1:N
        for j=1:k
            D(j,i) = hankeletAngle(X{i},X_center{j},thr);
        end
    end
    label_old = label;
    [~,label] = min(D);
    for j=1:k
        X_center{j} = findCenter(X(label==j),thr);
    end
    iter = iter + 1;
    
end

end

function center = findCenter(X,thr)

n = length(X);
D = zeros(n,n);
for i=1:n
    for j=i+1:n
        D(i,j) = hankeletAngle(X{i},X{j},thr);
    end
end
D = D + D';
d = sum(D);
[~,ind] = min(d);
center = X{ind};

end