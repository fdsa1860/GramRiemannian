% small test of spectral clustering
W = [
    1 2 3 0.1 0.3
    2 4 5 0.2 0.4
    3 5 3 0.1 0.4
    0 0 0.5 1 3
    0 0 0 3 2];
D = diag(sum(W));
L = D - W;
e1 = [1 1 1 0 0]';
e2 = [0 0 0 1 1]';
[U,S,V] = svd(L);
idx = kmeans(U(:,4:5),2);