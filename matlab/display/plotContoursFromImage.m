% plot the classification of contours extracted from images

function plotContoursFromImage(data, discrete_data, k, label, imgSize, Length)

nEach = histc(label, 1 : k);

c = lines(7);     % colorspace
c(8, :) = [0 1 0];
c(9, :) = [0 0 0.5];
c(10, :) = [0.5 0 0];
c(11, :) = [1 1 0];
c(12, :) = [1 0 1];

% CC = zeros(imgSize);
% for i = 1:k
%     id = find(label == i);
%     for j = 1:nEach(i)
%         for L = 1:Length(id(j))
%             row = discrete_data{id(j)}(L, 1);
%             col = discrete_data{id(j)}(L, 2);
%             CC(row, col, :) = 255 * c(i, :);
%         end
%     end
% end

% figure, imshow(CC);

hFig = figure;
set(hFig, 'Position', [200 100 1000 700]);
hold on;

for i = 1:k
    id = find(label == i);
    for j = 1:nEach(i)
        plot(data{id(j)}(:, 2), data{id(j)}(:, 1), 'color', c(i, :),  'LineWidth', 1.5);
    end
end

hold off;
axis equal;
axis ij;
axis([0 imgSize(2) 0 imgSize(1)]);
xlabel('x', 'FontSize', 14);
ylabel('y', 'FontSize', 14);

end