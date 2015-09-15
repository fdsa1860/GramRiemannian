function dis = computeJBLD2(G1, G2, X)

sigma = 1e-3;
d = size(G1,1);
I = eye(d);
W = G1 + G2 + sigma * I;
Y = G1 + sigma * I;
A = W - X;
B = Y;
dis = log(det(0.5*A+0.5*B))-0.5*log(det(A))-0.5*log(det(B));

end