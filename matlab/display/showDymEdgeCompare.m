function accMat = showDymEdgeCompare(dym, opt)

if exist('opt','var');
    for i = 1:length(dym)
        dym{i}.dymBoundaries = double(dym{i}.dymBoundaries~=0);
    end
end

n = length(dym);
accMat = zeros(n,n);
for i = 1:n
    for j = 1:n
        accMat(i,j) = dymEdgeCompare(dym{i}.dymBoundaries, dym{j}.dymBoundaries);
    end
end

imagesc(accMat);

end