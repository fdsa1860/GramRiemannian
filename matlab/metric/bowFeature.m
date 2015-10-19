function hFeat = bowFeature(HH_centers, HH, label, opt)

numWords = length(HH_centers);
unique_label = unique(label);
D = HHdist(HH_centers, HH, opt);
[~,wLabel] = min(D);
hFeat = zeros(numWords,length(unique_label));
for i = 1:length(unique_label)
    hFeat(:,i) = hist(wLabel(label==unique_label(i)),1:numWords);
end

end