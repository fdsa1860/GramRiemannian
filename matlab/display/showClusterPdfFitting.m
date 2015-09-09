function showClusterPdfFitting(D, label, centers, index)

if ~exist('index', 'var')
    index = 1;
end

delta_t = 0.002;
t = 0:delta_t:0.02;

h = hist(D(centers.centerInd(index), label==index), t);
h = h / sum(h * delta_t);
y = beta(1) * exp(- beta(1) * t);

figure;
hold on;
bar(t, h);
plot(t, y, 'r');
hold off;

end