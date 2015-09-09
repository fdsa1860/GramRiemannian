function feat = bowFeatHHAll(X_all_HH, centers_HH, X_all_order, centers_order, alpha)

nc = length(centers_HH);
numImg = length(X_all_HH);
feat = zeros(nc, numImg);
for i = 1:numImg
    if isempty(X_all_HH{i})
        feat(:,i) = zeros(nc,1);
    else
        feat(:,i) = bowFeatHH(X_all_HH{i}, centers_HH, X_all_order{i}, centers_order, alpha);
    end
end

end