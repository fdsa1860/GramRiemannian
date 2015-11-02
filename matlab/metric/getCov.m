function HH = getCov(features)

HH = cell(1,length(features));
for i=1:length(features)
    tmpCov = cov(features{i}');
    THRESH = 1e-6;
    bigCov = (tmpCov + tmpCov')/2;
    [L,D] = eig(bigCov);D = diag(D);
    L = real(L); D = real(D);
    D(D < THRESH) = THRESH;
    HH{i} = L*diag(D)*L';
end

end