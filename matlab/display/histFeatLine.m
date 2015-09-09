function histFeatLine(featLine, labels)

n = size(featLine, 2);
d = size(featLine, 1);
assert(n == length(labels));
figure;
for i = 1:d
    subplot(3, 3, i);
    hist(featLine(i, labels==1));
    title(sprintf('histogram of bin %d',i));
    xlabel(sprintf('value of bin %d', i));
    ylabel('counts');
end
suptitle('histogram of positive line feature')

figure;
for i = 1:d
    subplot(3, 3, i);
    hist(featLine(i, labels==-1));
    title(sprintf('histogram of bin %d',i));
    xlabel(sprintf('value of bin %d', i));
    ylabel('counts');
end
suptitle('histogram of negative line feature')

end