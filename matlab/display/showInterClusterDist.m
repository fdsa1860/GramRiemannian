function [DistAtClass, newLabel] = showInterClusterDist(D, label, k)

if nargin < 3
	k = length(unique(label));
end

h = hist(label, 1:length(unique(label)));
[~, ind] = sort(-h);
newLabel = zeros(size(label));
for i = 1:length(ind)
    newLabel(label==ind(i)) = i;
end

% DistAtClass = zeros(k, k);
% for i = 1:k
%     id1 = find(newLabel == i);
%     for j = 1:k
%         id2 = find(newLabel == j);
%         if i == j
%             DistAtClass(i, j) = max(max(D(id1, id2)));
%         else
%             DistAtClass(i, j) = min(min(D(id1, id2)));
%         end
%     end    
% end

centerInd = findCenters(D, label);

DistAtClass = zeros(k, k);
for i = 1:k
    for j = 1:k
        if i == j
            DistAtClass(i, j) = mean(D(centerInd(i), newLabel == i));
        else
            DistAtClass(i, j) = D(centerInd(i), centerInd(j));
        end
    end
end

showDistanceMatrix(DistAtClass);

end
