% show the result of curve clustering and classification

function showCurves(data, k, label)

if nargin < 2
    k = 1;
    label = ones(length(data), 1);
end

nEach = hist(label, 1:k);
[~, ind] = sort(-nEach);

c = lines(7);     % colorspace
c(8, :) = [0 1 0];
c(9, :) = [0 0 0.5];
c(10, :) = [0.5 0 0];
c(11, :) = [1 1 0];
c(12, :) = [1 0 1];
c(13, :) = [0 1 1];

figure;
for i = 1:9
    ymin = inf;
    ymax = 0;
    id = find(label == ind(i));
    subplot(3,3,i);
    hold on;
    for j = 1:min(nEach(ind(i)), 100)
        plot(data{id(j)}, 'color', c(i, :),  'LineWidth', 1.5);
        ymin = min(ymin, min(data{id(j)}));
        ymax = max(ymax, max(data{id(j)}));
    end
    hold off;
    ylim([ymin ymax]);
    xlabel('x', 'FontSize', 14);
    ylabel('dscA', 'FontSize', 14);
    title(['class: ' num2str(i)], 'FontSize', 12);
end

end

