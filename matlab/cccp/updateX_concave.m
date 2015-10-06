function cccp = updateX_concave(cccp)

INV = inv(cccp.W-cccp.X);
INV = (INV + INV') / 2;
M = 0.5*INV - cccp.mu*(cccp.W+cccp.Y-cccp.Z+cccp.B);
[V,D] = eig(M);
d = diag(D);
sig = ((d.^2+4*cccp.mu).^0.5 - d)/(2*cccp.mu);
Sigma = diag(sig);
S = V*Sigma*V';
S = (S + S') / 2; % make S symmetric
cccp.X_pre = cccp.X;
cccp.X = cccp.W - S;

end