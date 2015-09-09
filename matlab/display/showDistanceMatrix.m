% show the distance matrix

function showDistanceMatrix(D)

% colorlevel for cumumaltive angle
% colorlevel = [0.000001, 0.00001, 0.0001, 0.0002, 0.0004, 0.0006, 0.0008, 0.001, 0.002, 0.003];

% colorlevel for the derivative of cumulative angle
%colorlevel = [0.00001, 0.0001, 0.0005, 0.001, 1, 1.0002, 1.0004, 1.0006, 1.0015, 1.002];
colorlevel = [0.0001, 0.001, 0.01, 0.1, 1, 1.0005, 1.002, 1.01, 1.05, 1.1];
maplevel =[0 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1];

dist_transform = D;
[row, col] = find(D <= colorlevel(1));
for i = 1:numel(row)
    dist_transform(row(i), col(i)) = maplevel(1);
end

for i = 2:numel(colorlevel)
    [row, col] = find(D <= colorlevel(i) & D > colorlevel(i-1));
    for j = 1:numel(row)
        dist_transform(row(j), col(j)) = maplevel(i);
    end
end

[row, col] = find(D > colorlevel(10));
for i = 1:numel(row)
    dist_transform(row(i), col(i)) = maplevel(11);
end

hFig = figure;
set(hFig, 'Position', [200 100 750 650]);
imagesc(dist_transform);
hbar = colorbar;
set(hbar, 'YTickLabel', [colorlevel 1.1041]);

xlabel('index', 'FontSize', 14);
ylabel('index', 'FontSize', 14);

end