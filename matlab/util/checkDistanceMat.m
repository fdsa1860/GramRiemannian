function D = checkDistanceMat(X, y)

% opt.metric = 'JLD';
% opt.metric = 'JLD_denoise';
% opt.metric = 'binlong';
opt.metric = 'AIRM';
opt.H_structure = 'HHt';
opt.sigma = 0.01;

unique_classes = unique(y);
n_classes = length(unique_classes);

Z = cell(1,length(X));
counter = 0;
for ai = 1:n_classes
    k = nnz(y==unique_classes(ai));
    Z(counter+1:counter+k) = X(y==unique_classes(ai));
    counter = counter + k;
end
D = HHdist(Z,[],opt);
imagesc(D);

end