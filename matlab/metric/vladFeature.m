function vFeat = vladFeature(HH_centers, HH, label, opt)

numCenter = length(HH_centers);
unique_label = unique(label);
D = HHdist(HH_centers, HH, opt);
[~,cLabel] = min(D);
n = numel(HH_centers{1});

vFeat = zeros(numCenter * n, length(unique_label));
for i = 1:length(unique_label)
    C = cell(1, numCenter);
    for ci = 1:numCenter
        C{ci} = zeros(size(HH_centers{1}));
    end
    index = find(label==unique_label(i));
    for j = 1:length(index)
        cIndex = cLabel(index(j));
        J = sqrt(D(cIndex, index(j)));
        dJdX = JBLD_dX(HH_centers{cIndex}, HH{index(j)});
        C{cIndex} = C{cIndex} + J * dJdX / norm(dJdX, 'fro');
    end
    for cIndex = 1:numCenter
        vFeat(n*(cIndex-1)+1:n*cIndex, i) = C{cIndex}(:);
    end
end

end