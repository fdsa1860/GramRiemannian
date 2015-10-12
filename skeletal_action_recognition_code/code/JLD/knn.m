function predicted_labels = knn(X_train, y_train, X_test, opt)

K = 10;
D2 = HHdist(X_train, X_test, opt.metric);
[D1,ind] = sort(D2);
topLabel = y_train(ind(1:K,:));
%         predicted_labels = mode(topLabel)';
topDist = D1(1:K,:);
W = 1./(topDist.^2);
predicted_labels = zeros(length(X_test),1);
for i = 1:size(topLabel,2)
    uL = unique(topLabel(:,i));
    wUL = zeros(length(uL),1);
    for j = 1:length(uL)
        wUL(j) = sum(W(topLabel(:,i)==uL(j),i));
    end
    [~,ii] = max(wUL);
    predicted_labels(i) = uL(ii);
end

end