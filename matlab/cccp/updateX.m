function cccp = updateX(cccp)

INV = inv(cccp.W-cccp.X+cccp.Y);
INV = (INV + INV') / 2;
M = 2*INV - 2*cccp.mu*(cccp.W-cccp.Z+cccp.B);
[V,D] = eig(M);
d = diag(D);
sig = ((d.^2+8*cccp.mu).^0.5 - d)/(4*cccp.mu);
Sigma = diag(sig);
S = V*Sigma*V';
S = (S + S') / 2; % make S symmetric
cccp.X_pre = cccp.X;
cccp.X = cccp.W - S;

end