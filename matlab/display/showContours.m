% show the result of contour clustering and classification

function showContours(data, k, label)

if nargin < 2
    k = 1;
    label = ones(length(data), 1);
end

nEach = histc(label, 1 : k);

c = jet(k);
% c = lines(7);     % colorspace
% c(8, :) = [0 1 0];
% c(9, :) = [0 0 0.5];
% c(10, :) = [0.5 0 0];
% c(11, :) = [1 1 0];
% c(12, :) = [1 0 1];
% c(13, :) = [0 1 1];

hFig = figure;
set(hFig, 'Position', [200 100 1250 650]);
set(gca,'YDir','reverse');
hold on;

xmin = inf;
xmax = 0;
ymin = inf;
ymax = 0;
for i = 1:k
    id = find(label == i);
    for j = 1:nEach(i)
        plot(data{id(j)}(:, 2), data{id(j)}(:, 1), 'color', c(i, :),  'LineWidth', 1.5);
        xmin = min(xmin, min(data{id(j)}(:, 2)));
        xmax = max(xmax, max(data{id(j)}(:, 2)));
        ymin = min(ymin, min(data{id(j)}(:, 1)));
        ymax = max(ymax, max(data{id(j)}(:, 1)));
    end
end

hold off;
axis equal;
axis([xmin-5 xmax+5 ymin-5 ymax+5]);
xlabel('x', 'FontSize', 14);
ylabel('y', 'FontSize', 14);
title(['Number of class: ' num2str(k)], 'FontSize', 12);

end

