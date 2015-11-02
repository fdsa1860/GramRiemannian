
function feat = getLogHH(HH)

m = size(HH{1},1);
r = (1+m) * m / 2;
feat = zeros(r,length(HH));
for i = 1:length(HH)
    [V, D] = eig(HH{i});
    d = diag(D);
    T = V * diag(log(d)) * V';
    T = (T + T') / 2;
    index = find(triu(ones(size(T))));
    feat(:,i) = T(index);
end

end